`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 10:36:12
// Design Name: 
// Module Name: image_read
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "parameter.v"

module image_read
#(
    parameter WIDTH = 768,
              HEIGHT = 512,
              INFILE = `INPUTFILENAME,
              START_UP_DELAY = 100,
              HSYNC_DELAY = 160,
              VALUE = 100,
              THRESHOLD = 90,
              SIGN = 1
)
(
    input HCLK,
    input HRESETn,
    output VSYNC,
    output reg HSYNC,
    output reg [7:0] DATA_R0, DATA_G0, DATA_B0,
    output reg [7:0] DATA_R1, DATA_G1, DATA_B1,
    output ctrl_done
);

    // Internal parameters
    localparam sizeOfLengthReal = WIDTH*HEIGHT*3; 
    localparam ST_IDLE = 2'b00, ST_VSYNC = 2'b01, ST_HSYNC = 2'b10, ST_DATA = 2'b11;

    // FSM signals
    reg [1:0] cstate, nstate;
    reg start;
    reg HRESETn_d;
    reg ctrl_vsync_run, ctrl_hsync_run, ctrl_data_run;
    reg [8:0] ctrl_vsync_cnt, ctrl_hsync_cnt;

    // Memory to store image data
    reg [7:0] total_memory [0:sizeOfLengthReal-1];
    integer temp_BMP [0:sizeOfLengthReal-1];
    integer org_R [0:WIDTH*HEIGHT-1];
    integer org_G [0:WIDTH*HEIGHT-1];
    integer org_B [0:WIDTH*HEIGHT-1];

    integer i, j;
    integer tempR0, tempR1, tempG0, tempG1, tempB0, tempB1;
    integer value, value1, value2, value4;

    reg [9:0] row;
    reg [10:0] col;
    reg [18:0] data_count;

    //----------------- Read image hex file -----------------
    initial begin
    $readmemh("D:/my data/VLSI design/Verilog/Projects/FPGA_Image_Processing/FPGA_Image_Processing.srcs/sources_1/new/input.hex",
              total_memory, 0, sizeOfLengthReal-1);
end


    //----------------- Save RGB separately -----------------
    always @(start) begin
        if(start) begin
            for(i=0; i<WIDTH*HEIGHT*3; i=i+1)
                temp_BMP[i] = total_memory[i][7:0];

            for(i=0;i<HEIGHT;i=i+1)
                for(j=0;j<WIDTH;j=j+1) begin
                    org_R[WIDTH*i+j] = temp_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+0];
                    org_G[WIDTH*i+j] = temp_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+1];
                    org_B[WIDTH*i+j] = temp_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+2];
                end
        end
    end

    //----------------- Start pulse -----------------
    always @(posedge HCLK or negedge HRESETn) begin
        if(!HRESETn) begin
            start <= 0;
            HRESETn_d <= 0;
        end else begin
            HRESETn_d <= HRESETn;
            start <= (HRESETn && !HRESETn_d) ? 1'b1 : 1'b0;
        end
    end

    //----------------- FSM -----------------
    always @(posedge HCLK or negedge HRESETn)
        if(!HRESETn) cstate <= ST_IDLE;
        else cstate <= nstate;

    always @(*) begin
        case(cstate)
            ST_IDLE: nstate = start ? ST_VSYNC : ST_IDLE;
            ST_VSYNC: nstate = (ctrl_vsync_cnt == START_UP_DELAY) ? ST_HSYNC : ST_VSYNC;
            ST_HSYNC: nstate = (ctrl_hsync_cnt == HSYNC_DELAY) ? ST_DATA : ST_HSYNC;
            ST_DATA: nstate = ctrl_done ? ST_IDLE : ((col == WIDTH-2) ? ST_HSYNC : ST_DATA);
        endcase
    end

    always @(*) begin
        ctrl_vsync_run = (cstate == ST_VSYNC);
        ctrl_hsync_run = (cstate == ST_HSYNC);
        ctrl_data_run  = (cstate == ST_DATA);
    end

    always @(posedge HCLK or negedge HRESETn) begin
        if(!HRESETn) begin
            ctrl_vsync_cnt <= 0;
            ctrl_hsync_cnt <= 0;
        end else begin
            ctrl_vsync_cnt <= ctrl_vsync_run ? ctrl_vsync_cnt + 1 : 0;
            ctrl_hsync_cnt <= ctrl_hsync_run ? ctrl_hsync_cnt + 1 : 0;
        end
    end

    always @(posedge HCLK or negedge HRESETn) begin
        if(!HRESETn) begin
            row <= 0;
            col <= 0;
        end else if(ctrl_data_run) begin
            if(col == WIDTH-2) row <= row + 1;
            col <= (col == WIDTH-2) ? 0 : col + 2;
        end
    end

    always @(posedge HCLK or negedge HRESETn) begin
        if(!HRESETn) data_count <= 0;
        else if(ctrl_data_run) data_count <= data_count + 1;
    end

    assign VSYNC = ctrl_vsync_run;
    assign ctrl_done = (data_count == (WIDTH*HEIGHT/2)-1);

    //----------------- Image Processing -----------------
    always @(*) begin
        HSYNC = 0;
        DATA_R0 = 0; DATA_G0 = 0; DATA_B0 = 0;
        DATA_R1 = 0; DATA_G1 = 0; DATA_B1 = 0;

        if(ctrl_data_run) begin
            HSYNC = 1;

            `ifdef BRIGHTNESS_OPERATION
                tempR0 = SIGN ? org_R[WIDTH*row+col]+VALUE : org_R[WIDTH*row+col]-VALUE;
                tempR1 = SIGN ? org_R[WIDTH*row+col+1]+VALUE : org_R[WIDTH*row+col+1]-VALUE;
                DATA_R0 = (tempR0>255)?255:(tempR0<0)?0:tempR0;
                DATA_R1 = (tempR1>255)?255:(tempR1<0)?0:tempR1;

                tempG0 = SIGN ? org_G[WIDTH*row+col]+VALUE : org_G[WIDTH*row+col]-VALUE;
                tempG1 = SIGN ? org_G[WIDTH*row+col+1]+VALUE : org_G[WIDTH*row+col+1]-VALUE;
                DATA_G0 = (tempG0>255)?255:(tempG0<0)?0:tempG0;
                DATA_G1 = (tempG1>255)?255:(tempG1<0)?0:tempG1;

                tempB0 = SIGN ? org_B[WIDTH*row+col]+VALUE : org_B[WIDTH*row+col]-VALUE;
                tempB1 = SIGN ? org_B[WIDTH*row+col+1]+VALUE : org_B[WIDTH*row+col+1]-VALUE;
                DATA_B0 = (tempB0>255)?255:(tempB0<0)?0:tempB0;
                DATA_B1 = (tempB1>255)?255:(tempB1<0)?0:tempB1;
            `endif

            `ifdef INVERT_OPERATION
                value2 = (org_R[WIDTH*row+col]+org_G[WIDTH*row+col]+org_B[WIDTH*row+col])/3;
                DATA_R0 = 255 - value2; DATA_G0 = 255 - value2; DATA_B0 = 255 - value2;

                value4 = (org_R[WIDTH*row+col+1]+org_G[WIDTH*row+col+1]+org_B[WIDTH*row+col+1])/3;
                DATA_R1 = 255 - value4; DATA_G1 = 255 - value4; DATA_B1 = 255 - value4;
            `endif

            `ifdef THRESHOLD_OPERATION
                value = (org_R[WIDTH*row+col]+org_G[WIDTH*row+col]+org_B[WIDTH*row+col])/3;
                {DATA_R0, DATA_G0, DATA_B0} = (value > THRESHOLD) ? 24'hFFFFFF : 24'h000000;

                value1 = (org_R[WIDTH*row+col+1]+org_G[WIDTH*row+col+1]+org_B[WIDTH*row+col+1])/3;
                {DATA_R1, DATA_G1, DATA_B1} = (value1 > THRESHOLD) ? 24'hFFFFFF : 24'h000000;
            `endif
        end
    end
endmodule

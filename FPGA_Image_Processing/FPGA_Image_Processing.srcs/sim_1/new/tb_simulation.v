`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 10:40:58
// Design Name: 
// Module Name: tb_simulation
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


`include "D:/my data/VLSI design/Verilog/Projects/FPGA_Image_Processing/FPGA_Image_Processing.srcs/sources_1/new/parameter.v"

module tb_simulation;

    reg HCLK, HRESETn;
    wire VSYNC, HSYNC;
    wire [7:0] DATA_R0, DATA_G0, DATA_B0;
    wire [7:0] DATA_R1, DATA_G1, DATA_B1;
    wire ctrl_done;
    wire Write_Done;

    image_read u_image_read (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .VSYNC(VSYNC),
        .HSYNC(HSYNC),
        .DATA_R0(DATA_R0),
        .DATA_G0(DATA_G0),
        .DATA_B0(DATA_B0),
        .DATA_R1(DATA_R1),
        .DATA_G1(DATA_G1),
        .DATA_B1(DATA_B1),
        .ctrl_done(ctrl_done)
    );

    image_write u_image_write (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .hsync(HSYNC),
        .DATA_WRITE_R0(DATA_R0),
        .DATA_WRITE_G0(DATA_G0),
        .DATA_WRITE_B0(DATA_B0),
        .DATA_WRITE_R1(DATA_R1),
        .DATA_WRITE_G1(DATA_G1),
        .DATA_WRITE_B1(DATA_B1),
        .Write_Done(Write_Done)
    );

    // Clock
    initial begin
        HCLK = 0;
        forever #10 HCLK = ~HCLK; // 50 MHz
    end

    // Reset
    initial begin
        HRESETn = 0;
        #25 HRESETn = 1;
    end
endmodule

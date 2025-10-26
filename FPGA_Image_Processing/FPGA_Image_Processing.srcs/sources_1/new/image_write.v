`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 10:39:54
// Design Name: 
// Module Name: image_write
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

module image_write
#(
    parameter WIDTH = 768,
              HEIGHT = 512,
              BMP_HEADER_NUM = 54,
              INFILE = `OUTPUTFILENAME
)
(
    input HCLK,
    input HRESETn,
    input hsync,
    input [7:0] DATA_WRITE_R0, DATA_WRITE_G0, DATA_WRITE_B0,
    input [7:0] DATA_WRITE_R1, DATA_WRITE_G1, DATA_WRITE_B1,
    output reg Write_Done
);

    // --------------------------
    // Module-level declarations
    // --------------------------
    reg [7:0] BMP_header [0:BMP_HEADER_NUM-1];
    reg [7:0] out_BMP [0:WIDTH*HEIGHT*3-1];  // store pixel bytes
    integer fd;
    integer pixel_index;
    integer i;
    integer filesize;
    integer row, col, idx;

    // --------------------------
    // Initialize BMP header
    // --------------------------
    initial begin
        pixel_index = 0;
        filesize = BMP_HEADER_NUM + WIDTH*HEIGHT*3;

        // BMP file header
        BMP_header[0] = 8'h42; // 'B'
        BMP_header[1] = 8'h4D; // 'M'
        BMP_header[2] = filesize        & 8'hFF;
        BMP_header[3] = (filesize>>8)  & 8'hFF;
        BMP_header[4] = (filesize>>16) & 8'hFF;
        BMP_header[5] = (filesize>>24) & 8'hFF;
        BMP_header[6] = 0; BMP_header[7] = 0;
        BMP_header[8] = 0; BMP_header[9] = 0;
        BMP_header[10] = 54; BMP_header[11] = 0; BMP_header[12] = 0; BMP_header[13] = 0; // Pixel data offset

        // DIB header
        BMP_header[14] = 40; BMP_header[15] = 0; BMP_header[16] = 0; BMP_header[17] = 0; // DIB header size
        BMP_header[18] = WIDTH        & 8'hFF;
        BMP_header[19] = (WIDTH>>8)  & 8'hFF;
        BMP_header[20] = (WIDTH>>16) & 8'hFF;
        BMP_header[21] = (WIDTH>>24) & 8'hFF;
        BMP_header[22] = HEIGHT        & 8'hFF;
        BMP_header[23] = (HEIGHT>>8)  & 8'hFF;
        BMP_header[24] = (HEIGHT>>16) & 8'hFF;
        BMP_header[25] = (HEIGHT>>24) & 8'hFF;
        BMP_header[26] = 1; BMP_header[27] = 0; // planes
        BMP_header[28] = 24; BMP_header[29] = 0; // bits per pixel

        for(i=30; i<54; i=i+1)
            BMP_header[i] = 0; // rest of header zero
    end

    // --------------------------
    // Collect pixels on hsync
    // --------------------------
    always @(posedge hsync) begin
        if(pixel_index < WIDTH*HEIGHT*3) begin
            // Convert RGB to BGR for BMP format
            out_BMP[pixel_index]   = DATA_WRITE_B0;
            out_BMP[pixel_index+1] = DATA_WRITE_G0;
            out_BMP[pixel_index+2] = DATA_WRITE_R0;
            pixel_index = pixel_index + 3;

            out_BMP[pixel_index]   = DATA_WRITE_B1;
            out_BMP[pixel_index+1] = DATA_WRITE_G1;
            out_BMP[pixel_index+2] = DATA_WRITE_R1;
            pixel_index = pixel_index + 3;
        end
    end

    // --------------------------
    // Write BMP file after reset
    // --------------------------
    always @(posedge HRESETn) begin
        #1000; // wait for pixels to be collected

        fd = $fopen("output.bmp", "wb"); // write in current directory
        if(fd == 0) begin
            $display("ERROR: Cannot open output file!");
            Write_Done = 0;
        end else begin
            // Write header
            for(i=0; i<BMP_HEADER_NUM; i=i+1)
                $fwrite(fd, "%c", BMP_header[i]);

            // Write pixel data bottom-to-top
            for(row=HEIGHT-1; row>=0; row=row-1) begin
                for(col=0; col<WIDTH; col=col+1) begin
                    idx = (row*WIDTH + col)*3;
                    $fwrite(fd, "%c", out_BMP[idx]);
                    $fwrite(fd, "%c", out_BMP[idx+1]);
                    $fwrite(fd, "%c", out_BMP[idx+2]);
                end
            end

            $fclose(fd);
            Write_Done = 1;
            $display("Output BMP written successfully.");
        end
    end

endmodule

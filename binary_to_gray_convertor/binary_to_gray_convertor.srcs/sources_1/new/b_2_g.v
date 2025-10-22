`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2025 11:07:14
// Design Name: 
// Module Name: b_2_g
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


module b_2_g #(parameter N = 8)(
    input  [N-1:0] in,
    output [N-1:0] out
);
    assign out[N-1] = in[N-1];
    genvar i;
    generate
        for (i = N-2; i >= 0; i = i - 1)
            assign out[i] = in[i+1] ^ in[i];
    endgenerate
endmodule


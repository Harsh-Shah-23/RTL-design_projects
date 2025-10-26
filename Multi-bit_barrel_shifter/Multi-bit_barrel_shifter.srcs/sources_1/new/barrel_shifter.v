`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2025 11:39:12
// Design Name: 
// Module Name: barrel_shifter
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


module barrel_shifter #(parameter K = 8)(
    input [K-1:0] data,
    input [$clog2(K) - 1 : 0] shift,
    input left,
    output reg [K-1 : 0] q
    );
    always @(*) begin
        if (left)
            q = data << shift;
        else
            q = data >> shift;
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 12:32:42
// Design Name: 
// Module Name: clac
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


module clac(
    input add,
    input sub,
    input mul,
    input div,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] q
    );
    
    always @(*) begin
        if (add)
            q = a + b;
        else if (sub)
            q = a-b;
        else if (mul)
            q = a*b;
        else if (div) begin
            if( b != 0)
                q = a/b ;
            else
                q = 8'd0;
        end
        else 
            q = 8'b0;
    end
endmodule

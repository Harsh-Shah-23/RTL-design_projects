`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 15:21:00
// Design Name: 
// Module Name: tb_calc
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


module tb_calc;
    reg a,s,m,d;
    reg [7:0] x,y;
    wire [15:0] q;
    
    clac uut(
        .add(a),
        .sub(s),
        .mul(m),
        .div(d),
        .a(x),
        .b(y),
        .q(q)
        );
        
    initial begin
    a = 0; s = 0;m = 0;d = 0;x = 8'b10110010; y = 8'b10001101;
    
    #10 a = 1; s = 0;m = 0;d = 0;
    #10 a = 0; s = 1;m = 0;d = 0;
    #10 a = 0; s = 0;m = 1;d = 0;
    #10 a = 0; s = 0;m = 0;d = 1;
    
    #10 $finish;
    end
    
    initial begin
    $monitor("Time = %0t |add = %b|Sub = %b|Mul = %b|Div = %b|Num1 = %b|Num2 = %b|output = %b",$time,a,s,m,d,x,y,q);
    end
    
endmodule

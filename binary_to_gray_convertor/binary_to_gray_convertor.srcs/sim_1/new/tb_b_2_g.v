`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 15:38:54
// Design Name: 
// Module Name: tb_b_2_g
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


module tb_b_2_g;
    parameter N = 8;
    reg [N-1:0] in;
    wire [N-1:0] out;
    
    b_2_g #(N) uut(
        .in(in),
        .out(out)
    );
    
    initial begin
        // Test different binary inputs
        in = 8'b00000000; #10;
        in = 8'b00000001; #10;
        in = 8'b00000010; #10;
        in = 8'b00000100; #10;
        in = 8'b00001000; #10;
        in = 8'b00010000; #10;
        in = 8'b00100000; #10;
        in = 8'b01000000; #10;
        in = 8'b10000000; #10;
        in = 8'b11111111; #10;
        
        #10 $finish;
    end
    
    initial begin
        $monitor("Time = %0t | Binary Input = %b | Gray Output = %b", 
                  $time, in, out);
    end
endmodule

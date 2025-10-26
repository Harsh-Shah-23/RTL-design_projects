`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 15:40:13
// Design Name: 
// Module Name: tb_barrel_shifter
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


module tb_barrel_shifter;
    parameter K = 8;
    reg [K-1:0] data;
    reg [$clog2(K)-1:0] shift;
    reg left;
    wire [K-1:0] q;
    
    barrel_shifter #(K) uut(
        .data(data),
        .shift(shift),
        .left(left),
        .q(q)
    );
    
    initial begin
        // Initialize inputs
        data = 8'b10110101; left = 1; shift = 0;
        
        // Left shifts
        #10 shift = 1;
        #10 shift = 2;
        #10 shift = 3;
        #10 shift = 4;
        
        // Right shifts
        #10 left = 0; shift = 1;
        #10 shift = 2;
        #10 shift = 3;
        #10 shift = 4;
        
        #10 $finish;
    end
    
    initial begin
        $monitor("Time = %0t | data = %b | shift = %d | left = %b | output = %b", 
                  $time, data, shift, left, q);
    end
endmodule
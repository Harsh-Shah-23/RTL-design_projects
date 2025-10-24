`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 15:45:00
// Design Name: 
// Module Name: tb_up_down_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for up_down_counter
// 
// Dependencies: up_down_counter.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_up_down_counter;
    reg clk;
    reg reset;
    reg up_count;
    wire [7:0] q;
    
    up_down_counter uut(
        .clk(clk),
        .reset(reset),
        .up_count(up_count),
        .q(q)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end
    
    // Stimulus
    initial begin
        reset = 1; up_count = 1; #10;   // Reset active
        reset = 0;
        
        // Count up
        up_count = 1;
        #100;
        
        // Count down
        up_count = 0;
        #100;
        
        // Apply reset again
        reset = 1;
        #10;
        reset = 0;
        
        #20 $finish;
    end
    
    // Monitor output
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | up_count = %b | count = %b", 
                  $time, clk, reset, up_count, q);
    end
endmodule

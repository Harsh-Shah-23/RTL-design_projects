`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 15:41:23
// Design Name: 
// Module Name: tb_traffic_light_controller
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



module tb_traffic_light_controller;
    reg clk;
    reg reset;
    wire y;
    
    traffic_light_controller uut(
        .clk(clk),
        .reset(reset),
        .y(y)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end
    
    // Stimulus
    initial begin
        reset = 1; #10;
        reset = 0; #10;
        
        // Let the traffic light run for multiple cycles
        #200;
        
        // Apply reset again
        reset = 1; #10;
        reset = 0; #10;
        
        #50 $finish;
    end
    
    // Monitor output
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | green_light = %b", 
                  $time, clk, reset, y);
    end
endmodule
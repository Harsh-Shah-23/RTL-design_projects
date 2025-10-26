`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 15:42:29
// Design Name: 
// Module Name: tb_washing_machine_controller
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


module tb_washing_machine_controller;
    reg clk;
    reg reset;
    reg start;
    wire motor_on;
    wire valve_on;
    wire done;
    
    washing_machine_controller uut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .motor_on(motor_on),
        .valve_on(valve_on),
        .done(done)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end
    
    // Stimulus
    initial begin
        reset = 1; start = 0; #10;
        reset = 0; start = 1; #10;  // Start washing machine
        
        // Let the machine run through all stages
        #200;
        
        // Stop/start sequence
        start = 0; #20;
        start = 1; #50;
        
        // Apply reset in the middle
        reset = 1; #10;
        reset = 0; start = 1; #100;
        
        #20 $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | start = %b | motor_on = %b | valve_on = %b | done = %b", 
                  $time, clk, reset, start, motor_on, valve_on, done);
    end
endmodule
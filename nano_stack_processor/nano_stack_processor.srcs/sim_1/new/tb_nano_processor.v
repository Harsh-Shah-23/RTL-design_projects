`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 10:15:44
// Design Name: 
// Module Name: tb_nano_processor
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


module tb_nano_processor;

    reg clk, rst;
    wire [7:0] result_out;
    wire done;

    // Instantiate UUT
    nano_processor uut (
        .clk(clk), .rst(rst),
        .result_out(result_out), .done(done)
    );

    // Clock (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Init
        clk = 0; rst = 1;
        #20 rst = 0; // Release Reset

        // Wait for Done signal
        wait(done == 1);
        #20; // Hold for a moment
        
        if (result_out == 6) $display("SUCCESS: Result is 6");
        else $display("FAIL: Result is %d", result_out);
        
        $finish;
    end

endmodule
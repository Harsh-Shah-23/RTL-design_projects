`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 10:13:51
// Design Name: 
// Module Name: stack
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

module stack (
    input clk, rst,
    input push,        // Normal Push
    input pop,         // Normal Pop
    input alu_op,      // Special: Writes result to (SP-1) and decrements SP
    input [7:0] data_in,
    output [7:0] top_val,    // Data at SP
    output [7:0] second_val  // Data at SP-1
);

    reg [7:0] mem [0:15]; // 16-deep stack
    reg [3:0] sp;         // Stack Pointer

    // Continuous assignment for reading
    assign top_val = mem[sp];
    assign second_val = mem[sp-1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            mem[0] <= 0; // Clear bottom
        end else begin
            if (push) begin
                sp <= sp + 1;
                mem[sp + 1] <= data_in;
            end 
            else if (pop) begin
                sp <= sp - 1;
            end
            else if (alu_op) begin
                // ALU Operation: Reads top two, writes result to second, drops top.
                // Effectively: Pop A, Pop B, Push Result
                mem[sp - 1] <= data_in; 
                sp <= sp - 1;
            end
        end
    end
endmodule
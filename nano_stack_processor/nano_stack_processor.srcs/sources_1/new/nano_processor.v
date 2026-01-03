`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 10:14:48
// Design Name: 
// Module Name: nano_processor
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

module nano_processor (
    input clk, rst,
    output reg [7:0] result_out, // Debug: View top of stack
    output reg done
);

    // --- Signals ---
    reg [3:0] pc;           
    reg [7:0] instruction;  
    
    // Stack Control Signals
    reg push_en, pop_en, alu_op_en;
    reg [7:0] stack_in;
    wire [7:0] top_val, second_val;

    // Instantiate Stack
    stack my_stack (
        .clk(clk), .rst(rst),
        .push(push_en), .pop(pop_en), .alu_op(alu_op_en),
        .data_in(stack_in),
        .top_val(top_val), .second_val(second_val)
    );

    // --- Program Memory (ROM) ---
    // Program: 5 + 3 - 2 = 6
    always @(*) begin
        case(pc)
            4'd0: instruction = {4'b0001, 4'd5}; // PUSH 5
            4'd1: instruction = {4'b0001, 4'd3}; // PUSH 3
            4'd2: instruction = {4'b0010, 4'd0}; // ADD
            4'd3: instruction = {4'b0001, 4'd2}; // PUSH 2
            4'd4: instruction = {4'b0011, 4'd0}; // SUB
            4'd5: instruction = {4'b1111, 4'd0}; // STOP
            default: instruction = 8'h00;
        endcase
    end

    // --- FSM States ---
    parameter FETCH = 0, EXECUTE = 1;
    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
            state <= FETCH;
            done <= 0;
            push_en <= 0; pop_en <= 0; alu_op_en <= 0;
        end else begin
            case (state)
                FETCH: begin
                    push_en <= 0; pop_en <= 0; alu_op_en <= 0; // Reset signals
                    if (instruction[7:4] == 4'b1111) done <= 1; // STOP
                    else state <= EXECUTE;
                end

                EXECUTE: begin
                    case(instruction[7:4]) // Decode Opcode
                        4'b0001: begin // PUSH
                            stack_in <= instruction[3:0]; 
                            push_en <= 1;
                        end
                        4'b0010: begin // ADD
                            stack_in <= second_val + top_val; // ALU Logic
                            alu_op_en <= 1; // Update Stack
                        end
                        4'b0011: begin // SUB
                            stack_in <= second_val - top_val; // ALU Logic
                            alu_op_en <= 1; // Update Stack
                        end
                    endcase
                    pc <= pc + 1;
                    state <= FETCH;
                end
            endcase
        end
    end
    
    // Debug Output (Assign Top of Stack to Output)
    always @(*) result_out = top_val;

endmodule
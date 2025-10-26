`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 11:07:26
// Design Name: 
// Module Name: traffic_light_controller
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


module traffic_light_controller(
    input clk,
    input reset,
    output reg y
    );
    
    parameter red = 2'b00, yellow = 2'b01, green = 2'b10;
    reg [3:0] q;
    reg x;
    reg [1:0] state, next_state;
    
    always @(posedge clk) begin
        if(reset)begin
           q <= 4'b0;
           x <= 0;
        end else begin    
            if( q == 4'b1001)begin
                q <= 4'b0;
                x <= 1;
            end    
            else begin
                q <= q + 1;
                x <=0 ;
            end
        end
    end
    
    always @(*) begin
        case(state)
            red: next_state = x ? yellow : red;
            yellow: next_state = x ? green : yellow;
            green: next_state = x ? red : green;
            default: next_state = red;
        endcase
    end
    
    always@(posedge clk) begin
        if(reset)
            state <= red;
        else
            state <= next_state;
    end
    
    always @(*) begin
        case(state)
            red: y <= 0;
            yellow: y <= 0;
            green: y <= 1;
            default: y <= 0;
        endcase
    end

endmodule

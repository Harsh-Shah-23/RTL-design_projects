`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 17:02:52
// Design Name: 
// Module Name: up_down_counter
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


module up_down_counter(
    input clk,
    input reset,
    input up_count,
    output reg [7:0] q
    );
    
    always @(posedge clk)begin
        if (reset)
            q <= 8'b0;
        else begin
            if(up_count)begin
                if (q == 8'b10101010)
                    q <= 8'b0;
                else
                    if (q[3:0] == 4'b1001) begin
                        q[3:0] <= 4'b0;
                        q[7:4] <= q[7:4] + 1'b1;
                    end
                    else
                        q <= q + 1;
            end
            else begin
                if (q[3:0] == 4'b0) begin
                    q[7:4] <= q[7:4] - 1;
                    q[3:0] <= 4'b1001;
                end
                else
                    q <= q - 1;
            end
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 11:46:38
// Design Name: 
// Module Name: washing_machine_controller
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


module washing_machine_controller (
    input clk,
    input reset,
    input start,
    output reg motor_on,
    output reg valve_on,
    output reg done
);

    parameter idle = 3'b000,
              fill_water = 3'b001,
              wash = 3'b010,
              rinse = 3'b011,
              spin = 3'b100,
              finish = 3'b101;

    reg [2:0] state, next_state;
    reg [3:0] count;       
    reg timer_done;

    function [3:0] get_limit;
        input [2:0] s;
        case (s)
            fill_water: get_limit = 4'd5;  // 5 cycles
            wash:       get_limit = 4'd10; // 10 cycles
            rinse:      get_limit = 4'd6;  // 6 cycles
            spin:       get_limit = 4'd8;  // 8 cycles
            default:    get_limit = 4'd0;
        endcase
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timer_done <= 0;
        end else begin
            if (state == idle || state == finish) begin
                count <= 0;
                timer_done <= 0;
            end else if (count == get_limit(state)) begin
                count <= 0;
                timer_done <= 1;  // time completed for this stage
            end else begin
                count <= count + 1;
                timer_done <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            idle:       next_state = start ? fill_water : idle;
            fill_water: next_state = timer_done ? wash : fill_water;
            wash:       next_state = timer_done ? rinse : wash;
            rinse:      next_state = timer_done ? spin : rinse;
            spin:       next_state = timer_done ? finish : spin;
            finish:     next_state = idle;
            default:    next_state = idle;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= idle;
        else
            state <= next_state;
    end

    always @(*) begin
    
        motor_on = 0;
        valve_on = 0;
        done = 0;

        case (state)
            idle:       begin motor_on = 0; valve_on = 0; done = 0; end
            fill_water: begin motor_on = 0; valve_on = 1; done = 0; end
            wash:       begin motor_on = 1; valve_on = 0; done = 0; end
            rinse:      begin motor_on = 1; valve_on = 1; done = 0; end
            spin:       begin motor_on = 1; valve_on = 0; done = 0; end
            finish:     begin motor_on = 0; valve_on = 0; done = 1; end
        endcase
    end

endmodule


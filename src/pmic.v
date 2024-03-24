`timescale 1ns / 1ps

module pmic(
    input clk,
    input reset,
    input on_sw,
    input lb_sw,
    input lp_sw,
    input [4:0] T,
    output reg [4:0] sel,
    output reg ld,
    output reg [2:0] mode,
    output reg ready
    );
    
    reg [3:0] c_state;
    reg [3:0] n_state;
    reg [4:0] start;
    
    parameter IDLE = 4'b0000;
    parameter ON_3_3 = 4'b0001;
    parameter ON_2_5 = 4'b0010;
    parameter ON_1_2 = 4'b0011;
    parameter ACTIVE = 4'b0100;
    parameter OFF_3_3 = 4'b0101;
    parameter OFF_2_5 = 4'b0110;
    parameter OFF_1_2 = 4'b0111;
    parameter LB_STATE = 4'b1000;
    parameter LP_STATE = 4'b1001;
    
    parameter start_T1   = 5'b00001;
    parameter start_T2   = 5'b00010;
    parameter start_T3   = 5'b00100;
    parameter start_T4   = 5'b01000;
    parameter start_T5   = 5'b10000;
    parameter start_NULL = 5'b00000;
    
    always@(*)begin
    case(c_state)
        IDLE: begin
            if(on_sw)
                n_state = ON_3_3;
            else
                n_state = IDLE;
            start = start_NULL;
        end
        ON_3_3: begin
            n_state = ON_2_5;
            start = start_T1;
        end
        ON_2_5: begin
            if(T[0])begin
                if(mode[0])begin
                    n_state = ACTIVE;
                    start = start_NULL;
                end
                else begin
                    n_state = ON_1_2;
                    start = start_T2;
                end
            end
            else begin
                n_state = ON_2_5;
                start = start_NULL;
            end
        end
        ON_1_2: begin
            if(T[1])begin
                if(mode[2:1] == 2'b00)
                    n_state = LP_STATE;
                else
                    n_state = ACTIVE;
            end
            else
                n_state = ON_1_2;
            start = start_NULL;
        end
        ACTIVE: begin
            if(!on_sw || lb_sw) begin
                n_state = OFF_1_2;
                start = start_T3;
            end
            else if(lp_sw) begin
                n_state = OFF_2_5;
                start = start_T4;  
            end
            else begin
                n_state = ACTIVE;
                start = start_NULL;
            end
        end
        OFF_3_3: begin
            if(T[4])begin
                if(!on_sw)
                    n_state = IDLE;
                else if(lb_sw)
                    n_state = LB_STATE;
                else if(lp_sw)
                    n_state = LP_STATE;
                else
                    n_state = ON_3_3;
            end
            else
                n_state = OFF_3_3;
            start = start_NULL;
        end
        OFF_2_5: begin
            if(T[3])begin
                n_state = OFF_3_3;
                start = start_T5;
            end
            else begin
                n_state = OFF_2_5;
                start  = start_NULL;
            end
        end
        OFF_1_2: begin
            if(T[2])begin
                if(mode[2:1] != 2'b00)begin
                    n_state = OFF_2_5;
                    start = start_T4;
                end
                else begin
                    if(on_sw)
                        n_state = LB_STATE;
                    else
                        n_state = IDLE;
                    start = start_NULL;
                end
            end
            else begin
                n_state = OFF_1_2;
                start  = start_NULL;
            end
        end
        LB_STATE: begin
            if(!on_sw) begin
                n_state = IDLE;
                start = start_NULL;
            end
            else if(lb_sw) begin
                n_state = LB_STATE;
                start = start_NULL;
            end
            else if(lp_sw) begin
                n_state = ON_1_2;
                start = start_T2;
            end
            else begin
                n_state = ON_3_3;
                start = start_NULL;
            end
        end
        LP_STATE: begin
            if(!on_sw || lb_sw) begin
                n_state = OFF_1_2;
                start = start_T3;
            end
            else if(!lp_sw) begin
                n_state = ON_3_3;
                start = start_NULL;
            end
            else begin
                n_state = LP_STATE;
                start = start_NULL;
            end
        end
        default: begin
            n_state = IDLE;
            start = start_NULL;
        end
    endcase
    end
    
    always@(posedge clk or posedge reset)begin
    if(reset)
        c_state <= IDLE;
    else 
        c_state <= n_state;
    end
    
    always@(posedge clk or posedge reset)begin
    if(reset)begin
        sel <= start_NULL;
        ld <= 0;
    end
    else begin
        sel <= start;
        if(start == start_T1 || start == start_T2 || start == start_T3 || start == start_T4 || start == start_T5)
            ld <= 1;
        else
            ld <= 0;
    end
    end
    
    always@(posedge clk or posedge reset)begin
    if(reset) begin
        mode <= 3'b000;
        ready <= 1'b0;
    end
    else begin
        if(c_state == ON_3_3)
            mode <= mode | 3'b100;
        else if(c_state == ON_2_5 && T[0])
            mode <= mode | 3'b010;
        else if(c_state == ON_1_2 && T[1])
            mode <= mode | 3'b001;
        else if(c_state == OFF_3_3 && T[4])
            mode <= mode & 3'b011;
        else if(c_state == OFF_2_5 && T[3])
            mode <= mode & 3'b101;
        else if(c_state == OFF_1_2 && T[2])
            mode <= mode & 3'b110;
            
        if(c_state == ACTIVE)
            ready <= 1'b1;
        else
            ready <= 1'b0;
    end
    end
    
endmodule

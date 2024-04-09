`timescale 1ns / 1ps

module timer(
    input clk,
    input reset,
    input ld, 
    input [4:0] sel,
    output reg [4:0] T
    );
    
    reg [31:0] limit;
    reg [31:0] counter;
    reg [4:0] en;
    
    parameter T1 = 5; //100000000;
    parameter T2 = 6; //150000000;
    parameter T3 = 5; //100000000;
    parameter T4 = 3; //50000000;
    parameter T5 = 3; //50000000;
    
    always@(*)begin
    case(sel)
        5'b00000: limit = T1;
        5'b00001: limit = T1;
        5'b00010: limit = T2;
        5'b00100: limit = T3;
        5'b01000: limit = T4;
        5'b10000: limit = T5;
        default:  limit = T1;
    endcase
    end
    
    always@(posedge clk, posedge reset)begin
    if(reset)begin
        counter <= 0;
        en <= 5'b00000;
        T <= 5'b00000;
    end
    else begin
        if(ld && !(|en))begin
            counter <= limit;
            en <= sel;
            T <= 5'b00000;
        end
        else if(counter == 0)begin
            counter <=0;
            en <= 5'b00000;
            T <= en;
        end
        else if(|en)
            counter <= counter - 1;
        else
            T <= 5'b00000;
    end
    end
    
endmodule

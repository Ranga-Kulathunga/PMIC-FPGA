`timescale 1ns / 1ps

module main(
    input clk,
    input reset,
    input on_sw,
    input lb_sw,
    input lp_sw,
    output [3:0] led,
    output [3:0] SSG_EN
    );
    
    wire [4:0] sel;
    wire [4:0] T;
    wire ld;
    
    pmic pmic_inst(
        .clk    (clk),
        .reset  (reset),
        .on_sw  (on_sw),
        .lb_sw  (lb_sw),
        .lp_sw  (lp_sw),
        .T      (T),
        .sel    (sel),
        .ld     (ld),
        .mode   (led[2:0]),
        .ready  (led[3])
    );
    
    timer timer_inst(
        .clk    (clk),
        .reset  (reset),
        .ld     (ld),
        .sel    (sel),
        .T      (T)
    );
    
    assign SSG_EN  =   4'b1111;   // disable the 7-segment LEDs
    
endmodule

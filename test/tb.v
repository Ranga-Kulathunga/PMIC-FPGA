`timescale 1ns / 1ps

module tb();

    parameter half_cycle = 5;
    
    reg clk;
    reg reset;
    reg on_sw;
    reg lb_sw;
    reg lp_sw;
    wire [3:0] led;
    wire [3:0] SSG_EN;

    // generate clock
    always
    #half_cycle clk=!clk;
   
    main test(clk , reset , on_sw , lb_sw , lp_sw , led, SSG_EN);
   
    initial begin
    clk <= 1'b0;
    reset <= 1'b1;
    on_sw <= 1'b0;
    lb_sw <= 1'b0;
    lp_sw <= 1'b0;
   
    // TEST 1:
    // power up and power down sequences with ON_OFF switch
    #(2*half_cycle) reset <= 1'b0;
    #(2*half_cycle) on_sw <= 1'b1;
    #(30*half_cycle) on_sw <= 1'b0;
    
    // TEST 2:
    #(30*half_cycle) reset <= 1'b1;
    #(2*half_cycle) reset <= 1'b0;
    #(2*half_cycle) on_sw <= 1'b1;
    // Active state to LP mode
    #(30*half_cycle) lp_sw <= 1'b1;
    // LP mode to LB mode
    #(20*half_cycle) lb_sw <= 1'b1;
    // LB mode to LP mode
    #(20*half_cycle) lb_sw <= 1'b0;
    // LP mode to Active state
    #(20*half_cycle) lp_sw <= 1'b0;
    #(30*half_cycle) on_sw <= 1'b0;
    
    // TEST 3:
    #(30*half_cycle) reset <= 1'b1;
    #(2*half_cycle) reset <= 1'b0;
    #(2*half_cycle) on_sw <= 1'b1;
    // Active state to LB mode
    #(30*half_cycle) lb_sw <= 1'b1;
    // LB mode to LP mode
    #(30*half_cycle) lp_sw <= 1'b1;
    #(2*half_cycle) lb_sw <= 1'b0;
    // LP mode to LB mode
    #(20*half_cycle) lb_sw <= 1'b1;
    #(2*half_cycle) lp_sw <= 1'b0;
    // LB mode to Active state
    #(20*half_cycle) lb_sw <= 1'b0;
    #(30*half_cycle) on_sw <= 1'b0;

    // TEST 4:
    #(30*half_cycle) reset <= 1'b1;
    #(2*half_cycle) reset <= 1'b0;
    #(2*half_cycle) on_sw <= 1'b1;
    // Active state to LB mode
    #(30*half_cycle) lb_sw <= 1'b1;
    // LB mode to IDLE
    #(30*half_cycle) on_sw <= 1'b0;
    
    // TEST 5:
    #(20*half_cycle) reset <= 1'b1;
    #(2*half_cycle) reset <= 1'b0;
    #(2*half_cycle) lb_sw <= 1'b0;
    #(2*half_cycle) on_sw <= 1'b1;
    // Active state to LP mode
    #(30*half_cycle) lp_sw <= 1'b1;
    // LP mode to IDLE
    #(30*half_cycle) on_sw <= 1'b0;
    
    #(300*half_cycle) $finish ;
    
    end
endmodule

`include "constants.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: top.v                                                           --
//--                                                                            --
//-- DATE: 9/30/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--                                                                            --
//-- DESCRIPTION: top                                                           --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module top (
    input CLOCK_50,

    input [3:0] KEY,
    input [9:0] SW,

    output [7:0] LEDG,
    output [9:0] LEDR,

    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

/*--============================================================--*/
/*--                        KEY MAPPINGS                        --*/
/*--============================================================--*/

    assign clk = CLOCK_50;
    assign rst = ~(KEY[0]);

    assign start = SW[0];
    
/*--============================================================--*/
/*--                    RANDOM NUMBER GENERATOR                 --*/
/*--============================================================--*/

    wire [7:0] rand_num;

    rng rng (
        .clk(clk),
        .rst(rst),
        .start(start),
        .out(rand_num)
    );

/*--============================================================--*/
/*--                        DIVIDE BY THREE                     --*/
/*--============================================================--*/

    wire [7:0] div_num;

    divide_by_three divider1 (
        .dividend(rand_num),
        .quotient(div_num)
    );

/*--============================================================--*/
/*--                          SUM THREE                         --*/
/*--============================================================--*/

    wire [7:0] sum_val;

    sum_3 sum_3 (
        .clk(clk),
        .rst(rst),
        .in(div_num),
        .out(sum_val)
    );

    assign LEDR [7:0] = sum_val;

/*--============================================================--*/
/*--                          COUNTER                           --*/
/*--============================================================--*/

    wire [3:0] ET0;
    wire [3:0] ET1;
    wire [3:0] ET2;
    wire [3:0] ET3;
    wire [3:0] ET4;
    wire [3:0] ET5;
    wire [3:0] ET6;
    wire [3:0] ET7;
    wire [3:0] ET8;
    wire [3:0] ET9;
    wire [3:0] ET10;
    
    wire [3:0] cur_e;

    wire [3:0] seg_0;
    wire [3:0] seg_1;
    wire [3:0] seg_2;
    wire [3:0] seg_3;

    seven_seg s_0 (seg_0, HEX0);
    seven_seg s_1 (seg_1, HEX1);
    seven_seg s_2 (seg_2, HEX2);
    seven_seg s_3 (seg_3, HEX3);

    counter counter (clk, rst, ET0, ET1, ET2, ET3,
                     ET4, ET5, ET6, ET7, ET8, ET9, 
                     ET10, cur_e);

    disp_mux disp_m (start, ET0, ET1, ET2, ET3, ET4,
                     ET5, ET6, ET7, ET8, ET9, ET10, 
                     cur_exp, seg_0, seg_1, seg_2, seg_3);
    
endmodule

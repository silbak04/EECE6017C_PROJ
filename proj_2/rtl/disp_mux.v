`include "constants.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: disp_mux.v                                                      --
//--                                                                            --
//-- DATE: 9/30/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--                                                                            --
//-- DESCRIPTION: displays muxes                                                --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module disp_mux (
    input rst,
    input start,

    input [3:0] ET0,
    input [3:0] ET1,
    input [3:0] ET2,
    input [3:0] ET3,
    input [3:0] ET4,
    input [3:0] ET5,
    input [3:0] ET6,
    input [3:0] ET7,
    input [3:0] ET8,
    input [3:0] ET9,
    input [3:0] ET10,

    input [3:0] cur_exp,
    input [7:0] sum_val,

    output [3:0] seg_0,
    output [3:0] seg_1,
    output [3:0] seg_2,
    output [3:0] seg_3,

    output [7:0] sum
);

    parameter OFF = 0;
    reg run = 0;

    always @ (posedge start, posedge rst) begin
        if (rst) run = 0;
        else run = ~run;
    end

    assign seg_0 =
        (run) ? cur_exp : `BCD_BLANK;

    assign seg_1 =
        (run) ? `BCD_E   : `BCD_BLANK;

    assign seg_2 = 
        (run) ? (cur_exp == `BCD_0 ? ET0[3:0] :
                 cur_exp == `BCD_1 ? ET1[3:0] :
                 cur_exp == `BCD_2 ? ET2[3:0] :
                 cur_exp == `BCD_3 ? ET3[3:0] :
                 cur_exp == `BCD_4 ? ET4[3:0] :
                 cur_exp == `BCD_5 ? ET5[3:0] :
                 cur_exp == `BCD_6 ? ET6[3:0] :
                 cur_exp == `BCD_7 ? ET7[3:0] :
                 cur_exp == `BCD_8 ? ET8[3:0] :
                 cur_exp == `BCD_9 ? ET9[3:0] :
                 `BCD_BLANK) : `BCD_BLANK;

    assign seg_3 =
        (run) ? (cur_exp == `BCD_0 ? ET1[3:0]  :
                 cur_exp == `BCD_1 ? ET2[3:0]  :
                 cur_exp == `BCD_2 ? ET3[3:0]  :
                 cur_exp == `BCD_3 ? ET4[3:0]  :
                 cur_exp == `BCD_4 ? ET5[3:0]  :
                 cur_exp == `BCD_5 ? ET6[3:0]  :
                 cur_exp == `BCD_6 ? ET7[3:0]  :
                 cur_exp == `BCD_7 ? ET8[3:0]  :
                 cur_exp == `BCD_8 ? ET9[3:0]  :
                 cur_exp == `BCD_9 ? ET10[3:0] :
                 `BCD_BLANK) : `BCD_BLANK;

    assign sum = 
        (run) ? (sum_val) : OFF;

endmodule

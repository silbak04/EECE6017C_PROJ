`include "top_header.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: top.v                                                           --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           silbak04@gmail.com                                               --
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
    assign clk = CLOCK_50;
    assign rst = KEY[3];

/*--============================================================--*/
/*--                BCD and 7-Seg Display Driver                --*/
/*--============================================================--*/

    assign sign_on = SW[9];
    assign bcd_input = KEY[0];
    
    reg sign_mode;
    assign LEDG[0] = sign_mode;
    //wire clk_1;

    /* Multiplexers */
    wire [3:0] tenths_digit;
    wire [3:0] units_digit;
    wire [3:0] tens_digit;

    /* bcd outputs from bcd module */
    wire [3:0] bcd_tenths;
    wire [3:0] bcd_units;
    wire [3:0] bcd_tens;

    wire [3:0] sign;
    wire [3:0] bcd_cnt;

    /* instantiates bcd module */
    bcd_module bcd_numbers (
        .rst(rst),
        .sign_on(sign_on),
        .bcd_input(bcd_input),
        .bcd_num(SW),
        .bcd_tenths(bcd_tenths),
        .bcd_units(bcd_units),
        .bcd_tens(bcd_tens),
        .bcd_cnt(bcd_cnt),
        .sign_mode(sign_mode),
        .sign(sign)
    );

    /* if bcd count is satisfied go ahead and assign the switches
        to the mux output which will get displayed onto the 7 seg,
            otherwise bcd number will be displayed onto the 7 seg */
    assign tenths_digit = (bcd_cnt == 0) ? SW[3:0] : bcd_tenths;
    assign units_digit = (bcd_cnt == 1) ? SW[3:0] : bcd_units;
    assign tens_digit = (bcd_cnt == 2) ? SW[3:0] : bcd_tens;

    /* instantiates four 7-seg displays */
    seven_seg display_0 (tenths_digit, HEX0);
    seven_seg display_1 (units_digit, HEX1);
    seven_seg display_2 (tens_digit, HEX2);
    seven_seg display_3 (sign, HEX3);
     
    /*clk_div in_sig_1 (
        .clk_1(clk)
    );*/

   /* debug seven segment display */
   // assign HEX0 = SW; 

/*--============================================================--*/
/*--                    TEMPERATURE READING                     --*/
/*--============================================================--*/

    /* outputs from temp_state module */
    wire normal;
    wire border_line;
    wire warning;
    wire emergency;

    assign LEDR[0] = normal;
    assign LEDR[1] = border_line;
    assign LEDR[2] = warning;
    assign LEDR[3] = emergency;

    //wire sign_change;
    //assign sign_change = (sign_on) ? 1'b1 : 1'b0;
    reg sign_change = 0;
    reg temp = 0;

    /* instantiates temperature states */
    temp_state temp_reading (
        .rst(rst),
        .bcd_units(bcd_units),
        .bcd_tens(bcd_tens),
        .normal(normal),
        .border_line(border_line),
        .warning(warning),
        .emergency(emergency)
    );

endmodule

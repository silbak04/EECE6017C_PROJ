`include "constants.vh"

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

/*--============================================================--*/
/*--                BCD and 7-Seg Display Driver                --*/
/*--============================================================--*/

    assign clk = CLOCK_50;
    assign rst = ~(KEY[3]);

    assign sign_on = SW[9];
    assign bcd_input = ~(KEY[0]);
    
    wire sign_mode;
    assign LEDG[0] = sign_mode;

    /* bcd outputs from bcd input module */
    wire [3:0] temp_ones_value;
    wire [3:0] temp_tens_value;
    wire [3:0] temp_huns_value;

    wire [3:0] ones_value;
    wire [3:0] tens_value;
    wire [3:0] huns_value;

    wire [3:0] sign;
    wire [1:0] bcd_press;

    wire clk_1;
    //wire pwm;

    wire [3:0] bcd_num = SW[3:0];
    wire [3:0] track_inp;

    assign LEDG[4] = track_inp[0];
    assign LEDG[5] = track_inp[1];
    assign LEDG[6] = track_inp[2];
    assign LEDG[7] = track_inp[3];


    /* if bcd count is satisfied go ahead and assign the switches
        to the mux output which will get displayed onto the 7 seg,
            otherwise bcd number will be displayed onto the 7 seg */

    wire [3:0] ones_value_digit = (bcd_press == 0) ? bcd_num : ones_value;
    wire [3:0] tens_value_digit = (bcd_press == 1) ? bcd_num : tens_value;
    wire [3:0] huns_value_digit = (bcd_press == 2) ? bcd_num : huns_value; 

    /* toggle the display between the value of the bcd and the off display */
    wire [3:0] ones_value_digit_flash = (clk_1) ? ones_value_digit : `OFF;
    wire [3:0] tens_value_digit_flash = (clk_1) ? tens_value_digit : `OFF;
    wire [3:0] huns_value_digit_flash = (clk_1) ? huns_value_digit : `OFF;

    wire [3:0] flash_ones = ones_value_digit_flash;
    wire [3:0] flash_tens = tens_value_digit_flash;
    wire [3:0] flash_huns = huns_value_digit_flash;

    /* toggles the display between bcd and off depending on which 7 seg display
    you're one */
    wire [3:0] ones_value_digit_off = (bcd_press > 0) ? ones_value : `OFF;
    wire [3:0] tens_value_digit_off = (bcd_press > 1) ? tens_value : `OFF;
    wire [3:0] huns_value_digit_off = (bcd_press > 2) ? huns_value : `OFF; 

    wire [3:0] flash_ones_display = (bcd_press == 0) ? flash_ones : ones_value_digit_off;
    wire [3:0] flash_tens_display = (bcd_press == 1) ? flash_tens : tens_value_digit_off;
    wire [3:0] flash_huns_display = (bcd_press == 2) ? flash_huns : huns_value_digit_off;

    /* instantiates bcd input module */
    bcd_in bcd_in (
        .rst(rst),
        .bcd_num(bcd_num),

        .temp_ones_value(temp_ones_value),
        .temp_tens_value(temp_tens_value),
        .temp_huns_value(temp_huns_value),

        .ones_value(ones_value),
        .tens_value(tens_value),
        .huns_value(huns_value),

        .sign(sign),
        .sign_on(sign_on),
        .sign_mode(sign_mode),

        .bcd_input(bcd_input),
        .bcd_press(bcd_press),
        .track_inp(track_inp)
    );

    /* instantiates four 7-seg displays */
    seven_seg s_0 (flash_ones_display, HEX0);
    seven_seg s_1 (flash_tens_display, HEX1);
    seven_seg s_2 (flash_huns_display, HEX2);
    seven_seg s_3 (sign, HEX3);

    /* ~1 hz clock */
    clk_div one_hz_sig (clk, rst, clk_1);

    /*pulse_width pulse_wm (
        .clk(clk),
        .pwm(pwm)
    );*/

   /* debug seven segment display */
   // assign HEX0 = SW; 

/*--============================================================--*/
/*--                    TEMPERATURE READING                     --*/
/*--============================================================--*/

    /* outputs from temp_state module */
    wire normal;
    wire border;
    wire warning;
    wire emergency;

    /* output which state we're in onto the leds */
    assign LEDR[0] = normal;
    assign LEDR[1] = border;
    assign LEDR[2] = warning;
    assign LEDR[3] = emergency;

    /* instantiates temperature states */
    temp_state temp_reading (
        .rst(rst),

        .temp_tens_value(temp_tens_value),
        .temp_huns_value(temp_huns_value),

        .tens_value(tens_value),
        .huns_value(huns_value),

        .normal(normal),
        .border(border),
        .warning(warning),
        .emergency(emergency)
    );

/*--============================================================--*/
/*--                        BCD SUBTRACTOR                      --*/
/*--============================================================--*/

    /* outputs from the bcd subtractor module */
    wire [3:0] out_ones;
    wire [3:0] out_tens;
    wire [3:0] out_huns;

    bcd_subtractor subtractor (
        .x_ones(ones_value),
        .x_tens(tens_value),
        .x_huns(huns_value),

        .y_ones(temp_ones_value),
        .y_tens(temp_tens_value),
        .y_huns(temp_huns_value),

        .out_ones(out_ones),
        .out_tens(out_tens),
        .out_huns(out_huns)
    );
    
endmodule

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
//--           John Brady                                                       --
//--           Nick Foltz                                                       --
//--           Camiren Stewart                                                  --
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
    
    wire curr_sign_mode;
    //assign LEDG[0] = curr_sign_mode;

    /* bcd outputs from bcd input module */
    wire [3:0] save_temp_ones_value;
    wire [3:0] save_temp_tens_value;
    wire [3:0] save_temp_huns_value;

    wire [3:0] curr_ones_value;
    wire [3:0] curr_tens_value;
    wire [3:0] curr_huns_value;

    wire [3:0] sign;
    wire [2:0] bcd_press;

    wire clk_1;
    wire got_value;
    wire [2:0] diff_read;

    wire [3:0] bcd_num = SW[3:0];
    wire [3:0] track_inp;

    /* keeps track of the bcd input */
    //assign LEDG[7:4] = bcd_press;
    //assign LEDG[3:0] = out_tens;
    //assign LEDR[0] = got_value;

/*--============================================================--*/
/*--                        MULTIPLEXERS                        --*/
/*--============================================================--*/

    /* if bcd count is satisfied go ahead and assign the switches
        to the mux output which will get displayed onto the 7 seg,
            otherwise bcd number will be displayed onto the 7 seg */

    wire [3:0] ones_value_digit = (bcd_press == 0) ? bcd_num : curr_ones_value;
    wire [3:0] tens_value_digit = (bcd_press == 1) ? bcd_num : curr_tens_value;
    wire [3:0] huns_value_digit = (bcd_press == 2) ? bcd_num : curr_huns_value; 

    /* toggles the display between the value of the bcd and the off display */
    wire [3:0] ones_value_digit_flash = (clk_1) ? ones_value_digit : `OFF;
    wire [3:0] tens_value_digit_flash = (clk_1) ? tens_value_digit : `OFF;
    wire [3:0] huns_value_digit_flash = (clk_1) ? huns_value_digit : `OFF;

    wire [3:0] flash_ones = ones_value_digit_flash;
    wire [3:0] flash_tens = tens_value_digit_flash;
    wire [3:0] flash_huns = huns_value_digit_flash;

    /* toggles the display between bcd and off depending on which 7 seg display
    you're one */
    wire [3:0] ones_value_digit_off = (bcd_press > 0) ? curr_ones_value : `OFF;
    wire [3:0] tens_value_digit_off = (bcd_press > 1) ? curr_tens_value : `OFF;
    wire [3:0] huns_value_digit_off = (bcd_press > 2) ? curr_huns_value : `OFF; 

    wire [3:0] flash_ones_display = (bcd_press == 0) ? flash_ones : ones_value_digit_off;
    wire [3:0] flash_tens_display = (bcd_press == 1) ? flash_tens : tens_value_digit_off;
    wire [3:0] flash_huns_display = (bcd_press == 2) ? flash_huns : huns_value_digit_off;

    /* instantiates bcd input module */
    bcd_in bcd_in (
        .rst(rst),
        .bcd_num(bcd_num),

        .diff_read(diff_read),
        .got_value(got_value),

        .save_temp_ones_value(save_temp_ones_value),
        .save_temp_tens_value(save_temp_tens_value),
        .save_temp_huns_value(save_temp_huns_value),

        .curr_ones_value(curr_ones_value),
        .curr_tens_value(curr_tens_value),
        .curr_huns_value(curr_huns_value),

        .sign(sign),
        .sign_on(sign_on),
        .curr_sign_mode(curr_sign_mode),
        .temp_sign_mode(temp_sign_mode),

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

/*--============================================================--*/
/*--                    TEMPERATURE READING                     --*/
/*--============================================================--*/

    /* outputs from temp_state module */
    wire [9:0] alarm;
    wire [3:0] state;

    assign LEDR = (clk_1) ? alarm : `BLANK_ALARM;
    assign LEDG = (clk_1) ? state : `BLANK_STATE;

    /* instantiates temperature states */
    temp_state temp_state (
        .rst(rst),
        .bcd_press(bcd_press),

        .diff_read(diff_read),
        .got_value(got_value),

        .state(state),

        .curr_ones_value(curr_ones_value),
        .curr_tens_value(curr_tens_value),
        .curr_huns_value(curr_huns_value),

        .curr_sign_mode(curr_sign_mode),
        .temp_sign_mode(temp_sign_mode),

        .out_ones(out_ones),
        .out_tens(out_tens),
        .out_huns(out_huns),

        .alarm(alarm)
    );

/*--============================================================--*/
/*--                        BCD SUBTRACTOR                      --*/
/*--============================================================--*/

    /* outputs from the bcd subtractor module */
    wire [3:0] out_ones;
    wire [3:0] out_tens;
    wire [3:0] out_huns;

    bcd_subtractor subtractor (
        .x_ones(curr_ones_value),
        .x_tens(curr_tens_value),
        .x_huns(curr_huns_value),

        .y_ones(save_temp_ones_value),
        .y_tens(save_temp_tens_value),
        .y_huns(save_temp_huns_value),

        .out_ones(out_ones),
        .out_tens(out_tens),
        .out_huns(out_huns)
    );
    
endmodule

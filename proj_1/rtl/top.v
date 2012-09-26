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
    
    assign LEDG[4] = sign_mode_changed;


    /* bcd outputs from bcd input module */
    wire [3:0] save_temp_ones_value;
    wire [3:0] save_temp_tens_value;
    wire [3:0] save_temp_huns_value;

    wire [3:0] temp_ones_value;
    wire [3:0] temp_tens_value;
    wire [3:0] temp_huns_value;

    wire [3:0] curr_ones_value;
    wire [3:0] curr_tens_value;
    wire [3:0] curr_huns_value;

    wire sign_mode_changed;

    wire [3:0] sign;

    wire [2:0] bcd_press;
    assign LEDG[7:5] = bcd_press;

    wire got_value;
    //assign LEDG[7] = got_value;

    wire clk_1;

    wire [2:0] diff_read;

    wire [3:0] bcd_num = SW[3:0];

    wire negative;

    wire [2:0] counter = 0;

    /* keeps track of the bcd input */
    //wire [3:0] track_inp;
    //assign LEDG[3:0] = out_tens;

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

    /* output 1 */
    wire [3:0] flash_ones_display = (bcd_press == 0) ? flash_ones : ones_value_digit_off;
    wire [3:0] flash_tens_display = (bcd_press == 1) ? flash_tens : tens_value_digit_off;
    wire [3:0] flash_huns_display = (bcd_press == 2) ? flash_huns : huns_value_digit_off;

    wire [3:0] flash_ones_diff_display = (bcd_press == 3) ? out_ones : `OFF;
    wire [3:0] flash_tens_diff_display = (bcd_press == 3) ? out_tens : `OFF;
    wire [3:0] flash_huns_diff_display = (bcd_press == 3) ? out_huns : `OFF;

    /* output 2 */
    wire [3:0] flash_toggle_ones = (bcd_press == 3) ? flash_ones_diff_display : flash_ones_display;
    wire [3:0] flash_toggle_tens = (bcd_press == 3) ? flash_tens_diff_display : flash_tens_display;
    wire [3:0] flash_toggle_huns = (bcd_press == 3) ? flash_huns_diff_display : flash_huns_display;

    /*wire [3:0] flash_ones_diff_display_0 = (clk_1) ? flash_ones_diff_display : `OFF;
    wire [3:0] flash_tens_diff_display_1 = (clk_1) ? flash_tens_diff_display : `OFF;
    wire [3:0] flash_huns_diff_display_2 = (clk_1) ? flash_huns_diff_display : `OFF;*/

    /*wire [3:0] flash_toggle_ones_disp = (bcd_press > 0) ? curr_ones_value : flash_toggle_ones;
    wire [3:0] flash_toggle_tens_disp = (bcd_press > 1) ? curr_tens_value : flash_toggle_tens;
    wire [3:0] flash_toggle_huns_disp = (bcd_press > 2) ? curr_huns_value : flash_toggle_huns;*/


    //wire [3:0] sign_sw_check = (sign_on == 1) ? `NEGATIVE : sign_check;

    reg [2:0] disp_state = 0;
    always @(posedge clk_2) begin
        disp_state = disp_state + 1;
        if (disp_state == 4)
            disp_state = 0;
    end

    wire [3:0] s_0_value;
    wire [3:0] s_1_value;
    wire [3:0] s_2_value;
    wire [3:0] s_3_value;

    assign s_0_value =
        (bcd_press == 0)  ? bcd_num:
        (bcd_press == 1)  ? curr_ones_value :
        (bcd_press == 2)  ? curr_ones_value :
        (disp_state == 0) ? temp_ones_value :
        (disp_state == 2) ? out_ones :
        `OFF;

    assign s_1_value =
        (bcd_press == 0)  ? `OFF:
        (bcd_press == 1)  ? bcd_num :
        (bcd_press == 2)  ? curr_tens_value :
        (disp_state == 0) ? temp_tens_value :
        (disp_state == 2) ? out_tens : 
        `OFF;

    assign s_2_value =
        (bcd_press == 0)  ? `OFF:
        (bcd_press == 1)  ? `OFF :
        (bcd_press == 2)  ? bcd_num :
        (disp_state == 0) ? temp_huns_value :
        (disp_state == 2) ? out_huns : 
        `OFF;

    assign s_3_value =
        (bcd_press == 0)  ? (sign_on ? `NEGATIVE : `OFF) :
        (bcd_press == 1)  ? (sign_on ? `NEGATIVE : `OFF) :
        (bcd_press == 2)  ? (sign_on ? `NEGATIVE : `OFF) :
        (disp_state == 0) ? (sign_on ? `NEGATIVE : `OFF) :
        (disp_state == 2) ? (negative ? `NEGATIVE: `OFF) :
        `OFF;


    wire s_0_en = (bcd_press == 0) ? clk_1 : 1;
    wire s_1_en = (bcd_press == 1) ? clk_1 : 1;
    wire s_2_en = (bcd_press == 2) ? clk_1 : 1;
    wire s_3_en = 1'b1;

    seven_seg s_0 (s_0_value, HEX0, s_0_en);
    seven_seg s_1 (s_1_value, HEX1, s_1_en);
    seven_seg s_2 (s_2_value, HEX2, s_2_en);
    seven_seg s_3 (s_3_value, HEX3, s_3_en);

    /* instantiates bcd input module */
    bcd_in bcd_in (
        .rst(rst),
        .bcd_num(bcd_num),

        .diff_read(diff_read),
        .got_value(got_value),

        .save_temp_ones_value(save_temp_ones_value),
        .save_temp_tens_value(save_temp_tens_value),
        .save_temp_huns_value(save_temp_huns_value),

        .temp_ones_value(temp_ones_value),
        .temp_tens_value(temp_tens_value),
        .temp_huns_value(temp_huns_value),

        .curr_ones_value(curr_ones_value),
        .curr_tens_value(curr_tens_value),
        .curr_huns_value(curr_huns_value),

        .sign_on(sign_on),
        .sign_mode_changed(sign_mode_changed),

        .bcd_input(bcd_input),
        .bcd_press(bcd_press)
        //.track_inp(track_inp)
    );


    /* ~1 hz clock */
    clk_div one_hz_sig (clk, rst, clk_1, clk_2);

/*--============================================================--*/
/*--                    TEMPERATURE MONITOR                     --*/
/*--============================================================--*/

    /* outputs from temp_state module */
    wire [9:0] alarm;
    wire [3:0] state;

    assign LEDR = (clk_1) ? alarm : `BLANK_ALARM;

    assign LEDG [3:0] = (clk_1) ? state : `BLANK_STATE;

    /* instantiates temperature states */
    temp_state temp_state (
        .rst(rst),
        .bcd_press(bcd_press),

        .diff_read(diff_read),
        .got_value(got_value),

        .state(state),

        .temp_ones_value(temp_ones_value),
        .temp_tens_value(temp_tens_value),
        .temp_huns_value(temp_huns_value),

        .sign_mode_changed(sign_mode_changed),

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
        .x_ones(save_temp_ones_value),
        .x_tens(save_temp_tens_value),
        .x_huns(save_temp_huns_value),

        .y_ones(temp_ones_value),
        .y_tens(temp_tens_value),
        .y_huns(temp_huns_value),

        .out_ones(out_ones),
        .out_tens(out_tens),
        .out_huns(out_huns),

        .negative(negative)
    );
    
endmodule

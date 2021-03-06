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

    wire clk_1;
    assign clk = CLOCK_50;
    assign rst = ~(KEY[3]);

    assign sign_on = SW[9];
    assign LEDG[7] = sign_on;
    assign bcd_input = ~(KEY[0]);
    
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

    wire [3:0] sign;
    wire got_value;
    wire sign_mode_changed;

    wire [2:0] bcd_press;
    assign LEDG[6:4] = bcd_press;

    wire [3:0] bcd_num = SW[3:0];

    wire negative;

/*--============================================================--*/
/*--                        MULTIPLEXERS                        --*/
/*--============================================================--*/

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

    seven_seg s_0 (s_0_value, s_0_en, HEX0);
    seven_seg s_1 (s_1_value, s_1_en, HEX1);
    seven_seg s_2 (s_2_value, s_2_en, HEX2);
    seven_seg s_3 (s_3_value, s_3_en, HEX3);

    /* instantiates bcd input module */
    bcd_in bcd_in (
        .rst(rst),
        .bcd_num(bcd_num),

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

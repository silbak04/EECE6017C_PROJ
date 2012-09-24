`include "constants.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: bcd_in.v                                                        --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           John Brady                                                       --
//--           Nick Foltz                                                       --
//--           Camiren Stewart                                                  --
//--                                                                            --
//-- DESCRIPTION: takes bcd input for ones, tens, and huns place                --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module bcd_in (
    input rst,
    input sign_on,

    input bcd_input,
    input [3:0] bcd_num,

    output reg [3:0] save_temp_ones_value = 0,
    output reg [3:0] save_temp_tens_value = 0,
    output reg [3:0] save_temp_huns_value = 0,

    output reg [3:0] curr_ones_value = 0,
    output reg [3:0] curr_tens_value = 0,
    output reg [3:0] curr_huns_value = 0,

    output reg [2:0] bcd_press = 0,
    output reg [3:0] track_inp = 1,

    output reg [2:0] diff_read = 0,

    output reg got_value = 0,

    output reg [3:0] sign,

    output reg curr_sign_mode = 0,
    output reg temp_sign_mode = 0
);

    reg [3:0] temp_ones_value = 0;
    reg [3:0] temp_tens_value = 0;
    reg [3:0] temp_huns_value = 0;

    always @ (posedge bcd_input or posedge rst) begin

        /* If reset button is released */
        if (rst) begin

            /* reset all registers */
            curr_ones_value = 0;
            curr_tens_value = 0;
            curr_huns_value = 0;

            temp_ones_value = 0;
            temp_tens_value = 0;
            temp_huns_value = 0;

            save_temp_ones_value = 0;
            save_temp_tens_value = 0;
            save_temp_huns_value = 0;

            bcd_press = 0;
            track_inp = 1;

            diff_read = 0;
            got_value = 0;

        /* Else if input button is released */
        /* Takes 4 button presses to receive temperature reading */
        end else if (bcd_input) begin

            if (bcd_press == 0) begin

                curr_ones_value = bcd_num;
                got_value = 0;

            end

            if (bcd_press == 1) curr_tens_value = bcd_num;

            if (bcd_press == 2) begin
                
                curr_huns_value = bcd_num;

                save_temp_ones_value = temp_ones_value;
                save_temp_tens_value = temp_tens_value;
                save_temp_huns_value = temp_huns_value;

                temp_ones_value = curr_ones_value;
                temp_tens_value = curr_tens_value;
                temp_huns_value = curr_huns_value;

                temp_sign_mode = curr_sign_mode;

                got_value = 1;

                diff_read = diff_read + 1;

                if (diff_read > 2) diff_read = 2;

                track_inp = 1;

            end

                if (bcd_press == 3) got_value = 1;

                /* increment bcd input and track
                it onto the leds */
                bcd_press = bcd_press + 1;

                if (bcd_press == 5) bcd_press = 0;

        end

    end

    always @ (sign_on) begin

        if (sign_on) begin

            sign = `NEGATIVE;
            curr_sign_mode = 1;

        end else begin

            sign = `OFF;
            curr_sign_mode = 0;

        end

    end

endmodule

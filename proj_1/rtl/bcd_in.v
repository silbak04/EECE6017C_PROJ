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

    output reg [3:0] temp_ones_value = 0,
    output reg [3:0] temp_tens_value = 0,
    output reg [3:0] temp_huns_value = 0,

    output reg [3:0] curr_ones_value = 0,
    output reg [3:0] curr_tens_value = 0,
    output reg [3:0] curr_huns_value = 0,

    output reg [2:0] bcd_press = 0,
    output reg [3:0] track_inp = 1,

    output reg [3:0] sign,
    output reg curr_sign_mode = 0,
    output reg temp_sign_mode = 0
);

    always @ (posedge bcd_input or posedge rst) begin

        if (rst) begin

            /* reset all registers */
            curr_ones_value = 0;
            curr_tens_value = 0;
            curr_huns_value = 0;

            temp_ones_value = 0;
            temp_tens_value = 0;
            temp_huns_value = 0;

            bcd_press = 0;
            track_inp = 1;

        end else if (bcd_input) begin

            if (bcd_press == 0) curr_ones_value = bcd_num;
            if (bcd_press == 1) curr_tens_value = bcd_num;
            if (bcd_press == 2) curr_huns_value = bcd_num;

            /* increment bcd input and track
            it onto the leds */
            bcd_press = bcd_press + 1;
            track_inp = track_inp << 1;

            if (bcd_press == 4) begin 

                temp_ones_value = curr_ones_value;
                temp_tens_value = curr_tens_value;
                temp_huns_value = curr_huns_value;

                temp_sign_mode = curr_sign_mode;

                bcd_press = 0;
                track_inp = 1;

            end

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

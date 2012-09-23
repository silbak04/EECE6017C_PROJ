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
//--           silbak04@gmail.com                                               --
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

    output reg [3:0] ones_value = 0,
    output reg [3:0] tens_value = 0,
    output reg [3:0] huns_value = 0,

    output reg [1:0] bcd_press = 0,
    output reg [3:0] track_inp = 1,

    output reg [3:0] sign,
    output reg sign_mode
);

    always @ (posedge bcd_input or posedge rst) begin

        if (rst) begin

            /* reset all registers */
            ones_value = 0;
            tens_value = 0;
            huns_value = 0;

            bcd_press = 0;
            track_inp = 1;

        end else if (bcd_input) begin

            if (bcd_press == 0) ones_value = bcd_num;
            if (bcd_press == 1) tens_value = bcd_num;
            if (bcd_press == 2) huns_value = bcd_num;

            bcd_press = bcd_press + 1;
            track_inp = track_inp << 1;

            if (bcd_press == 3) begin 

                temp_ones_value = ones_value;
                temp_tens_value = tens_value;
                temp_huns_value = huns_value;

                bcd_press = 0;
                track_inp = 1;

            end

        end

    end

    always @ (sign_on) begin

        if (sign_on) begin

            sign = `NEGATIVE;
            sign_mode = 1;

        end else begin

            sign = `OFF;
            sign_mode = 0;

        end

    end

endmodule

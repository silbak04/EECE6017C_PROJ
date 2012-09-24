`include "constants.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: temp_state.v                                                    --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           John Brady                                                       --
//--           Nick Foltz                                                       --
//--           Camiren Stewart                                                  --
//--                                                                            --
//-- DESCRIPTION: handles each temperature states appropriately                 --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module temp_state (
    input rst,
    input [2:0] bcd_press,

    input curr_sign_mode,
    input temp_sign_mode,

    input [3:0] out_ones,
    input [3:0] out_tens,
    input [3:0] out_huns,

    input [3:0] curr_ones_value,
    input [3:0] curr_tens_value,
    input [3:0] curr_huns_value,

    output reg [9:0] alarm = 0
);

    reg sign_change = 0;

    wire [11:0] curr_total = {(curr_huns_value), (curr_tens_value), (curr_ones_value)};
    wire [11:0] diff_total = {(out_huns), (out_tens), (out_ones)};

    always @ (*) begin

        if (rst) alarm = 0;

        if (bcd_press == 3'd3) begin

            /* checks to see if temperature is between 0 and 39.0 */
            if (curr_total >= 12'h000 && 
                curr_total <= 12'h390)

                alarm = 10'b0000000000;

            /* checks to see if temperature is between 39.1 and 46.0 */
            else if (curr_total >= 12'h391 && 
                     curr_total <= 12'h460)

                alarm = 10'b0000000000;

            /* checks to see if temperature is between 46.1 and 49.0 */
            else if (curr_total >= 12'h461 && 
                     curr_total <= 12'h490)

                alarm = 10'b1010101010;

            /* checks to see if temperature is 49.1 degrees or greater */
            else if (curr_total >= 12'h491)
                
               alarm = 10'b1111111111;

        end

        /* checks if a sign change has occurred */
        sign_change = temp_sign_mode ^ curr_sign_mode;

        if (sign_change == 1) alarm = 10'b1111111111;

        if (bcd_press == 4) begin

            if (diff_total >= 12'h050) alarm = 10'b1111111111;

        end

    end

endmodule

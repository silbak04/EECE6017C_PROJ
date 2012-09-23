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
//--           silbak04@gmail.com                                               --
//--                                                                            --
//-- DESCRIPTION: handles each temperature states appropriately                 --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module temp_state (
    input rst,

    input [3:0] sign,

    input [3:0] temp_tens_value,
    input [3:0] temp_huns_value,

    input [3:0] tens_value,
    input [3:0] huns_value,

    output reg normal = 0,
    output reg border = 0,
    output reg warning = 0,
    output reg emergency = 0
);

    reg diff_tens = 0;
    reg diff_huns = 0;

    reg sign_change = 0;
    reg temp_change = 0;

    always @ (*) begin

        if (rst) begin

            normal = 0;
            border = 0;
            warning = 0;
            emergency = 0;

        end else begin

            /*if (sign_on) sign_change = 1;
                else */

            /*diff_tens = (tens_value - temp_tens_value);
            diff_huns = (huns_value - temp_huns_value);*/

            /* checks to see if temperature is between 0 and 39 */
            if (huns_value >= 0 && huns_value < 4 && tens_value >= 0 && tens_value <= 9) begin

                border = 0;
                warning = 0;
                emergency = 0;
                normal = 1;

            end

            /* checks to see if temperature is between 40 and 46 */
            else if (huns_value == 4 && tens_value >= 0 && tens_value < 7) begin 

                normal = 0;
                warning = 0;
                emergency = 0;
                border = 1;

            end

            /* checks to see if temperature is between 47 and 49 */
            else if (huns_value == 4 && tens_value >= 7 && tens_value <= 9) begin

                normal = 0;
                border = 0;
                emergency = 0;
                warning = 1;

            end

            /* checks to see if temperature is 50 degrees or greater or if we had a sign change */
            else if ((huns_value >= 5 && tens_value >= 0) || (diff_tens >= 5) || (diff_tens <= -5) || 
                    (diff_huns < 0) || (diff_huns > 0) || (sign_change != temp_change)) begin 

                normal = 0;
                border = 0;
                warning = 0;
                emergency = 1;

                /*if (sign_change != temp_change) begin

                    normal = 0;
                    border = 0;
                    warning = 0;
                    emergency = 1;

                end*/

            end

        end

    end

endmodule

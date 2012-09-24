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
    input [2:0] diff_read,
    
    input got_value,

    input curr_sign_mode,
    input temp_sign_mode,

    input [3:0] out_ones,
    input [3:0] out_tens,
    input [3:0] out_huns,

    input [3:0] curr_ones_value,
    input [3:0] curr_tens_value,
    input [3:0] curr_huns_value,

    output reg [3:0] state = 1,

    output reg [9:0] alarm = 0
);

    reg sign_change = 0;

    parameter NORMAL    = 4'b0001;
    parameter BORDER    = 4'b0010;
    parameter WARNING   = 4'b0100;
    parameter EMERGENCY = 4'b1000;

    //reg STATE = NORMAL;

    wire [11:0] curr_total = {(curr_huns_value), (curr_tens_value), (curr_ones_value)};
    wire [11:0] diff_total = {(out_huns), (out_tens), (out_ones)};

    always @ (posedge got_value) begin

        if (rst) begin 

            alarm = 0;
            state = NORMAL;

        end

        /* checks to see if temperature is between 0 and 40.0 */
        if (curr_total >= 12'h000 && 
            curr_total <= 12'h400) begin

            alarm = 10'b0000000000;
            state = NORMAL;

        end

        /* checks to see if temperature is between 40.1 and 46.0 */
        if (curr_total >= 12'h401 && 
            curr_total <= 12'h460) begin

            alarm = 10'b0000000000;
            state = BORDER;

        end

        /* checks to see if temperature is between 46.1 and 49.0 */
        if (curr_total >= 12'h461 && 
            curr_total <= 12'h490) begin

            alarm = 10'b1010101010;
            state = WARNING;

        end

        /* checks to see if temperature is 49.1 degrees or greater */
        if (curr_total >= 12'h491) begin
        
            alarm = 10'b1111111111;
            state = EMERGENCY;

        end

        if (diff_read == 2) begin

            if (diff_total >= 12'h050) begin

                alarm = 10'b1111111111;
                state = EMERGENCY;

            end

        end

        /* checks if a sign change has occurred */
        sign_change = temp_sign_mode ^ curr_sign_mode;

        if (sign_change == 1) begin 

            alarm = 10'b1111111111;
            state = EMERGENCY;

        end

    end

endmodule

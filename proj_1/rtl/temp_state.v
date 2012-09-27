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
    
    input got_value,
    input sign_mode_changed,

    input [3:0] out_ones,
    input [3:0] out_tens,
    input [3:0] out_huns,

    input [3:0] temp_ones_value,
    input [3:0] temp_tens_value,
    input [3:0] temp_huns_value,

    output reg [3:0] state = 1,
    output reg [9:0] alarm = 0
);

    parameter NORMAL    = 4'b0001;
    parameter BORDER    = 4'b0010;
    parameter ATTENTION = 4'b0100;
    parameter EMERGENCY = 4'b1000;

    reg [2:0] diff_read = 0;

    wire [11:0] temp_total = {(temp_huns_value), (temp_tens_value), (temp_ones_value)};
    wire [11:0] diff_total = {(out_huns), (out_tens), (out_ones)};

    always @ (posedge got_value, posedge sign_mode_changed, posedge rst) begin

        if (rst) begin 

            alarm = 0;
            state = NORMAL;
            diff_read = 0;

        /* checks if a sign change has occurred */
        end else if (sign_mode_changed == 1) begin

            alarm = 10'b1111111111;
            state = EMERGENCY;

        end else begin

            if (diff_read > 2) diff_read = 2;
            else diff_read = diff_read + 1;

            if (diff_read == 2 && 
                diff_total >= 12'h050) begin

                alarm = 10'b0111111110;
                state = EMERGENCY;

            end

            /* checks to see if temperature is 
                between 0 and 39.9 */
            else if (temp_total >= 12'h000 && 
                temp_total <  12'h400) begin

                    alarm = 10'b0000000000;
                    state = NORMAL;

            end

            /* checks to see if temperature is 
                between 40.0 and 46.9 */
            else if (temp_total >= 12'h400 && 
                temp_total <  12'h470) begin

                    alarm = 10'b0000000000;
                    state = BORDER;

            end

            /* checks to see if temperature is 
                between 47.0 and 49.9 */
            else if (temp_total >= 12'h470 && 
                temp_total <  12'h500) begin
            
                    alarm = 10'b1010101010;
                    state = ATTENTION;

            end

            /* checks to see if temperature is 
                50 degrees or greater */
            else if (temp_total >= 12'h500) begin
            
                    alarm = 10'b1111111111;
                    state = EMERGENCY;

            end

        end

    end

endmodule

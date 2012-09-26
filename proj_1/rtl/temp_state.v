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

    //input temp_sign_mode,
    //input save_temp_sign_mode,
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

    reg sign_change = 0;

    /*parameter NORMAL    = 4'b0001;
    parameter BORDER    = 4'b0010;
    parameter WARNING   = 4'b0100;
    parameter EMERGENCY = 4'b1000;*/

    parameter NORMAL    = 1;
    parameter BORDER    = 2;
    parameter WARNING   = 3;
    parameter EMERGENCY = 4;

    wire [11:0] temp_total = {(temp_huns_value), (temp_tens_value), (temp_ones_value)};
    wire [11:0] diff_total = {(out_huns), (out_tens), (out_ones)};

    always @ (posedge got_value, posedge sign_mode_changed, posedge rst) begin

        if (rst) begin 

            alarm = 0;
            state = NORMAL;

        /* checks if a sign change has occurred */
        end else if (sign_mode_changed == 1) begin

            alarm = 10'b1111111111;
            state = EMERGENCY;

        end else begin

            /* checks to see if temperature is 
                between 0 and 39.9 */
            if (temp_total >= 12'h000 && 
                temp_total <  12'h400) begin

                    alarm = 10'b0000000000;
                    state = NORMAL;

            end

            /* checks to see if temperature is 
                between 40.0 and 46.9 */
            if (temp_total >= 12'h400 && 
                temp_total <  12'h470) begin

                    alarm = 10'b0000000000;
                    state = BORDER;

            end

            /* checks to see if temperature is 
                between 47.0 and 49.9 */
            if (temp_total >= 12'h470 && 
                temp_total <  12'h500) begin
            
                    alarm = 10'b1010101010;
                    state = WARNING;

            end

            /* checks to see if temperature is 
                50 degrees or greater */
            if (temp_total >= 12'h500) begin
            
                    alarm = 10'b1111111111;
                    state = EMERGENCY;

            end

            if (diff_read == 2) begin

                if (diff_total >= 12'h050) begin

                    alarm = 10'b1111111111;
                    state = EMERGENCY;

                end

            end

        end

    end

endmodule

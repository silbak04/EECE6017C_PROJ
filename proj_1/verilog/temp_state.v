`include "top_header.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: top.v                                                           --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           silbak04@gmail.com                                               --
//--                                                                            --
//-- DESCRIPTION: instantiates two 7-seg displays                               --
//--              and instantiates bcd input                                    --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module temp_state (
    input rst,
    input [3:0] bcd_units,
    input [3:0] bcd_tens,
    output reg normal,
    output reg border_line,
    output reg warning,
    output reg emergency
);

    //reg [2:0] state_ready = 0;
    reg sign_change = 0;
    reg temp = 0;

    always @ (*) begin

        if (rst) begin
            normal = 0;
            border_line = 0;
            warning = 0;
            emergency = 0;
        end

        /*if (sign_on) sign_change = 1;
        else */
        
        /* checks to see if temperature is between 0 and 39 */
        if (bcd_tens > 0 && bcd_tens < 4 && bcd_units >= 0 && bcd_units <= 9) normal = 1;

        /* checks to see if temperature is between 40 and 46 */
        else if (bcd_tens == 4 && bcd_units >= 0 && bcd_units < 7) begin 
            normal = 0;
            border_line = 1;
        end

        /* checks to see if temperature is between 47 and 49 */
        else if (bcd_tens == 4 && bcd_units >= 7 && bcd_units <= 9) begin
            border_line = 0;
            warning = 1;
        end

        /* checks to see if temperature is 50 degrees or greater or if we had a sign change */
        else if (bcd_tens >= 5 && bcd_units >= 0 || (sign_change != temp)) begin 
            warning = 0;
            emergency = 1;
        end

        //else state_ready = state_ready + 1;

    end

endmodule

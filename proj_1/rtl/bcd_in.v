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

    output reg [3:0] temp_ones_value = 0,
    output reg [3:0] temp_tens_value = 0,
    output reg [3:0] temp_huns_value = 0,

    output reg [3:0] curr_ones_value = 0,
    output reg [3:0] curr_tens_value = 0,
    output reg [3:0] curr_huns_value = 0,

    output reg [2:0] bcd_press = 0,
    //output reg [2:0] diff_read = 0,

    output reg got_value = 0,

    output sign_mode_changed
);

    always @ (posedge bcd_input, posedge rst) begin

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

            //diff_read = 0;
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


                got_value <= 1;

            end

            /* increment bcd input and track
            it onto the leds */
            //if (bcd_press == 3) got_value = 1;

            bcd_press = bcd_press + 1;

            if (bcd_press == 4) bcd_press = 0;

        end

    end

    reg mode_changed_pos = 0; // positive edge detected
    reg mode_changed_neg = 0; // negative edge detected

    always @(posedge sign_on, posedge rst) 
        if (rst) mode_changed_pos = 0;
        else mode_changed_pos = 1;

    always @(negedge sign_on, posedge rst) 
        if (rst) mode_changed_neg = 0;
        else mode_changed_neg = 1;

    assign sign_mode_changed = mode_changed_pos | mode_changed_neg;

endmodule

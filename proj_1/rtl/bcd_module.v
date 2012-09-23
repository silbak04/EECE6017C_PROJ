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

module bcd_module (
    input rst,
    input sign_on,
    input bcd_input,
    input [3:0] bcd_num,
    output reg [3:0] bcd_tenths,
    output reg [3:0] bcd_units,
    output reg [3:0] bcd_tens,
    output reg [2:0] bcd_cnt,
    output reg [3:0] sign,
    output reg sign_mode
);

    always @ (negedge bcd_input, negedge rst) begin

        if (!rst) begin

            /* reset all registers */
            bcd_cnt = 0;
            bcd_tenths = 0;
            bcd_units = `OFF;
            bcd_tens = `OFF;
        end

        else if (!bcd_input) begin

            if (bcd_cnt == 0) bcd_tenths = bcd_num;
            if (bcd_cnt == 1) bcd_units = bcd_num;
            if (bcd_cnt == 2) bcd_tens = bcd_num;

            bcd_cnt = bcd_cnt + 1;

        end

    end

    always @ (sign_on) begin

        if (sign_on) begin
            sign = `NEGATIVE;
            sign_mode = 1;
        end

        else begin
            sign = `OFF;
            sign_mode = 0;
        end

    end

endmodule

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

module top (
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);
    assign clk = CLOCK_50;
    assign rst = KEY[3];
    assign sign_switch = SW[9];
    assign input_bcd = KEY[0];

    //wire clk_1;

    reg [2:0] bcd_cnt = 0;

    reg [3:0] tenths_digit = 0;
    reg [3:0] units_digit = 0;
    reg [3:0] tens_digit = 0;

    reg [3:0] change_temp = 0;

    parameter OFF = 4'hA;
    parameter NEGATIVE = 4'hB;

    wire [3:0] digit_0;
    wire [3:0] digit_1;
    wire [3:0] digit_2;

    reg [3:0] sign = OFF;

    always @ (negedge input_bcd, negedge rst) begin

        if (!rst) begin

            bcd_cnt = 0;
            tenths_digit = 0;
            units_digit = 0;
            tens_digit = 0;

        end

        else if (!input_bcd) begin

            if (bcd_cnt == 0) tenths_digit = SW[3:0];
            if (bcd_cnt == 1) units_digit = SW[3:0];
            if (bcd_cnt == 2) tens_digit = SW[3:0];

            bcd_cnt = bcd_cnt + 1;

        end

    end

    always @ (sign_switch) begin

        if (sign_switch)
            sign = NEGATIVE;
        else 
            sign = OFF;
    end

    assign digit_0 = (bcd_cnt == 0) ? SW[3:0] : tenths_digit;
    assign digit_1 = (bcd_cnt == 1) ? SW[3:0] : units_digit;
    assign digit_2 = (bcd_cnt == 2) ? SW[3:0] : tens_digit;

    seven_seg display_0 (digit_0, HEX0);
    seven_seg display_1 (digit_1, HEX1);
    seven_seg display_2 (digit_2, HEX2);
    seven_seg display_3 (sign, HEX3);
     
    /*clk_div in_sig_1 (
        .clk_1(clk)
    );*/

   /* debug seven segment display */
   // assign HEX0 = SW; 

endmodule

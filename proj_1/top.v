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
    assign in_put = KEY[0];

    //wire clk_1;

    reg [2:0] bit_cnt = 0;

    reg [3:0] tenths_digit = 0;
    reg [3:0] units_digit = 0;
    reg [3:0] tens_digit = 0;

    reg [3:0] change_temp = 0;

    parameter OFF = 4'hA;
    parameter NEGATIVE = 4'hB;

    wire [3:0] digit_0;
    wire [3:0] digit_1;
    wire [3:0] digit_2;

    always @ (negedge in_put, negedge rst) begin
        if (!rst) begin
            bit_cnt = 0;
            tenths_digit = 0;
            units_digit = 0;
            tens_digit = 0;
        end

        else if (!in_put) begin

            if (bit_cnt == 0) tenths_digit = SW[3:0];
            if (bit_cnt == 1) units_digit = SW[3:0];
            if (bit_cnt == 2) tens_digit = SW[3:0];

            bit_cnt = bit_cnt + 1;
        end

    end

    assign digit_0 = (bit_cnt == 0) ? SW[3:0] : tenths_digit;
    assign digit_1 = (bit_cnt == 1) ? SW[3:0] : units_digit;
    assign digit_2 = (bit_cnt == 2) ? SW[3:0] : tens_digit;

    seven_seg display_0 (
        .bcd(digit_0),
        .seg(HEX0)
    );

    seven_seg display_1 (
        .bcd(digit_1),
        .seg(HEX1)
    );

    seven_seg display_2 (
        .bcd(digit_2),
        .seg(HEX2)
    );

    seven_seg display_3 (
        .bcd(NEGATIVE),
        .seg(HEX3)
    );
     
    /*clk_div in_sig_1 (
        .clk_1(clk)
    );*/

   /* debug seven segment display */
   // assign HEX0 = SW; 

endmodule

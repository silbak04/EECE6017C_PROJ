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
    input [9:0] SW,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

    wire [3:0] units;
    wire [3:0] tens;

    wire [3:0] tenths;

    wire [3:0] switch_tenths;
    assign switch_tenths = SW [3:0];

    wire [9:6] switch_tens;
    assign switch_tens = SW [9:6];

    parameter OFF = 4'hA;
    parameter NEGATIVE = 4'hB;

    seven_seg display_0 (
        .bcd(tenths),
        .seg(HEX0)
    );

    seven_seg display_1 (
        .bcd(units),
        .seg(HEX1)
    );

    seven_seg display_2 (
        .bcd(OFF),
        .seg(HEX2)
    );

    seven_seg display_3 (
        .bcd(NEGATIVE),
        .seg(HEX3)
    );
     
    shift_add_three bcd_num (
        .number(switch_tens),
        .units(units),
        .tens(tens)
    );

    shift_add_three bcd_num_2 (
        .number(switch_tenths),
        .units(tenths)
    );

   /* debug seven segment display */
   // assign HEX0 = SW; 

endmodule

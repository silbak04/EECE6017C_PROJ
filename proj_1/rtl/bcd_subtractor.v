`include "constants.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: bcd_subtractor.v                                                --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           silbak04@gmail.com                                               --
//--                                                                            --
//-- DESCRIPTION: excess three code algorithm (subtractor)                      --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module bcd_subtractor (
    input [3:0] x_ones,
    input [3:0] x_tens,
    input [3:0] x_huns,

    input [3:0] y_ones,
    input [3:0] y_tens,
    input [3:0] y_huns,

    output reg [3:0] out_ones = `OFF,
    output reg [3:0] out_tens = `OFF,
    output reg [3:0] out_huns = `OFF,

    output reg [3:0] sign
);

    wire [11:0] x_total;
    wire [11:0] y_total;

    reg [11:0] total = 0;

    assign x_total = {(x_huns + 4'd3), (x_tens + 4'd3), (x_ones + 4'd3)};
    assign y_total = {(y_huns + 4'd3), (y_tens + 4'd3), (y_ones + 4'd3)};

    always @ (*) begin

        if (y_total > x_total) begin

            total = (y_total - x_total);

            out_ones = total[3:0];
            out_tens = total[7:4];
            out_huns = total[11:8];

            if (y_ones < x_ones) out_ones = out_ones - 6;
            if (y_tens < x_tens) out_tens = out_tens - 6;
            if (y_huns < x_huns) out_huns = out_huns - 6;

            if (out_ones > 9) out_ones = out_ones - 6;
            if (out_tens > 9) out_tens = out_tens - 6;
            if (out_huns > 9) out_huns = out_huns - 6;

            sign = 0;

        end else begin

            total = (x_total - y_total);

            out_ones = total[3:0];
            out_tens = total[7:4];
            out_huns = total[11:8];

            if (x_ones < y_ones) out_ones = out_ones - 6;
            if (x_tens < y_tens) out_tens = out_tens - 6;
            if (x_huns < y_huns) out_huns = out_huns - 6;

            if (out_ones > 9) out_ones = out_ones - 6;
            if (out_tens > 9) out_tens = out_tens - 6;
            if (out_huns > 9) out_huns = out_huns - 6;

            sign = 1;

        end

    end

endmodule

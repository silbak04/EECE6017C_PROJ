`timescale 1 ns / 100 ps

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: bcd_subtractor_tb.v                                             --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           silbak04@gmail.com                                               --
//--                                                                            --
//-- DESCRIPTION: test bench for bcd subtraction                                --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module bcd_subtractor_tb ();

    reg [3:0] x_ones;
    reg [3:0] x_tens;
    reg [3:0] x_huns;

    reg [3:0] y_ones;
    reg [3:0] y_tens;
    reg [3:0] y_huns;

    wire [3:0] out_ones;
    wire [3:0] out_tens;
    wire [3:0] out_huns;

    wire sign;

    reg [31:0] count = 0;

    excess_three_coding dut (
        .x_ones(x_ones),
        .x_tens(x_tens),
        .x_huns(x_huns),

        .y_ones(y_ones),
        .y_tens(y_tens),
        .y_huns(y_huns),

        .out_ones(out_ones),
        .out_tens(out_tens),
        .out_huns(out_huns),

        .sign(sign)
);

/*--==========================================================--*/
/*--                        INITIAL BLOCK                     --*/
/*--==========================================================--*/

    initial begin
        $dumpfile("excess_three_code_tb.vcd");
        $dumpvars(0, excess_three_code_tb);
    end

    initial begin

        for (x_huns = 0; x_huns < 10; x_huns = x_huns + 1)
        for (x_tens = 0; x_tens < 10; x_tens = x_tens + 1)
        for (x_ones = 0; x_ones < 10; x_ones = x_ones + 1)
        for (y_huns = 0; y_huns < 10; y_huns = y_huns + 1) 
        for (y_tens = 0; y_tens < 10; y_tens = y_tens + 1)
        for (y_ones = 0; y_ones < 10; y_ones = y_ones + 1)

        begin

            //$display ("%b", dut.x_total);
            count = count + 1;

            $display("_____________________________\n");
            $write ("count = %d\n", count);
            $display("_____________________________\n");

            #10;
            $write ("%d%d%d - %d%d%d = ", y_huns, y_tens, y_ones, x_huns, x_tens, x_ones);
            if (sign) $write("-");
            $write ("%d%d%d\n", out_huns, out_tens, out_ones);

        end
        $stop;

    end

endmodule

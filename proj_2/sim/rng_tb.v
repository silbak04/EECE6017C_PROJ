`timescale 1 ns / 100 ps

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: rng_tb.v                                                        --
//--                                                                            --
//-- DATE: 9/30/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//-- Verified by: John Brady                                                    --
//--                                                                            --
//-- DESCRIPTION: used for testing purposes                                     --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module rng_tb();

    reg clk;
    reg rst;
    reg start;

    wire [7:0] out;

    rng dut(
        .clk(clk),
        .rst(~rst),
        .start(start),
        .out(out)
    );

    initial begin
        $dumpfile("rng_tb.vcd");
        $dumpvars(0, rng_tb);
    end

    always
        #1 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;

        start = 1;
        $monitor("%d", out);

        #256000;
        $finish;

    end

endmodule

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
//--                                                                            --
//-- DESCRIPTION: used for testing purposes                                     --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

//`define     MAXIMUM     2**8 

module rng_tb();

    reg clk;
    reg rst;
    reg switch;

    wire [7:0] out;

    rng dut(
        .clk(clk),
        .rst(~rst),
        .switch(switch),
        .out(out)
    );

    initial begin
        $dumpfile("rng_tb.vcd");
        $dumpvars(0, rng_tb);
    end

    always
        #1 clk = ~clk;

    initial begin

        $display("---------------------------");
        $display("  RANDOM NUMBER GENERATOR  ");
        $display("---------------------------");

        clk = 0;
        rst = 1;

        #100 switch = 1;

        #5000;

        $finish;

    end

endmodule

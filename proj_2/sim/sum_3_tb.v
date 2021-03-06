`timescale 1 ns / 100 ps

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: sum_3_tb.v                                                      --
//--                                                                            --
//-- DATE: 01.OCT.2012                                                          --
//--                                                                            --
//-- DESIGNER: Camiren Stewart                                                  --
//--                                                                            --
//-- DESCRIPTION: Test bench for the moving average module                      --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module sum_3_tb();

    reg clk;
    reg rst;
    reg signed [7:0] in;

    wire signed [7:0] out;

    sum_3 dut(
        .clk(clk),
        .rst(~rst),
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("sum_3_tb.vcd");
        $dumpvars(0, sum_3_tb);
    end

    always 
        #25 clk = ~clk;

    initial begin

        clk = 0;
        in = 0;
        rst = 0;

        #50 in = 2;
        #50 in = 1;
        #50 in = -1;

        //$display("in : %d", in);

        #1000;

        $finish;

    end

endmodule

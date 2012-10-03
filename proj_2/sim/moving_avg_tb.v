/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: moving_avg_tb.v                                                 --
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

`timescale 1 ns / 100 ps

module moving_avg_tb();

    reg clk;
    reg rst;
    reg signed [7:0] num;

    test dut(
        .num(num),
        .clk(clk),
        .rst(~rst)
    );

    initial begin
        $dumpfile("test_tb.vcd");
        $dumpvars(0, test_tb);
    end

    always 
        #25 clk = ~clk;

    initial begin

        clk = 0;
        num = 0;
        rst = 0;

        #50 num = 2;
        #50 num = 1;
        #50 num = -1;

        //$display("num : %d", num);

        #1000;

        $finish;

    end

endmodule

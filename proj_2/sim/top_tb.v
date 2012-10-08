/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: top.v                                                           --
//--                                                                            --
//-- DATE: 9/30/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--                                                                            --
//-- DESCRIPTION: top                                                           --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module top_tb ();
    reg CLOCK_50;
    reg [3:0] KEY;
    
    wire [7:0] LEDG;
    wire [7:0] LEDR;
    
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    reg [17:0] i = 0;

    top dut (
        .CLOCK_50(CLOCK_50),
        .KEY(~KEY),
        .LEDG(LEDG),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

    always
        #1 CLOCK_50 = ~CLOCK_50;

    initial begin
        CLOCK_50 = 0;
        KEY[0] = 1;
        KEY[3] = 1;

        #10;
        KEY[0] = 0;
        KEY[3] = 0;

        for (i = 0; i < 256000; i = i + 1)
        
        begin

            #10; KEY[3] = 0;

            $display("_________________");
            $write("random value = %d\n", dut.rand_num);
            $display("-----------------");
            $write("quotient val = %f\n", dut.div_num);
            $display("-----------------");
            $write("x            = %d\n", dut.sum_3.x);
            $display("-----------------");
            $write("y            = %d\n", dut.sum_3.y);
            $display("-----------------");
            $write("z            = %d\n", dut.sum_3.z);
            $display("-----------------");
            $write("sum value    = %d\n", dut.sum_val);

            #10; KEY[3] = 1;

        end
    end
endmodule

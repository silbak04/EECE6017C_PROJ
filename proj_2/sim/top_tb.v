/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: top_tb.v                                                        --
//--                                                                            --
//-- DATE: 9/30/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--                                                                            --
//-- DESCRIPTION: tests the top module to ensure everything is connected        --
//--              properly                                                      --
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

    integer i;

    reg [7:0] twos_comp_quot = 0;
    reg [7:0] twos_comp_rand = 0;

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

            if (dut.rand_num[7] == 1) begin
                twos_comp_rand = ((~dut.rand_num) + 1);

                $write("rand val   = -%0d.%0d\n", 
                        twos_comp_rand[7:6], 
                        twos_comp_rand[5:0] * 15625);
                $display("           -----------");
                $display("                3\n");

            end else begin
                $write("rand val   = %0d.%0d\n", 
                        twos_comp_rand[7:6], 
                        twos_comp_rand[5:0] * 15625);
                $display("           -----------");
                $display("                3\n");
            end

            if (dut.div_num[7] == 1) begin
                twos_comp_quot = ((~dut.div_num) + 1);

                $write("quotient v = -%0d.%0d\n", 
                        twos_comp_quot[7:6], 
                        twos_comp_quot[5:0] * 15625);
                $display("\n*******************");

            end else begin
                $write("quotient v = %0d.%0d\n", 
                        dut.div_num[7:6], 
                        dut.div_num[5:0] * 15625);
                $display("\n*******************");
            end

            $write("x              %d\n", dut.sum_3.x);
            $write("y            + %d\n", dut.sum_3.y);
            $write("z            + %d\n", dut.sum_3.z);
            $display("___________________");
            $write("sum value    = %d\n\n", dut.sum_val);
            $display("\n");

            #10; KEY[3] = 1;

        end
    end
endmodule

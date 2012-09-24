`timescale 1 ns / 100 ps

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: top_tb.v                                                        --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           John Brady                                                       --
//--           Nick Foltz                                                       --
//--           Camiren Stewart                                                  --
//--                                                                            --
//-- DESCRIPTION: device is under test                                          --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module top_tb ();

    reg CLOCK_50 = 0;

    reg [3:0] KEY = 0;
    reg [9:0] SW = 0;

    wire [7:0] LEDG;
    wire [9:0] LEDR;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    top dut(
        .CLOCK_50(CLOCK_50),

        .KEY(~KEY),
        .SW(SW),

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

/*--==========================================================--*/
/*--                        ALWAYS BLOCK                      --*/
/*--==========================================================--*/

    always
        #1 CLOCK_50 = ~CLOCK_50;

/*--==========================================================--*/
/*--                        INITIAL BLOCK                     --*/
/*--==========================================================--*/

    initial begin

        $display("track_input | mux outputs");
        $monitor("%d | %d%d%d", dut.track_inp,
            dut.flash_ones_display,
            dut.flash_tens_display,
            dut.flash_huns_display,
            dut.sign);

        #100 data_in;
        #100 input_value(12'h123); 
        #100;
        $display("------------------------");

        #100 data_in; 
        #100 input_value(12'h875);
        #100;
        $display("------------------------");

        /* enter new number */
        #100 data_in; 
        #100 input_value(12'h440); 
        #100;
        $display("------------------------");

        #5000;
        $finish;
    end

    task data_in; begin
        #50 KEY[3] = 1; #50 KEY[3] = 0;
    end
    endtask

    task input_value;
        input [11:0] val;
        begin
            #50 SW[3:0] = val[3:0];
            #50 data_in;
            #50 SW[3:0] = val[7:4];
            #50 data_in;
            #50 SW[3:0] = val[11:8];
            #50 data_in;
        end
    endtask

endmodule

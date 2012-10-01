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

`define     MAXIMUM     2**8 

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

        //reset;

        //$display("temp | delta | state");

        clk = 0;
               

        $display("---------------------------");
        $display("  RANDOM NUMBER GENERATOR  ");
        $display("---------------------------");

        //reset;
        //#100 set_mode(1); freq_num(out);
        //#100 set_mode(1);

        rst = 1;
        #100 
        switch = 1;

        #5000;
        $finish;
    end


    // pulses the rst key
    /*task reset; begin
        #50 rst = 1; #50 rst = 0;
        //$display ("reset");
    end
    endtask

    // sets the mode switch
    task set_mode;
        input x;
        #50 switch = x;
    endtask*/

    // enters the passed value by settings the
    // switches and pulsing the enter key
    // also displays the current state of the system
    /*task freq_num;
        input [7:0] val;
        begin
            
            #50 set_mode(1); out = val;

            $write("%0d%0d%0d  |  %0d%0d%0d | %0d | %0d | %b",
                uut.curr_huns_value,
                uut.curr_tens_value,
                uut.curr_ones_value,

                uut.out_huns,
                uut.out_tens,
                uut.out_ones,

                uut.sign_mode_changed,

                uut.temp_state.state,
                uut.temp_state.alarm
            );

            write_state_name(out);
        end
    endtask*/


    // given a system state name print out a code
    // indicating which state it is
    /*task write_state_name;
        input [7:0] s;
        begin
            while (out < `MAXIMUM) begin
            case (s)
                `STATE_NORMAL: $write("(N)");
                `STATE_BORDERLINE: $write("(B)");
                `STATE_ATTENTION: $write("(A)");
                `STATE_EMERGENCY: $write("(E)");
            endcase
        end
    endtask*/

endmodule

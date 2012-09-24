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
//-- DESCRIPTION: used for testing purposes                                     --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/


`define STATE_NORMAL     4'b0001
`define STATE_BORDERLINE     4'b0010
`define STATE_ATTENTION   4'b0100
`define STATE_EMERGENCY  4'b1000

module top_tb();

    reg CLOCK_50 = 0;
    reg [3:0] KEY = 0;
    reg [9:0] SW = 0;
    wire [7:0] LEDG;
    wire [9:0] LEDR;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    top uut(
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

    always
        #1 CLOCK_50 = ~CLOCK_50;

    initial begin

        reset;

        $display("temp | delta | state");
               
        //
        // The following section will test the temperature input
        // from 0 to 50 (not comprehensive) this will cover standard 
        // increments that will not trigger a '>5' alarm
        // as well as show that each state works
        // 

        $display("--------------------");
        $display("  Normal Operation  ");
        $display("--------------------");

        // border around 40
        reset;
        #100 enter_value(12'h398); check(`STATE_NORMAL);
        #100 enter_value(12'h399); check(`STATE_NORMAL);
        #100 enter_value(12'h400); check(`STATE_BORDERLINE);
        #100 enter_value(12'h401); check(`STATE_BORDERLINE);
        #100 enter_value(12'h402); check(`STATE_BORDERLINE);

        // border around 47
        reset;
        #100 enter_value(12'h468); check(`STATE_BORDERLINE);
        #100 enter_value(12'h469); check(`STATE_BORDERLINE);
        #100 enter_value(12'h470); check(`STATE_ATTENTION);
        #100 enter_value(12'h471); check(`STATE_ATTENTION);
        #100 enter_value(12'h472); check(`STATE_ATTENTION);

        // border around 50
        reset;
        #100 enter_value(12'h498); check(`STATE_ATTENTION);
        #100 enter_value(12'h499); check(`STATE_ATTENTION);
        #100 enter_value(12'h500); check(`STATE_EMERGENCY);
        #100 enter_value(12'h501); check(`STATE_EMERGENCY);
        #100 enter_value(12'h502); check(`STATE_EMERGENCY);


        //
        // This next group will test the delta alarm going off
        // (if the change in temp is greater than 5)
        //

        $display("--------------------");
        $display("     Delta > 5      ");
        $display("--------------------");

        reset;
          
        #100 enter_value(12'h000); check(`STATE_NORMAL);
        #100 enter_value(12'h000); check(`STATE_NORMAL);
        #100 enter_value(12'h070); check(`STATE_EMERGENCY);
        #100 enter_value(12'h360); check(`STATE_EMERGENCY);
          
        // turn off the alarm by not changing the temp
        // The next jump will cross a borderline from 
        // normal to attention. alarm should still go off
          
        #100 enter_value(12'h360); check(`STATE_NORMAL);
        #100 enter_value(12'h420); check(`STATE_EMERGENCY);
          
        // This will test for the case when the temperature
        // increments greater than 5, but also out of range
          
        #100 enter_value(12'h460); check(`STATE_BORDERLINE);
        #100 enter_value(12'h540); check(`STATE_EMERGENCY);
          
        // This test will drop from out of range into attention mode
        // A delta of >5.
          
        #100 enter_value(12'h470); check(`STATE_EMERGENCY);
          
        // This will test a massive drop from 47 to 5
        // start with the >5 alarm off (attention alarm is on)
          
        #100 enter_value(12'h470); check(`STATE_ATTENTION);
        #100 enter_value(12'h050); check(`STATE_EMERGENCY);
          
        // The alarm should turn off after this reading
          
        #100 enter_value(12'h050); check(`STATE_NORMAL);
          
        //
        // This group of tests checks to make sure the
        // alarm goes off if the mode changes
        //

        $display("--------------------");
        $display("    Mode Changed    ");
        $display("--------------------");

        set_mode(0);
        reset;
          
        #100 enter_value(12'h000); check(`STATE_NORMAL);
        #100 enter_value(12'h010); check(`STATE_NORMAL);
        set_mode(1);
        #100 enter_value(12'h020); check(`STATE_EMERGENCY);
        #100 enter_value(12'h030); check(`STATE_EMERGENCY);

        set_mode(1);
        reset;
          
        #100 enter_value(12'h000); check(`STATE_NORMAL);
        #100 enter_value(12'h010); check(`STATE_NORMAL);
        set_mode(0);
        #100 enter_value(12'h020); check(`STATE_EMERGENCY);
        #100 enter_value(12'h030); check(`STATE_EMERGENCY);

        #5000;
        $finish;
    end


    // pulses the reset key
    task reset; begin
        #50 KEY[3] = 1; #50 KEY[3] = 0;
    end
    endtask

    // changes the mode switch
    task set_mode;
        input x;
        #50 SW[9] = x;
    endtask

    // pulses the enter key
    task pulse_enter; begin
        #50 KEY[0] = 1; #50 KEY[0] = 0; 
    end
    endtask

    // enters the passed value by settings the
    // switches and pulsing the enter key
    // also displays the current state of the system
    task enter_value;
        input [11:0] val;
        begin
            #50 pulse_enter;            // start entering a number
            #50 SW[3:0] = val[3:0];     // setup switches for the ones digit
            #50 pulse_enter;            // latch in that digit
            #50 SW[3:0] = val[7:4];     // setup switches for the tens digit
            #50 pulse_enter;            // latch in that digit
            #50 SW[3:0] = val[11:8];    // setup switches for the huns digit
            #50 pulse_enter;            // latch in that digit
            #50 pulse_enter;            // latch in that digit
            #50;

            $write("%0d%0d%0d  |  %0d%0d%0d  | %0d ",
                uut.curr_huns_value,
                uut.curr_tens_value,
                uut.curr_ones_value,

                uut.out_huns,
                uut.out_tens,
                uut.out_ones,

                uut.temp_state.state
            );

            write_state_name(uut.temp_state.state);
        end
    endtask

    // checks the current state of the system against
    // the parameter. displays pass or fail
    task check;
        input [1:0] s;
        begin
            if (uut.state != s)  begin
                $write("<--[FAIL]-- Expected state: %d ", s);
                write_state_name(s);
                $write("\n");
            end else 
                $write("   [PASS]\n");
        end
    endtask

    // given a system state name print out a code
    // indicating which state it is
    task write_state_name;
        input [1:0] s;
        begin
            case (s)
                `STATE_NORMAL: $write("(N)");
                `STATE_BORDERLINE: $write("(B)");
                `STATE_ATTENTION: $write("(A)");
                `STATE_EMERGENCY: $write("(E)");
            endcase
        end
    endtask


endmodule

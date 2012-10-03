/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: counter_tb.v                                                    --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: John Brady                                                       --
//--                                                                            --
//-- DESCRIPTION: used for testing purposes                                     --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/
`timescale 10 ps / 1 ps	// Delay time is in mS


module counter_tb();


    reg clk_test = 1'bz;
    reg clk_onoff = 0;
    reg reset = 1'bz;
    reg start_button = 1'bz;
    reg stop_button = 1'bz;
    
    wire [6:0] sev_seg0;
    wire [6:0] sev_seg1;
    wire [6:0] sev_seg2;
    wire [6:0] sev_seg3;
    
    counter uut(
        .clk(clk_test),
        .rst(reset),
        .sev_seg0(sev_seg0),
        .sev_seg1(sev_seg1),
        .sev_seg2(sev_seg2),
        .sev_seg3(sev_seg3)
    );
   
    always 
    begin
        //if (clk_onoff == 1'b1)
        #1 clk_test = ~clk_test;
    end
    
    always @(posedge start_button or negedge stop_button)
    begin
        if (stop_button == 0)
            clk_test=1'bz;
        else
        begin
            reset = 0;
            $display("System Reset");
            #2 reset = 1;
            clk_test=0;
        end
    end
        
   
    initial 
    begin

        press_stop;
        
        $display("--------------------");
        $display("  Normal Operation  ");
        $display("--------------------");
        
        press_start;
        $display("+10 Calculations"); 
        #20; 
        press_stop;
        $display("200 delay no Calculations");
        #200;
        press_start;
        $display("+100 Calculations"); 
        #200; 
        press_start;
        $display("+1,000 Calculations");
        #2000; 
        
        $stop;
            
    end
    
    initial
	begin
		$monitor($time, " sev_seg0=%b, sev_seg1=%b, sev_seg2=%b, sev_seg3=%b, start_button=%b, stop_button=%b, reset=%b",
					sev_seg0, sev_seg1, sev_seg2, sev_seg3, start_button, stop_button, reset);
	end
    
    task press_start;
    begin
        start_button=0;
        $display("Start Button Pressed");
        #2 start_button=1;
    end
    endtask
    
    task press_stop;
    begin
        stop_button=0;
        $display("Stop Button Pressed");
        #2 stop_button=1;
    end
    endtask
    
endmodule

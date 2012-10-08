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
`timescale 10 ps / 1 ps


module counter_tb();


    wire clk;
    reg clk_50 = 1'b0;
    reg clk_onoff = 1'b0;
    reg reset = 1'b1;
    
    wire [6:0] sev_seg0;
    wire [6:0] sev_seg1;
    wire [6:0] sev_seg2;
    wire [6:0] sev_seg3;
    
    counter uut(
        .clk(clk),
        .rst(reset),
        .sev_seg0(sev_seg0),
        .sev_seg1(sev_seg1),
        .sev_seg2(sev_seg2),
        .sev_seg3(sev_seg3)
    );
    
    assign clk = (clk_onoff == 1'b1) ? clk_50: 1'b0;
   
    always
    begin
        #1 clk_50 = ~clk_50;      
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
		$monitor($time, " | sev_seg3=%h | sev_seg2=%h | sev_seg1=%h | sev_seg0=%h ",
					uut.seg3_BCD, uut.seg2_BCD, uut.seg1_BCD, uut.seg0_BCD);
	end
    
    task press_start;
    begin
        reset = 1'b0;
        $display("Reset");
        reset = 1'b1;
        clk_onoff = 1'b1;
        $display("Clock On");
        $display("Time | Seg3 | Seg2 | Seg1 | Seg0");
    end
    endtask
    
    task press_stop;
    begin
        clk_onoff=1'b0;
        $display("Clk Off");
    end
    endtask
    
endmodule

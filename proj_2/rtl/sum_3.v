/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: sum_3.v                                                         --
//--                                                                            --
//-- DATE : 	01.OCT.2012							--
//-- Upated :	08.OCT.2012	-	Added comments                          --
//--                                                                            --
//-- DESIGNER: Camiren Stewart                                                  --
//--                                                                            --
//-- DESCRIPTION: Calculates the moving average                                 --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module sum_3 (
    input clk,
    input rst,
    input en,
    input signed [7:0] in,	// input from divide_by_three.v

    output signed [7:0] out	// output the calculated sum 
);

    reg signed [7:0] x = 0;	
    reg signed [7:0] y = 0;
    reg signed [7:0] z = 0;

    always @ (posedge clk, posedge rst) begin
        if (rst) begin 		// When reset button is pushed,
            x <= 0;		// set all variables back to zero (0)
            y <= 0;
            z <= 0;
        end else if (en) begin	// Take incoming number and assign to x
            x <= in;		// Move x to y after new number is added, and so on
            y <= x;		 
            z <= y;
        end
    end

    assign out = (x + y + z);	// This adds all current variables

endmodule

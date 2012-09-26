/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: clk_div.v                                                       --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           John Brady                                                       --
//--           Nick Foltz                                                       --
//--           Camiren Stewart                                                  --
//--           silbak04@gmail.com                                               --
//--                                                                            --
//-- DESCRIPTION: divides the clock down to ~1.5Hz                              --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module clk_div (
    input clk, clr,
    output clk_1,
    output clk_2
);

    /* (1/50e6) * 2**25 ~ 0.67s or ~1.5Hz */
    reg [24:0] q_out_0;

    /* (1/50e6) * 2**26 ~ 1.34s or ~0.75Hz */
    reg [25:0] q_out_1;

    always @ (posedge clk, posedge clr) begin

        if (clr) begin 

            q_out_0 <= 0;
            q_out_1 <= 0;

        end else begin
            
            q_out_0 <= q_out_0 + 1;
            q_out_1 <= q_out_1 + 1;

        end

    end

    assign clk_1 = q_out_0[24]; 
    assign clk_2 = q_out_1[25];

endmodule

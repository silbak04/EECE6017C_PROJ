//`include "constants.vh"

/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: rng.v                                                           --
//--                                                                            --
//-- DATE: 9/30/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--                                                                            --
//-- DESCRIPTION: random number generator (lfsr)                                --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module rng (
    input clk,
    input rst,
    input start,

    output reg [7:0] out = 0
);

    reg [7:0] seed = 10101001;

    always @ (posedge clk, posedge rst) begin
        
        if (rst) out = seed;
        else if (start) begin

                out = out << 1;
                out[0] = ~(out[3] ^ out[4] ^ out[5] ^ out[7]);

            end
        end
    
endmodule

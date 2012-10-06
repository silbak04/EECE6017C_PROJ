/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: sum_3.v                                                         --
//--                                                                            --
//-- DATE: 01.OCT.2012                                                          --
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
    input signed [7:0] in,

    output signed [7:0] out
);

    reg signed [7:0] x = 0;
    reg signed [7:0] y = 0;
    reg signed [7:0] z = 0;

    always @ (posedge clk, posedge rst) begin
        if (rst) begin 
            x <= 0;
            y <= 0;
            z <= 0;
        end else if (en) begin
            x <= in;
            y <= x;
            z <= y;
        end
    end

    assign out = (x + y + z);

endmodule

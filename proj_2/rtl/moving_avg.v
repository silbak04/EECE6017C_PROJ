/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: moving_avg.v                                                    --
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

module moving_avg(
    input clk,
    input rst,
    input signed [7:0] num,
    output signed [7:0] sum

);

    reg signed [7:0] x = 0;
    reg signed [7:0] y = 0;
    reg signed [7:0] z = 0;

    always @ (posedge clk, posedge rst) begin
        if(rst) begin 
            x <= 0;
            y <= 0;
            z <= 0;
            sum <= 0;
        end else begin
            x <= num;
            y <= x;
            z <= y;
        end
    end

    assign sum = (x + y + z);

endmodule

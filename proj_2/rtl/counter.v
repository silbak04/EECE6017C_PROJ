/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: counter.v                                                       --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: John Brady                                                       --
//--                                                                            --
//-- DESCRIPTION: counter for number of running averages                        --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module counter (
    input clk,
    input rst,
    
    output reg [3:0] ET0=0,
    output reg [3:0] ET1=0,
    output reg [3:0] ET2=0,
    output reg [3:0] ET3=0,
    output reg [3:0] ET4=0,
    output reg [3:0] ET5=0,
    output reg [3:0] ET6=0,
    output reg [3:0] ET7=0,
    output reg [3:0] ET8=0,
    output reg [3:0] ET9=0,
    output reg [3:0] ET10=0,

    output reg [3:0] cur_exp=0
);

    always @(posedge clk, posedge rst)
    begin
        if (rst)
        begin
            ET0<=4'h0;
            ET1<=4'h0;
            ET2<=4'h0;
            ET3<=4'h0;
            ET4<=4'h0;
            ET5<=4'h0;
            ET6<=4'h0;
            ET7<=4'h0;
            ET8<=4'h0;
            ET9<=4'h0;
            ET10<=4'h0;
            cur_exp<=4'h0;    
        end // rst
        else
        begin
            ET0 = ET0+1;
            
            if (ET0 == 4'hA)
            begin
                ET0=0;
                ET1 = ET1+1;
                
                if (ET1 == 4'hA)
                begin
                    ET1=0;
                    ET2 = ET2+1;
                    if (cur_exp<1)
                        cur_exp=cur_exp+1;
                    
                    if (ET2 == 4'hA)
                    begin
                        ET2=0;
                        ET3 = ET3+1;
                        if (cur_exp<2)
                            cur_exp=cur_exp+1;
                        
                        if (ET3 == 4'hA)
                        begin
                            ET3=0;
                            ET4 = ET4 + 1;
                            if (cur_exp<3)
                                cur_exp=cur_exp+1;
                            
                            if (ET4 == 4'hA)
                            begin
                                ET4=0;
                                ET5 = ET5 + 1;
                                if (cur_exp<4)
                                    cur_exp=cur_exp+1;
             
                                if (ET5 == 4'hA)
                                begin
                                    ET5=0;
                                    ET6 = ET6+1;
                                    if (cur_exp<5)
                                        cur_exp=cur_exp+1;
                                    
                                    if (ET6 == 4'hA)
                                    begin
                                        ET6=0;
                                        ET7 = ET7+1;
                                        if (cur_exp<6)
                                            cur_exp=cur_exp+1;
                                        
                                        if (ET7 == 4'hA)
                                        begin
                                            ET7=0;
                                            ET8 = ET8+1;
                                            if (cur_exp<7)
                                                cur_exp=cur_exp+1;
                                            
                                            if (ET8 == 4'hA)
                                            begin
                                                ET8=0;
                                                ET9 = ET9 + 1;
                                                if (cur_exp<8)
                                                    cur_exp=cur_exp+1;
                                                
                                                if (ET9 == 4'hA)
                                                begin
                                                    ET9=0;
                                                    ET10 = ET10 + 1;
                                                    if (cur_exp<9)
                                                        cur_exp=cur_exp+1;
                                                    
                                                    if (ET10 == 4'hA)
                                                    begin
                                                        ET10 = 0;
                                                        cur_exp = 0;
                                                    end //ET10 = 4'hA                                                    
                                                end //ET9 = 4'hA
                                            end //ET8 = 4'hA
                                        end //ET7 = 4'hA
                                    end //ET6 == 4'hA
                                end //ET5 == 4'hA
                            end //ET4 = 4'hA
                        end //ET3 = 4'hA
                    end //ET2 = 4'hA
                end //ET1 == 4'hA
            end //ETO == 4'hA
        end //not rst
    end //Always posedge clk
    
endmodule

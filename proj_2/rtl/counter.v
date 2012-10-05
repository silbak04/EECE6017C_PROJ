`include "constants.vh"

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
    
    output [6:0] sev_seg0,
    output [6:0] sev_seg1,
    output [6:0] sev_seg2,
    output [6:0] sev_seg3
);
  
    wire [3:0] seg0_`BCD;
    wire [3:0] seg1_`BCD;
    wire [3:0] seg2_`BCD;
    wire [3:0] seg3_`BCD;

    // Decimal Register holders
    reg [3:0]  dec_ones=0;
    reg [3:0]  dec_tens=0;
    reg [3:0]  dec_hund=0;
    reg [3:0]  dec_thous=0;
    reg [3:0]  dec_ten_thous=0;
    reg [3:0]  dec_hund_thous=0;
    reg [3:0]  dec_million=0;
    reg [3:0]  dec_ten_million=0;
    reg [3:0]  dec_hund_million=0;
    reg [3:0]  dec_billion=0;
    reg [3:0]  dec_ten_billion=0;
    reg [3:0]  cur_exp=0;

    /* Set up LED 7-Segment Displays */
    seven_seg s0 (seg0_`BCD, sev_seg0);
    seven_seg s1 (seg1_`BCD, sev_seg1);
    seven_seg s2 (seg2_`BCD, sev_seg2);
    seven_seg s3 (seg3_`BCD, sev_seg3);
 
    /* 3rd 7-seg always shows 'E' */
    assign seg2_`BCD = `BCD_E;
    
    /* 4th 7-seg always shows exponent digit */
    assign seg3_`BCD = cur_exp[3:0];
    
    
    /* Multiplexers */
    
    // 10s Digits display of XXEY
    assign seg0_`BCD =
    (cur_exp == `BCD_0)  ? dec_tens[3:0]:
    (cur_exp == `BCD_1)  ? dec_hund[3:0]:
    (cur_exp == `BCD_2)  ? dec_thous[3:0]:
    (cur_exp == `BCD_3)  ? dec_ten_thous[3:0]:
    (cur_exp == `BCD_4)  ? dec_hund_thous[3:0]:
    (cur_exp == `BCD_5)  ? dec_million[3:0]:
    (cur_exp == `BCD_6)  ? dec_ten_million[3:0]:
    (cur_exp == `BCD_7)  ? dec_hund_million[3:0]:
    (cur_exp == `BCD_8)  ? dec_billion[3:0]:
    (cur_exp == `BCD_9)  ? dec_ten_billion[3:0]:
    `BCD_0;
    
    // 1s Digits display of XXEY
    assign seg1_`BCD = 
    (cur_exp == `BCD_0) ? dec_ones[3:0]:
    (cur_exp == `BCD_0) ? dec_tens[3:0]:
    (cur_exp == `BCD_0) ? dec_hund[3:0]:
    (cur_exp == `BCD_0) ? dec_thous[3:0]:
    (cur_exp == `BCD_0) ? dec_ten_thous[3:0]:
    (cur_exp == `BCD_0) ? dec_hund_thous[3:0]:
    (cur_exp == `BCD_0) ? dec_million[3:0]:
    (cur_exp == `BCD_0) ? dec_ten_million[3:0]:
    (cur_exp == `BCD_0) ? dec_hund_million[3:0]:
    (cur_exp == `BCD_0) ? dec_billion[3:0]:
    `BCD_0;
    
    always @(posedge clk or negedge rst)
    begin
        if (~rst)
        begin
            dec_ones<=`BCD_0;
            dec_tens<=`BCD_0;
            dec_hund<=`BCD_0;
            dec_thous<=`BCD_0;
            dec_ten_thous<=`BCD_0;
            dec_hund_thous<=`BCD_0;
            dec_million<=`BCD_0;
            dec_ten_million<=`BCD_0;
            dec_hund_million<=`BCD_0;
            dec_billion<=`BCD_0;
            dec_ten_billion<=`BCD_0;
            cur_exp<=`BCD_0;    
        end // rst
        else
        begin
            dec_ones = dec_ones+1;
            
            if (dec_ones == `BCD_10)
            begin
                dec_ones=0;
                dec_tens = dec_tens+1;
                
                if (dec_tens == `BCD_10)
                begin
                    dec_tens=0;
                    dec_hund = dec_hund+1;
                    if (cur_exp<1)
                        cur_exp=cur_exp+1;
                    
                    if (dec_hund == `BCD_10)
                    begin
                        dec_hund=0;
                        dec_thous = dec_thous+1;
                        if (cur_exp<2)
                            cur_exp=cur_exp+1;
                        
                        if (dec_thous == `BCD_10)
                        begin
                            dec_thous=0;
                            dec_ten_thous = dec_ten_thous + 1;
                            if (cur_exp<3)
                                cur_exp=cur_exp+1;
                            
                            if (dec_ten_thous == `BCD_10)
                            begin
                                dec_ten_thous=0;
                                dec_hund_thous = dec_hund_thous + 1;
                                if (cur_exp<4)
                                    cur_exp=cur_exp+1;
             
                                if (dec_hund_thous == `BCD_10)
                                begin
                                    dec_hund_thous=0;
                                    dec_million = dec_million+1;
                                    if (cur_exp<5)
                                        cur_exp=cur_exp+1;
                                    
                                    if (dec_million == `BCD_10)
                                    begin
                                        dec_million=0;
                                        dec_ten_million = dec_ten_million+1;
                                        if (cur_exp<6)
                                            cur_exp=cur_exp+1;
                                        
                                        if (dec_ten_million == `BCD_10)
                                        begin
                                            dec_ten_million=0;
                                            dec_hund_million = dec_hund_million+1;
                                            if (cur_exp<7)
                                                cur_exp=cur_exp+1;
                                            
                                            if (dec_hund_million == `BCD_10)
                                            begin
                                                dec_hund_million=0;
                                                dec_billion = dec_billion + 1;
                                                if (cur_exp<8)
                                                    cur_exp=cur_exp+1;
                                                
                                                if (dec_billion == `BCD_10)
                                                begin
                                                    dec_billion=0;
                                                    dec_ten_billion = dec_ten_billion + 1;
                                                    if (cur_exp<9)
                                                        cur_exp=cur_exp+1;
                                                    
                                                    if (dec_ten_billion == `BCD_10)
                                                    begin
                                                        dec_ten_billion = 0;
                                                        cur_exp = 0;
                                                    end //dec_ten_billion = `BCD_10                                                    
                                                end //dec_billion = `BCD_10
                                            end //dec_hund_million = `BCD_10
                                        end //dec_ten_million = `BCD_10
                                    end //dec_million == `BCD_10
                                end //dec_hund_thous == `BCD_10
                            end //dec_ten_thous = `BCD_10
                        end //dec_thous = `BCD_10
                    end //dec_hund = `BCD_10
                end //dec_tens == `BCD_10
            end //ETO == `BCD_10
        end //not rst
    end //Always posedge clk
    
endmodule

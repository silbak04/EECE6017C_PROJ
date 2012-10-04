//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_//
//                                                                           //
//  Module:     Divide by Three (divide_by_three.v)                          //
//                                                                           //
//  Author:     Nicholas Foltz                                               //
//                                                                           //
//  Date:       2012/10/03                                                    //
//                                                                           //
//  Description:                                                             //
//  Implements divide by three as a 1/3 multiplier. A constant truncated     //
//  value of 00.010101 is used to avoid overflow issues.                     //
//                                                                           //
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_//

module divide_by_three(dividend, quotient);
    // Input and output are 8-bit two's complement <1.6> fixed-point numbers.
    // [ Sign | Ones | Decimal ]
    // [ 7    | 6    | 5:0     ]
    input signed [7:0] dividend;
    output signed [7:0] quotient;
    
    // Intermediary value that holds the necessary decimal precision increase.
    wire signed [12:0] fullQuotient;

    // Multiply by constant two's fixed-point (signed) equivalent of 1/3.
    // This value closely approximates 1/3 but prevents overflow in FIR sums of
    // the output quotient.
    assign fullQuotient = dividend * 8'sb00_010101;
    
    // fullQuotient looks like this (consider a full-precision multiplication):
    // +--------------------------+------+----------+-----------------------+
    // | Overflow and unused bits | Ones | Decimals | Past precision bounds |
    // | [15:13] (imaginary)      | [12] | [11:6]   | [5:0]                 |
    // +--------------------------+------+----------+-----------------------+
    
    // Preserve the dividend's sign bit.
    assign quotient[7] = dividend[7];
    
    // Shift to grab the most significant bits from the product.
    // Because the inputs are <1.6> fixed point values, the product will have
    // 12 decimal places, or <2.12>. Quotients will never use bit 13.
    assign quotient[6:0] = fullQuotient[12:6];
endmodule

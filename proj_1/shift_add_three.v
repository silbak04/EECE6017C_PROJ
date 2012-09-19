/*--==========================================================================--*/
//--================================= VERILOG ==================================--
//--============================================================================--
//--                                                                            --
//-- FILE NAME: shift_add_three.v                                               --
//--                                                                            --
//-- DATE: 9/18/2012                                                            --
//--                                                                            --
//-- DESIGNER: Samir Silbak                                                     --
//--           silbak04@gmail.com                                               --
//--                                                                            --
//-- DESCRIPTION: shift add three algorithm to convert from                     --
//--              binary to bcd                                                 --
//--                                                                            --
//--============================================================================--
//--================================= VERILOG ==================================--
/*--===========================================================================--*/

module shift_add_three (
    input [3:0] number,
    output reg [3:0] units = 4'b0000,
    output reg [3:0] tens = 4'b0000
);

    reg [3:0] bit_shifts = 4'b0000;
    reg [3:0] binary;

    always @ (*) begin

        bit_shifts = 4'b0000;
        tens = 4'b0000;
        units = 4'b0000;

        binary = number;

        /* shift 4 times */
        while (bit_shifts < 4) begin

            /* add 3 if ones place is five or greater */
            if (units >= 5)
                units = units + 3;

            /* add 3 if tens place is five or greater */
            if (tens >= 5)
                tens = tens + 3;

            /* shift 1 bit to left, assign MSB of ones place */
            /* to LSB of tens place */
            tens = tens << 1;
            tens [0] = units [3];

            /* shift 1 bit to left, assign MSB of binary */
            /* to LSB of ones place */
            units = units << 1;
            units [0] = binary [3];                   

            /* shift 1 bit to left of binary value */
            binary = binary << 1;

            /* increment the bit shift number */
            bit_shifts = bit_shifts + 1;
            
        end

    end

endmodule

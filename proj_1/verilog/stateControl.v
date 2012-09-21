module stateControl(clk, reset_button, integer_button, decimal_button, change_sign, change_10_reg, change_1_reg, change_dec_reg, new_sign, new_conv_value, new_10_reg, new_1_reg, new_dec_reg, data_in, led0, led1, led2, led3);
	parameter STATE0 = 4'b0000, STATE1 = 4'b0001, STATE2 = 4'b0010, STATE3 = 4'b0011;
	parameter STATE4 = 4'b0100, STATE5 = 4'b0101, STATE6 = 4'b0110, STATE7 = 4'b0111;
	parameter STATE8 = 4'b1000, STATE9 = 4'b1001, STATE10 = 4'b1010, STATE11 = 4'b1011;
	parameter STATE12 = 4'b1100, STATE13 = 4'b1101, STATE14 = 4'b1110, STATE15 = 4'b1111;
	parameter LED0 = 2'b00, LED1 = 2'b01, LED2 = 2'b10, LED3 = 2'b11;
	parameter BLANK = 4'b1010;
	parameter CLK_SCALE = 10'b0000110010;
	
	// Clk
	input clk;
	input reset_button;
	input decimal_button;
	input integer_button;
	
	// How much temp changed variables
	input change_sign;
	input [3:0] change_10_reg;
	input [3:0] change_1_reg;
	input [3:0] change_dec_reg;
	
	// New temperature variables
	input new_sign;
	input [3:0] new_10_reg;
	input [3:0] new_1_reg;
	input [3:0] new_dec_reg;
	input [6:0] new_conv_value;
	
	// Input switches
	input [9:0] data_in;
	
	// Output LEDs
	output [3:0] led0;
	output [3:0] led1;
	output [3:0] led2;
	output [3:0] led3;
	
	reg [3:0] led0;
	reg [3:0] led1;
	reg [3:0] led2;
	reg [3:0] led3;
	
	// Current temperature variables
	reg [3:0] current_state;
	reg [3:0] current_10_reg;
	reg [3:0] current_1_reg;
	reg [3:0] current_dec_reg;
	reg [6:0] current_conv_value;
	reg current_sign;
	reg [9:0] display_timer;
	
	
	
	always @(posedge clk)
	begin
		if (reset_button == 1'b0)
			begin
			end
		else if (integer_button == 1'b0)	
			begin
				led_output(LED2, data_in[7:4]);
				led_output(LED3, data_in[3:0]);
				current_state = STATE10;
			end
		else if (decimal_button == 1'b0)
			begin
				led_output(LED2, data_in[7:4]);
				led_output(LED3, data_in[3:0]);
				current_state = STATE0;
				display_timer = CLK_SCALE;
			end
		else
			begin
				if (display_timer > 0)
					display_timer = display_timer - 1;
				else
				begin
				display_timer = CLK_SCALE;
				
				case(current_state)
					STATE0:
						begin
							led_output(LED0, BLANK);
							led_output(LED1, BLANK);
							led_output(LED2, BLANK);
							led_output(LED3, BLANK);
						end
					STATE1:
						begin
							if (change_sign == 1'b1)
								led_output(LED0, 4'b1011);
							else
								led_output(LED0, BLANK);
							led_output(LED1, change_10_reg);
							led_output(LED2, change_1_reg);
							led_output(LED3, change_dec_reg);
							current_state = STATE2;
						end
					STATE2:
						begin
							current_state = STATE3;
						end
					STATE3:
						begin
							led_output(LED0, BLANK);
							led_output(LED1, BLANK);
							led_output(LED2, BLANK);
							led_output(LED3, BLANK);
							current_state = STATE4;
						end
					STATE4:
						begin
							if (new_sign == 1'b1)
								led_output(LED0, 4'b1011);
							else
								led_output(LED0, BLANK);
							led_output(LED1, new_10_reg);
							led_output(LED2, new_1_reg);
							led_output(LED3, new_dec_reg);
							current_state = STATE5;
						end
					STATE5:
						begin
							current_state = STATE6;
						end
					STATE6:
						begin
							led_output(LED0, BLANK);
							led_output(LED1, BLANK);
							led_output(LED2, BLANK);
							led_output(LED3, BLANK);
							current_state = STATE7;
						end
					STATE7:
						begin
							if (change_sign == 1'b1)
								led_output(LED0, 4'b1011);
							else
								led_output(LED0, BLANK);
							led_output(LED1, change_10_reg);
							led_output(LED2, change_1_reg);
							led_output(LED3, change_dec_reg);
							current_state = STATE8;
						end
					STATE8:
						begin
							current_sign = new_sign;
							current_10_reg = new_10_reg;
							current_1_reg = new_1_reg;
							current_conv_value = new_conv_value;
							current_dec_reg = new_dec_reg;
							current_state = STATE9;
						end
					STATE9:
						begin
							led_output(LED0, BLANK);
							led_output(LED1, BLANK);
							led_output(LED2, BLANK);
							led_output(LED3, BLANK);
							current_state = STATE10;
						end
					STATE10:
						begin
							if (current_sign == 1'b1)
								led_output(LED0, 4'b1011);
							else
								led_output(LED0, BLANK);
							led_output(LED1, current_10_reg);
							led_output(LED2, current_1_reg);
							led_output(LED3, current_dec_reg);
							current_state = STATE15;
						end
					STATE15:
						begin
						end
					default:
						begin
						end
				endcase
				end
			end											
	end	
	
	task led_output;
	input [1:0] led_pos;
	input [3:0] led_value;
	begin
		case (led_pos)
			LED0:
				led0 = led_value;
			LED1:
				led1 = led_value;
			LED2:
				led2 = led_value;
			LED3:
				led3 = led_value;
			default:
				begin
					led0 = 4'b0000;
					led1 = 4'b0000;
					led2 = 4'b0000;
					led3 = 4'b0000;
				end
		endcase
	end
	endtask

endmodule
	
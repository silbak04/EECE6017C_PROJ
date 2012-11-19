module toggle(clock, counter_out);
input clock;
output [9:5] counter_out;
reg [31:0] counter_data;
always @ (posedge clock)
begin
    counter_data <= counter_data + 1;
end
assign counter_out[9] = counter_data[21];
assign counter_out[5] = counter_data[21];
assign counter_out[8] = counter_data[26];
assign counter_out[6] = counter_data[26];
assign counter_out[7] = counter_data[27];
endmodule

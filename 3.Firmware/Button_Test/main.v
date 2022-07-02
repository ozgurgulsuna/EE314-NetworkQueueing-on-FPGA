module main( 
	input clk,
	input start,
	input in_0,
	input in_1,
	output [3:0] p_out
);

wire read_clk;
wire fract_clk;
wire slow_clk;

clk_div my_divider(.clk(clk), .read_clk(read_clk), .fract_clk(fract_clk), .slow_clk(slow_clk));
//debouncer my_debouncer(.clk(clk), .read_clk(read_clk), .fract_clk(fract_clk), .slow_clk(slow_clk));

endmodule

module clk_div(
	input clk,
	output reg read_clk,
	output reg fract_clk
);
	
	integer read_timer;
	integer fract_timer;

	
	parameter clockfreq = 10000000; // 10 MHz clock is assumed, it will be adjusted according to the device

	
	initial begin
		read_clk = 1'd0;
		fract_clk = 1'd0;
		read_timer = 1'd0;
		fract_timer = 1'd0;
	end

	// This always block produces a 'clock' with 3 seconds period
	always @(posedge clk) begin
		read_clk = 0;
		read_timer = read_timer + 1;
		if (read_timer == 3*clockfreq) begin
			read_timer = 0;
			read_clk = 1;
		end
	end
	
		always @(posedge clk) begin
		fract_clk = 0;
		fract_timer = fract_timer + 1;
		if (fract_timer == clockfreq/20) begin
			fract_timer = 0;
			fract_clk = 1;
		end
	end
	
endmodule
	
	
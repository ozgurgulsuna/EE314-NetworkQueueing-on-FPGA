module buffer(
	input p_in[3:0],
	input read,
	input write, // Command
	output reg [5:0][3:0] memory,
	output reg [3:0] fullness
);

	
	initial begin
		memory = 24'd0;
		fullness = 3'd0;
	end

	always begin
		if (write == 1) begin
			if (fullness == 6) begin
				for(i=0;i<6;i=i+1) begin
					memory [0] 
				end
			end
			else
				memory [fullness] = p_in;
		end
	end

endmodule

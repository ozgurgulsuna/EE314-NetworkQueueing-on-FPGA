module buffer(
	input clk,
	input [3:0] p_in,
	input read, // Read data from buffer if read = 1
	input write, // Write data to buffer if write = 1
	output reg [23:0] memory,
	output reg [2:0] fullness
);

	integer i;
	
	initial begin
		memory = 24'd0;
		fullness = 3'd0;
	end

	always @(posedge clk) begin
	
		if (read == 1) begin
			
			if (fullness != 0) begin
				memory[4*0+3:4*0] = memory[4*1+3:4*1];
				memory[4*1+3:4*1] = memory[4*2+3:4*2];
				memory[4*2+3:4*2] = memory[4*3+3:4*3];
				memory[4*3+3:4*3] = memory[4*4+3:4*4];
				memory[4*4+3:4*4] = memory[4*5+3:4*5];
				// memory[4*5+3:4*5] = 4'd0; - no need to reset the buffer (or is there?)
				fullness = fullness - 1;
			end
			
		end
		
		if (write == 1) begin
		
			if (fullness == 6) begin
				memory[4*0+3:4*0] = memory[4*1+3:4*1];
				memory[4*1+3:4*1] = memory[4*2+3:4*2];
				memory[4*2+3:4*2] = memory[4*3+3:4*3];
				memory[4*3+3:4*3] = memory[4*4+3:4*4];
				memory[4*4+3:4*4] = memory[4*5+3:4*5];
				memory[4*5+3:4*5] = p_in[3:0];
			end
			if (fullness < 6) begin
				for (i=0;i<4;i=i+1) begin
					memory[fullness*4+i] = p_in[i];
				end
				fullness = fullness + 1;
			end
			
		end
		
	end
	
endmodule

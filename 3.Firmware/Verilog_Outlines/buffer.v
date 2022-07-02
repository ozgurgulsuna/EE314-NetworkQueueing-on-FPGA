module buffer(
	input fract_clk,
	input clk,
	
	input [3:0] p_in,
	
	input read, 								// Read data from buffer if read = 1
	input write, 								// Write data to buffer if write = 1
	
	output reg [23:0] memory,
	output reg [2:0] fullness,
	
	output reg [15:0] time_total,			// 1 second is divided by 20 to achieve 1/20 resolution, assuming max latency is 500 seconds. 20*500*6=60000 and it is in range of 16 bits.
	output reg [9:0] input_count,		  // MAX permissable input for single buffer 1024, BE CAREFUL CAUTION WARNING !
	output reg [7:0] drop_count        // MAX permissable drop is 256, BE CAREFUL CAUTION WARNING !
);

	integer i;

	reg [13:0] time_reg[83:0];  // Limit time individally at  10000 DO NOT FORGET !
	
	initial begin
		memory = 24'd0;
		fullness = 3'd0;
		time_total = 16'd0;
		input_count = 10'd0;
		drop_count = 8'd0;
		for (i=0;i<6;i=i+1) begin
			time_reg[i][13:0] = 14'd0;
		end	
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
		
		if (write == 1) begin                          // Input is now here
			input_count = input_count+1;
		
			if (fullness == 6) begin
				memory[4*0+3:4*0] = memory[4*1+3:4*1];    // Shift the memory values
				memory[4*1+3:4*1] = memory[4*2+3:4*2];
				memory[4*2+3:4*2] = memory[4*3+3:4*3];
				memory[4*3+3:4*3] = memory[4*4+3:4*4];
				memory[4*4+3:4*4] = memory[4*5+3:4*5];
				memory[4*5+3:4*5] = p_in[3:0];
				
				time_reg[0][13:0] = time_reg[1][13:0];                // If full then the 6th buffer latency value is zeroed
				time_reg[1][13:0] = time_reg[2][13:0];                // If full then the 6th buffer latency value is zeroed
				time_reg[2][13:0] = time_reg[3][13:0];                // If full then the 6th buffer latency value is zeroed
				time_reg[3][13:0] = time_reg[4][13:0];                // If full then the 6th buffer latency value is zeroed
				time_reg[4][13:0] = time_reg[5][13:0];                // If full then the 6th buffer latency value is zeroed
				time_reg[5][13:0] = 14'd0;                            // If full then the 6th buffer latency value is zeroed
				
				drop_count = drop_count+1;
			end
			if (fullness < 6) begin
				for (i=0;i<4;i=i+1) begin
					memory[fullness*4+i] = p_in[i];
				end
				fullness = fullness + 1;
			end
			
		end
		
	end
	
	always  @(posedge clk) begin
		for(i=0;i<6;i=i+1) begin
			time_total = time_total + time_reg[i][13:0];
		end
	end
	
endmodule

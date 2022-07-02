module switch(
	input fract_clk,
	input start,
	input in_0,
	input in_1,
	output reg [3:0] write,
	output reg [3:0] p_out,
	output reg [2:0] count4,
	output reg stop

);
	
	reg temp_start;
	reg temp_in_0;
	reg temp_in_1;

	
	initial begin
		count4 = 3'd0;
		temp_start = 0;
		temp_in_0 = in_0;
		temp_in_1 = in_1;
		stop = 1;
	end
	
	
	always @(posedge fract_clk) begin
		
		if ( start == 1) begin
			count4 = 3'd0;
			stop = 0;
			p_out[3:0] = 4'd0;
			//p_out[count4] = (!in_0)&(in_1);
		end
		
		if (stop == 0) begin
			if (temp_in_0 == 0 && in_0==1) begin
				count4 = count4 + 3'd1;
				if (count4 != 3'd4) begin
					p_out[count4] = (!in_0)&(in_1);
				end
				else begin
					p_out[count4] = (!in_0)&(in_1);
					stop = 1;
				end
			end
			
			if (temp_in_1 == 0 && in_1==1) begin
				count4 = count4 + 3'd1;
				if (count4 != 3'd4) begin
					p_out[count4] = (!in_0)&(in_1);
				end
				else begin
					p_out[count4] = (!in_0)&(in_1);
					stop = 1;
				end
			end
		
		end
		else begin
			count4 = 3'd4;
		end
		
		
		
		
//		if (stop == 0) begin 
//			count4 = count4 + 2'b01;
//			if (count4 != 2'b11) begin
//				p_out[count4] = (!in_0)&(in_1);
//			end
//			else begin
//				p_out[count4] = (!in_0)&(in_1);
//				stop = 1;
//			end
//		end
		
		
		
		
		temp_start = start;
		
	end
	
endmodule

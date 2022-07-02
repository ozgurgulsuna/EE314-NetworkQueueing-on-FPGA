module switch(
	input fract_clk,
	input start,
	input in_0,
	input in_1,
	output reg [3:0] write,
	output reg [3:0] p_out
);
	
	reg [3:0] pout;
	reg [2:0] count4;
	reg stop;
	
	initial begin
		count4 = 3'd0;
		stop = 1;
	end
	
	
	always @(posedge fract_clk) begin
		
		if (start == 1) begin
			count4 = 3'd0;
			stop = 0;
			p_out[3:0] = 4'd0;
			//p_out[count4] = (!in_0)&(in_1);
		end
		
		if (stop == 0) begin
		
			if (in_0==1) begin
				if (count4 != 3'd4) begin
					if(count4 == 0)begin
						pout[0]=0;
					end
					if(count4 == 1)begin
						pout[1]=0;
					end
					if(count4 == 2)begin
						pout[2]=0;
					end
					if(count4 == 3)begin
						pout[3]=0;
						stop = 1;
						p_out[3:0] = pout[3:0];
					end
					count4 = count4 + 3'd1;
				end
				
			end
			
			if (in_1 == 1) begin
			
				if (count4 != 3'd4) begin
					if(count4 == 0)begin
						pout[0]=1;
					end
					if(count4 == 1)begin
						pout[1]=1;
					end
					if(count4 == 2)begin
						pout[2]=1;
					end
					if(count4 == 3)begin
						pout[3]=1;
						stop = 1;
						p_out[3:0] = pout[3:0];

					end
					count4 = count4 + 3'd1;
				end
			end
		
		end
		else begin
			count4 = 3'd4;
		end

	end
	
endmodule

module decision(
	input  read_clk,							// read clock at T=3 secs
	input  fract_clk,							// fractional clock 

	
	input [2:0] fullness_1,  				// Fullness of the first buffer
	input [2:0] fullness_2,  				// Fullness of the second buffer
	input [2:0] fullness_3,  				// Fullness of the third buffer
	input [2:0] fullness_4,  				// Fullness of the fourth buffer
	
	input [15:0] total_time_1,  			// Total time of the first buffer
	input [15:0] total_time_2,  			// Total time of the second buffer
	input [15:0] total_time_3,  			// Total time of the third buffer
	input [15:0] total_time_4,  			// Total time of the fourth buffer
	
	output reg read_1,						// Read this buffer
	output reg read_2,						// Read this buffer
	output reg read_3,						// Read this buffer
	output reg read_4 						// Read this buffer

);


// ASLA IKI OKUMAYI BIRDEN YAPMA DIYE KONTROL


	reg [7:0] WL_1;
	reg [7:0] WL_2;
	reg [7:0] WL_3;
	reg [7:0] WL_4;
	
	reg [11:0] WR_1;
	reg [11:0] WR_2;
	reg [11:0] WR_3;
	reg [11:0] WR_4;

	reg [22:0] pick_fcn_1;
	reg [22:0] pick_fcn_2;
	reg [22:0] pick_fcn_3;
	reg [22:0] pick_fcn_4;
	
	reg [1:0] i;
	reg [22:0] max;
	
	
	initial begin
		WL_1 = 8'd56;
		WL_2 = 8'd40;
		WL_3 = 8'd19;
		WL_4 = 8'd3;	
	
		WR_1 = 12'd15;
		WR_2 = 12'd425;
		WR_3 = 12'd759;
		WR_4 = 12'd1000;
		
		read_1 = 0;
		read_2 = 0;
		read_3 = 0;
		read_4 = 0;
	
		i   = 0 ;
		max = 0 ;
	end
	
	always @(posedge fract_clk) begin
	
		read_1 = 0;
		read_2 = 0;
		read_3 = 0;
		read_4 = 0;	
		
		if (read_clk == 1) begin
				// Calculating the functions
				pick_fcn_1 = (WL_1*total_time_1)+(WR_1*fullness_1*fullness_1);
				pick_fcn_2 = (WL_2*total_time_2)+(WR_2*fullness_2*fullness_2);
				pick_fcn_3 = (WL_3*total_time_3)+(WR_3*fullness_3*fullness_3);
				pick_fcn_4 = (WL_4*total_time_4)+(WR_4*fullness_4*fullness_4);
				
				i	=	0;
				max = pick_fcn_1;
				if(max<pick_fcn_2) begin
					max	=	pick_fcn_2;
					i	=	1;
				end
				if (max<pick_fcn_3) begin
					max	=	pick_fcn_3;
					i	=	2;
				end
				if (max<pick_fcn_4) begin
					max	=	pick_fcn_4;
					i	=	3;
				end
				
				case(i)
					2'b00 : read_1 = 1;
					2'b01 : read_2 = 1;
					2'b10 : read_3 = 1;
					2'b11 : read_4 = 1;
				endcase
			end
		end
		
	
	
	endmodule
	
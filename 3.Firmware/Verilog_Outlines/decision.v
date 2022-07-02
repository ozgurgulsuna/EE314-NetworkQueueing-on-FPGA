module decision(
	input  r_clk,								// read clock at T=3 secs
	
	input [2:0] fullness_1,  				// Fullness of the first buffer
	input [2:0] fullness_2,  				// Fullness of the second buffer
	input [2:0] fullness_3,  				// Fullness of the third buffer
	input [2:0] fullness_4,  				// Fullness of the fourth buffer
	
	
	output reg [1:0] read_,					// Selected output to be read, for ex. [1 0] is for 3rd buffer 


	input [3:0] p_in,
	input read, 								// Read data from buffer if read = 1
	input write, 								// Write data to buffer if write = 1
	output reg [23:0] memory,
	output reg [2:0] fullness
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
	
	
	initial begin
		WL_1 = 8'd56;
		WL_2 = 8'd40;
		WL_3 = 8'd19;
		WL_4 = 8'd3;	
	
		WR_1 = 12'd15;
		WR_2 = 12'd425;
		WR_3 = 12'd759;
		WR_4 = 12'd1000;	
	end
	
	endmodule
	
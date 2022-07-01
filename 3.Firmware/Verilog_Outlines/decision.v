module decision(
	input clk,
	
	input [2:0] fullness_1,  				// Fullness of the first buffer
	input [2:0] fullness_2,  				// Fullness of the second buffer
	input [2:0] fullness_3,  				// Fullness of the third buffer
	input [2:0] fullness_4,  				// Fullness of the fourth buffer
	
	output reg read[2:0],					// Selected output to be read, for ex. [1 0] is for 3rd buffer 

	
	input [3:0] p_in,
	input read, // Read data from buffer if read = 1
	input write, // Write data to buffer if write = 1
	output reg [23:0] memory,
	output reg [2:0] fullness
);


// ASLA IKI OKUMAYI BIRDEN YAPMA DIYE KONTROL
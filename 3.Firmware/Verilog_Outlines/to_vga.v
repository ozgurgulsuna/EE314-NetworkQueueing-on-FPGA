module to_vga(
	input vga_clk,
	input [2:0] fullness1,
	input [2:0] fullness2,
	input [2:0] fullness3,
	input [2:0] fullness4,
	input [23:0] memory1,
	input [23:0] memory2,
	input [23:0] memory3,
	input [23:0] memory4,
	 
	
	input [3:0] read, 
	
	
	output reg hsynch,
	output reg vsynch,
	output reg [7:0] vga_red,
	output reg [7:0] vga_green,
	output reg [7:0] vga_blue
);
	
	integer i;
	integer j;
	integer k;
	
	reg [11:0] drop_counts_bcd [4:0]; // 3 digit bcd number for each buffer + total values
	reg [11:0] input_counts_bcd [4:0];
	reg [11:0] transmitted_counts_bcd [4:0];
	reg [3:0] data_read;
	
	reg [2:0] fullnesses[3:0];           // 3 elements for each buffer conatining buffer fullnesses
	input [23:0] memories[3:0];          // 24 elements for each buffer conatining buffer memories
	input [7:0] drop_counts[3:0];        // 8 elements for each buffer conatining buffer drop counts
	input [9:0] input_counts[3:0];       // 10 elements for each buffer containing buffer input counts
	
	initial begin
		i = 0;
		j = 0;
		hsynch = 0;
		vsynch = 0;
		vga_red = 0;
		vga_green = 0;
		vga_blue = 0;
		fullnesses[0] = fullness1;
		fullnesses[1] = fullness2;
		fullnesses[2] = fullness3;
		fullnesses[3] = fullness4;
		memories[0] = memory1;
		memories[1] = memory2;
		memories[2] = memory3;
		memories[3] = memory4;
	end
	
	always @(posedge vga_clk) begin
		
		// Grouping inputs
		fullnesses[0] = fullness1;
		fullnesses[1] = fullness2;
		fullnesses[2] = fullness3;
		fullnesses[3] = fullness4;
		
		fullnesses[0] = fullness1;
		fullnesses[1] = fullness2;
		fullnesses[2] = fullness3;
		fullnesses[3] = fullness4;
		
		// Binary to bcd converter calculations
		drop_counts_bcd [0][3:0] =   (drop_counts[0*8+7:0*8])%10;                // First digit
		drop_counts_bcd [0][7:4] =  ((drop_counts[0*8+7:0*8])/10)%10;           // Second digit
		drop_counts_bcd [0][11:8] = ((drop_counts[0*8+7:0*8])/100);         // Last digit - 3 digit numbers at most!!
		
		input_counts_bcd [0][3:0] =   (input_counts[0*10+9:0*10])%10;
		input_counts_bcd [0][7:4] =  ((input_counts[0*10+9:0*10])/10)%10;
		input_counts_bcd [0][11:8] = ((input_counts[0*10+9:0*10])/100);
		
		transmitted_counts_bcd [0][3:0] =   (input_counts[0*10+9:0*10]-drop_counts[0*8+7:0*8])%10;
		transmitted_counts_bcd [0][7:4] =  ((input_counts[0*10+9:0*10]-drop_counts[0*8+7:0*8])/10)%10;
		transmitted_counts_bcd [0][11:8] = ((input_counts[0*10+9:0*10]-drop_counts[0*8+7:0*8])/100);
		
		drop_counts_bcd [1][3:0] =   (drop_counts[1*8+7:1*8])%10;
		drop_counts_bcd [1][7:4] =  ((drop_counts[1*8+7:1*8])/10)%10;
		drop_counts_bcd [1][11:8] = ((drop_counts[1*8+7:1*8])/100);
		
		input_counts_bcd [1][3:0] =   (input_counts[1*10+9:1*10])%10;
		input_counts_bcd [1][7:4] =  ((input_counts[1*10+9:1*10])/10)%10;
		input_counts_bcd [1][11:8] = ((input_counts[1*10+9:1*10])/100);
		
		transmitted_counts_bcd [1][3:0] =   (input_counts[1*10+9:1*10]-drop_counts[1*8+7:1*8])%10;
		transmitted_counts_bcd [1][7:4] =  ((input_counts[1*10+9:1*10]-drop_counts[1*8+7:1*8])/10)%10;
		transmitted_counts_bcd [1][11:8] = ((input_counts[1*10+9:1*10]-drop_counts[1*8+7:1*8])/100);
		
		drop_counts_bcd [2][3:0] =   (drop_counts[2*8+7:2*8])%10;
		drop_counts_bcd [2][7:4] =  ((drop_counts[2*8+7:2*8])/10)%10;
		drop_counts_bcd [2][11:8] = ((drop_counts[2*8+7:2*8])/100);
		
		input_counts_bcd [2][3:0] =   (input_counts[2*10+9:2*10])%10;
		input_counts_bcd [2][7:4] =  ((input_counts[2*10+9:2*10])/10)%10;
		input_counts_bcd [2][11:8] = ((input_counts[2*10+9:2*10])/100);
		
		transmitted_counts_bcd [2][3:0] =   (input_counts[2*10+9:2*10]-drop_counts[2*8+7:2*8])%10;
		transmitted_counts_bcd [2][7:4] =  ((input_counts[2*10+9:2*10]-drop_counts[2*8+7:2*8])/10)%10;
		transmitted_counts_bcd [2][11:8] = ((input_counts[2*10+9:2*10]-drop_counts[2*8+7:2*8])/100);
		
		drop_counts_bcd [3][3:0] =   (drop_counts[3*8+7:3*8])%10;
		drop_counts_bcd [3][7:4] =  ((drop_counts[3*8+7:3*8])/10)%10;
		drop_counts_bcd [3][11:8] = ((drop_counts[3*8+7:3*8])/100);
		
		input_counts_bcd [3][3:0] =   (input_counts[3*10+9:3*10])%10;
		input_counts_bcd [3][7:4] =  ((input_counts[3*10+9:3*10])/10)%10;
		input_counts_bcd [3][11:8] = ((input_counts[3*10+9:3*10])/100);
		
		transmitted_counts_bcd [3][3:0] =   (input_counts[3*10+9:3*10]-drop_counts[3*8+7:3*8])%10;
		transmitted_counts_bcd [3][7:4] =  ((input_counts[3*10+9:3*10]-drop_counts[3*8+7:3*8])/10)%10;
		transmitted_counts_bcd [3][11:8] = ((input_counts[3*10+9:3*10]-drop_counts[3*8+7:3*8])/100);
		
		// Binary to bcd converter for total values
		drop_counts_bcd [4][3:0] =   (drop_counts[4*8+7:4*8])%10;
		drop_counts_bcd [4][7:4] =  ((drop_counts[4*8+7:4*8])/10)%10;
		drop_counts_bcd [4][11:8] = ((drop_counts[4*8+7:4*8])/100);
		
		input_counts_bcd [4][3:0] =   (input_counts[4*10+9:4*10])%10;
		input_counts_bcd [4][7:4] =  ((input_counts[4*10+9:4*10])/10)%10;
		input_counts_bcd [4][11:8] = ((input_counts[4*10+9:4*10])/100);
		
		transmitted_counts_bcd [4][3:0] =   (input_counts[4*10+9:4*10]-drop_counts[4*8+7:4*8])%10;
		transmitted_counts_bcd [4][7:4] =  ((input_counts[4*10+9:4*10]-drop_counts[4*8+7:4*8])/10)%10;
		transmitted_counts_bcd [4][11:8] = ((input_counts[4*10+9:4*10]-drop_counts[4*8+7:4*8])/100);
		
		// Data written in the output switch
		for (i=0;i<4;i=i+1) begin
			if (read[i]==1) begin
				for (j=0;j<4;j=j+1) begin
					data_read[j] = memories[i*24+fullnesses[i]*4+j];
				end
			end
		end
		
		
		
		// Paint buffers
		for (i=0;i<4;i=i+1) begin
			//memories[]
		end
		
		
	end
	
	
endmodule
// FULLNESSLAR 0 ise read yapılmayacak, output datayı değiştirme
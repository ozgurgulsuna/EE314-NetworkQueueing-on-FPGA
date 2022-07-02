module main(
	input clk,
	input start,
	input in_0,
	input in_1
);
	
	reg [3:0] read;
	reg [3:0] write;
	reg [3:0] fullness [15:0];
	
	reg [1:0] write_timer;
	integer read_timer;
	reg read_clk; 
		
	
	buffer buffer1(.clk(clk), .p_in(sw_in), .read(read[0]), .write(write[0]), .fullness(fullness[0][3:0]));
	buffer buffer2(.clk(clk), .p_in(sw_in), .read(read[1]), .write(write[1]), .fullness(fullness[1][3:0]));
	buffer buffer3(.clk(clk), .p_in(sw_in), .read(read[2]), .write(write[2]), .fullness(fullness[2][3:0]));
	buffer buffer4(.clk(clk), .p_in(sw_in), .read(read[3]), .write(write[3]), .fullness(fullness[3][3:0]));
	
	initial begin
		read = 4'd0;
		write = 4'd0;
		write_timer = 0;
		read_timer = 0;
		read_clk = 0;
	end
	
	always @(posedge clk) begin
	
		reg [3:0] read = 4'd0;
		reg [3:0] write = 4'd0;
		
		//write [sw_in[3:2]] = 1;
		
		
	end
	
	always @(posedge read_clk) begin
	
	end
	
	// This always block produces a 'clock' with 3 seconds period
	
endmodule

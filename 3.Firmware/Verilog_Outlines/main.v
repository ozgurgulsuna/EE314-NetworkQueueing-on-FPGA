module main(
	input clk,
	input start,
	input in_0,
	input in_1,
	
	// FOR DEBUGGING
	output [3:0] p_in,
	
	output vga_clk,
	output hsynch,
	output vsynch,
	output [7:0] vga_red,
	output [7:0] vga_green,
	output [7:0] vga_blue,
	output vga_sync_n,
	output vga_blank_n
);
	
	// Define necessary clock signal wires
	wire read_clk;
	wire fract_clk;
	wire slow_clk;
	
	// Define debounced signal wires
	wire start_deb;
	wire in_0_deb;
	wire in_1_deb;

	// Define other necessary signal wires
	//wire [3:0] p_in;
	wire [3:0] read;
	wire [3:0] write;
	wire [2:0] fullnesses[3:0];
	wire [23:0] memories[3:0];
	wire [7:0] drop_counts[3:0]; 
	wire [9:0] input_counts[3:0];
	wire [15:0] total_times[3:0];
	
	// Connect debouncers
	debouncer debouncer_start(start, fract_clk, start_deb);
	debouncer debouncer_in_0(in_0, fract_clk, in_0_deb);
	debouncer debouncer_in_1(in_1, fract_clk, in_1_deb);
	
	// Connect clock divider
	clk_div clk_div1(clk, read_clk, fract_clk, slow_clk, vga_clk);
	
	// Connect input switch
	switch switch1(fract_clk, start, in_0_deb, in_1_deb, write, p_in);
	
	// Connect buffers
	buffer buffer1(fract_clk, p_in, read[0], write[0], memories[0], fullnesses[0], total_times[0], input_counts[0], drop_counts[0]);
	buffer buffer2(fract_clk, p_in, read[1], write[1], memories[1], fullnesses[1], total_times[1], input_counts[1], drop_counts[1]);
	buffer buffer3(fract_clk, p_in, read[2], write[2], memories[2], fullnesses[2], total_times[2], input_counts[2], drop_counts[2]);
	buffer buffer4(fract_clk, p_in, read[3], write[3], memories[3], fullnesses[3], total_times[3], input_counts[3], drop_counts[3]);	
	
	// Connect decision block
	decision decision1(read_clk, fract_clk, fullnesses[0], fullnesses[1], fullnesses[2], fullnesses[3], 
	total_times[0], total_times[1], total_times[2], total_times[3],read[0], read[1], read[2], read[3]);
	
	// Connect VGA block
	to_vga to_vga1(vga_clk, fullnesses[0], fullnesses[1], fullnesses[2], fullnesses[3],
						memories[0], memories[1], memories[2], memories[3],
						drop_counts[0], drop_counts[1], drop_counts[2], drop_counts[3],
						input_counts[0], input_counts[1], input_counts[2], input_counts[3], read, p_in,
						hsynch, vsynch, vga_red, vga_green, vga_blue, vga_sync_n, vga_blank_n);
	
endmodule

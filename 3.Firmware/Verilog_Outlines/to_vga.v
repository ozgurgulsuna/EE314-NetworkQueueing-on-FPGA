module to_vga(
	input clk,
	input [2:0] fullness1,
	input [2:0] fullness2,
	input [2:0] fullness3,
	input [2:0] fullness4,
	input [23:0] memory1,
	input [23:0] memory2,
	input [23:0] memory3,
	input [23:0] memory4,
	input [7:0] drop_count1,
	input [7:0] drop_count2,
	input [7:0] drop_count3,
	input [7:0] drop_count4,
	input [9:0] input_count1,
	input [9:0] input_count2,
	input [9:0] input_count3,
	input [9:0] input_count4,
	
	input [3:0] read, 
	input [3:0] p_in,
	
	output reg hsynch,
	output reg vsynch,
	output reg [7:0] vga_red,
	output reg [7:0] vga_green,
	output reg [7:0] vga_blue,
	output vga_sync_n,
	output vga_blank_n,
	output reg vga_clk
);
	
	integer i;
	integer j;
	integer k;
	reg [1:0] temp2bit;
	
	reg [11:0] drop_counts_bcd [4:0]; // 3 digit bcd number for each buffer + total values
	reg [11:0] input_counts_bcd [4:0];
	reg [11:0] transmitted_counts_bcd [4:0];
	reg [3:0] data_read;
	
	reg [2:0] fullnesses[3:0];           // 3 elements for each buffer conatining buffer fullnesses
	reg [23:0] memories[3:0];          // 24 elements for each buffer conatining buffer memories
	reg [7:0] drop_counts[3:0];        // 8 elements for each buffer conatining buffer drop counts
	reg [9:0] input_counts[3:0];       // 10 elements for each buffer containing buffer input counts
	
	reg [9:0] sum_transmitted;
	reg [9:0] sum_dropped;
	reg [9:0] sum_input;
	
	// horizontal and vertical counters for vga screen
	integer h_count;
	integer v_count;
	
	// registers for storing asset pixels
	reg background_r [307199:0];
	reg background_g [307199:0];
	reg background_b [307199:0];
	
	reg gray_digits_r [1951:0];
	reg gray_digits_g [1951:0];
	reg gray_digits_b [1951:0];
	
	// first buffer pixels
	reg red_digits_r [4099:0];
	reg red_digits_g [4099:0];
	reg red_digits_b [4099:0];
	
	// second buffer pixels
	reg blue_digits_r [4099:0];
	reg blue_digits_g [4099:0];
	reg blue_digits_b [4099:0];
	
	// third buffer pixels
	reg yellow_digits_r [4099:0];
	reg yellow_digits_g [4099:0];
	reg yellow_digits_b [4099:0];
	
	// fourth buffer pixels
	reg green_digits_r [4099:0];
	reg green_digits_g [4099:0];
	reg green_digits_b [4099:0];
	
	// parametters for asset positions and dimensions
	parameter video_start_x = 'd144;
	parameter video_start_y = 'd35;
	
	parameter buffer_step_x = 'd70;
	parameter buffer_step_y = 'd28;
	parameter buffer_width = 'd50;
	parameter buffer_height = 'd18;
	// the position of the upper left buffer
	parameter buffer_pos_x = 'd102;
	parameter buffer_pos_y = 'd289;
	
	parameter background_width = 'd640;
	// parameter background_height = 'd480;
	
	parameter digit_step_y='d21; // vertical step between the buffer digits in buffer bitmap image
	
	parameter out_switch_x = 197;
	parameter out_switch_y = 100;
	parameter out_switch_width = 72;
	parameter input_switch_x=197;
	parameter input_switch_y=337;
	
	parameter free_digit_width = 10;
	parameter free_digit_height = 16;
	parameter free_digit_gap_x = 2;
	parameter free_digit_bitmap_width = 'd122;
	
	parameter input_transmit_x=373;
	parameter input_transmit_y=167;
	parameter input_receive_x=373;
	parameter input_receive_y=243;
	parameter input_dropped_x=373;
	parameter input_dropped_y=324;
	
	parameter gui_width=49;
	
	assign vga_sync_n = 1'b1;
	assign vga_blank_n = 1'b1;
	
	
	initial begin
		i = 0;
		j = 0;
		k = 0;
		temp2bit = 0;
		
		vga_clk=0;
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
		drop_counts[0] = drop_count1;
		drop_counts[1] = drop_count2;
		drop_counts[2] = drop_count3;
		drop_counts[3] = drop_count4;
		input_counts[0] = input_count1;
		input_counts[1] = input_count2;
		input_counts[2] = input_count3;
		input_counts[3] = input_count4;
		
		sum_transmitted = 0;
		sum_dropped = 0;
		sum_input = 0;
		
		// initialize vga signals
		h_count = 0;
		v_count = 0;
		vsynch = 1;
		hsynch = 1;
		vga_red = 0;
		vga_green = 0;
		vga_blue = 0;
		
		// import image pixels from .mem files
		$readmemb("WIN95_r.mem",background_r);
		$readmemb("WIN95_g.mem",background_g);
		$readmemb("WIN95_b.mem",background_b);
		
		
		$readmemb("green-digits_r.mem",green_digits_r);
		$readmemb("green-digits_g.mem",green_digits_g);
		$readmemb("green-digits_b.mem",green_digits_b);
		
		
		$readmemb("blue-digits_r.mem",blue_digits_r);
		$readmemb("blue-digits_g.mem",blue_digits_g);
		$readmemb("blue-digits_b.mem",blue_digits_b);
		
		
		$readmemb("gray-digits_r.mem",gray_digits_r);
		$readmemb("gray-digits_g.mem",gray_digits_g);
		$readmemb("gray-digits_b.mem",gray_digits_b);
		
		
		$readmemb("red-digits_r.mem",red_digits_r);
		$readmemb("red-digits_g.mem",red_digits_g);
		$readmemb("red-digits_b.mem",red_digits_b);
		
		
		$readmemb("yellow-digits_r.mem",yellow_digits_r);
		$readmemb("yellow-digits_g.mem",yellow_digits_g);
		$readmemb("yellow-digits_b.mem",yellow_digits_b);
		
	end
	
	always @(posedge vga_clk) begin
		h_count<=h_count+1;
		if (h_count==800) begin
			h_count<=0;
			v_count<=v_count+1;
		end
		if (v_count==525)begin
			v_count<=0;
		end
	end
	
	always @(posedge vga_clk) begin
		if (v_count<2) begin
			vsynch<=0;
		end
		else begin
			vsynch<=1;
		end
		if (h_count<96) begin
			hsynch<=0;
		end
		else begin
			hsynch<=1;
		end
	end
	
	always @(posedge vga_clk) begin
		
		sum_transmitted = 0;
		sum_dropped = 0;
		sum_input = 0;
		
		// Grouping inputs
//		fullnesses[0] = fullness1;
//		fullnesses[1] = fullness2;
//		fullnesses[2] = fullness3;
//		fullnesses[3] = fullness4;

		fullnesses[0] = 3;
		fullnesses[1] = 4;
		fullnesses[2] = 1;
		fullnesses[3] = 5;
		
//		memories[0] = memory1;
//		memories[1] = memory2;
//		memories[2] = memory3;
//		memories[3] = memory4;
		
		memories[0] = 24'd27;
		memories[1] = 24'd27;
		memories[2] = 24'd228;
		memories[3] = 24'd228;
		
		drop_counts[0] = drop_count1;
		drop_counts[1] = drop_count2;
		drop_counts[2] = drop_count3;
		drop_counts[3] = drop_count4;
		
		input_counts[0] = input_count1;
		input_counts[1] = input_count2;
		input_counts[2] = input_count3;
		input_counts[3] = input_count4;
		
		
		
		
		
		// Binary to bcd converter calculations
		for (i=0;i<4;i=i+1) begin
		drop_counts_bcd [i][3:0] =   (drop_counts[i])%10;                // First digit
		drop_counts_bcd [i][7:4] =  ((drop_counts[i])/10)%10;           // Second digit
		drop_counts_bcd [i][11:8] = ((drop_counts[i])/100);         // Last digit - 3 digit numbers at most!!
		
		input_counts_bcd [i][3:0] =   (input_counts[i])%10;
		input_counts_bcd [i][7:4] =  ((input_counts[i])/10)%10;
		input_counts_bcd [i][11:8] = ((input_counts[i])/100);
		
		transmitted_counts_bcd [i][3:0] =   (input_counts[i]-drop_counts[i])%10;
		transmitted_counts_bcd [i][7:4] =  ((input_counts[i]-drop_counts[i])/10)%10;
		transmitted_counts_bcd [i][11:8] = ((input_counts[i]-drop_counts[i])/100);
		
		sum_transmitted = sum_transmitted + (input_counts[i]-drop_counts[i]);
		sum_dropped = sum_dropped + drop_counts[i];
		sum_input = sum_input + input_counts[i];
		end
		
		// Binary to bcd converter for total values
		drop_counts_bcd [4][3:0] =   (sum_dropped)%10;
		drop_counts_bcd [4][7:4] =  ((sum_dropped)/10)%10;
		drop_counts_bcd [4][11:8] = ((sum_dropped)/100);
		
		input_counts_bcd [4][3:0] =   (sum_input)%10;
		input_counts_bcd [4][7:4] =  (sum_input/10)%10;
		input_counts_bcd [4][11:8] = (sum_input/100);
		
		transmitted_counts_bcd [4][3:0] =   (sum_transmitted)%10;
		transmitted_counts_bcd [4][7:4] =  ((sum_transmitted)/10)%10;
		transmitted_counts_bcd [4][11:8] = ((sum_transmitted)/100);
		
		
		// Data written to the output switch
		for (i=0;i<4;i=i+1) begin
			if (read[i]==1 && fullnesses[i] != 0) begin
				for (j=0;j<4;j=j+1) begin
					data_read[j] = memories[i][fullnesses[i]*4+j];
				end
			end
		end


		// Paint background
		if (h_count<784 && h_count>=144 && v_count<515 && v_count>=36 ) begin
			vga_red[7:0]<=128*(background_r[(h_count - video_start_x) + background_width*(v_count-video_start_y)])+64 ;
			vga_green[7:0]<=128*(background_g[(h_count - video_start_x) + background_width*(v_count-video_start_y)])+64 ;
			vga_blue[7:0]<=128*(background_b[(h_count - video_start_x) + background_width*(v_count-video_start_y)])+64 ;
		end
		else begin
				vga_red[7:0]=0;
				vga_green[7:0]=0;
				vga_blue[7:0]=0;
		end
		
		// Paint output                               data_read     shows output data
		for (i=0;i<4;i=i+1) begin
			if (h_count<(video_start_x + (out_switch_x + 16) + (i+1)*free_digit_width) && h_count>= (video_start_x + (out_switch_x + 16) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (out_switch_y + 3) + free_digit_height) && v_count>=(video_start_y + (out_switch_y + 3))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(data_read[i]+1)*(free_digit_gap_x) + free_digit_width*data_read[i] + (h_count - (video_start_x + (out_switch_x + 16) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (out_switch_y + 3)))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(data_read[i]+1)*(free_digit_gap_x) + free_digit_width*data_read[i] + (h_count - (video_start_x + (out_switch_x + 16) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (out_switch_y + 3)))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(data_read[i]+1)*(free_digit_gap_x) + free_digit_width*data_read[i] + (h_count - (video_start_x + (out_switch_x + 16) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (out_switch_y + 3)))])+64;
			end
		end
		
		// Paint input
		for (i=0;i<4;i=i+1) begin
			if (h_count<(video_start_x + (input_switch_x + 16) + (i+1)*free_digit_width) && h_count>= (video_start_x + (input_switch_x + 16) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_switch_y + 3) + free_digit_height) && v_count>=(video_start_y + (input_switch_y + 3))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(p_in[i]+1)*(free_digit_gap_x) + free_digit_width*p_in[i] + (h_count - (video_start_x + (input_switch_x + 16) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_switch_y + 3)))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(p_in[i]+1)*(free_digit_gap_x) + free_digit_width*p_in[i] + (h_count - (video_start_x + (input_switch_x + 16) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_switch_y + 3)))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(p_in[i]+1)*(free_digit_gap_x) + free_digit_width*p_in[i] + (h_count - (video_start_x + (input_switch_x + 16) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_switch_y + 3)))])+64;
			end
		end
	
		// Transmit input
			for (i=0;i<3;i=i+1) begin
				if (h_count<(gui_width*0+video_start_x + (input_transmit_x) + (i+1)*free_digit_width) && h_count>= (gui_width*0+video_start_x + (input_transmit_x) + (i)*free_digit_width) && 
					v_count<(video_start_y + (input_transmit_y) + free_digit_height) && v_count>=(video_start_y + (input_transmit_y ))) begin
			
					vga_red[7:0]<=128*(gray_digits_r[(transmitted_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
					vga_green[7:0]<=128*(gray_digits_g[(transmitted_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
					vga_blue[7:0]<=128*(gray_digits_b[(transmitted_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				end
				if (h_count<(gui_width*1+video_start_x + (input_transmit_x) + (i+1)*free_digit_width) && h_count>= (gui_width*1+video_start_x + (input_transmit_x) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_transmit_y) + free_digit_height) && v_count>=(video_start_y + (input_transmit_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(transmitted_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(transmitted_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(transmitted_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				end
				if (h_count<(gui_width*2+video_start_x + (input_transmit_x) + (i+1)*free_digit_width) && h_count>= (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_transmit_y) + free_digit_height) && v_count>=(video_start_y + (input_transmit_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(transmitted_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(transmitted_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(transmitted_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				end
				if (h_count<(gui_width*3+video_start_x + (input_transmit_x) + (i+1)*free_digit_width) && h_count>= (gui_width*3+video_start_x + (input_transmit_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_transmit_y) + free_digit_height) && v_count>=(video_start_y + (input_transmit_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(transmitted_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(transmitted_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(transmitted_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				end
				if (h_count<(gui_width*4+video_start_x + (input_transmit_x) + (i+1)*free_digit_width) && h_count>= (gui_width*4+video_start_x + (input_transmit_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_transmit_y) + free_digit_height) && v_count>=(video_start_y + (input_transmit_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(transmitted_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(transmitted_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(transmitted_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*transmitted_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_transmit_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_transmit_y )))])+64;
				end
			end
			
			
				// Receive input
					for (i=0;i<3;i=i+1) begin
				if (h_count<(gui_width*0+video_start_x + (input_receive_x) + (i+1)*free_digit_width) && h_count>= (gui_width*0+video_start_x + (input_receive_x) + (i)*free_digit_width) && 
					v_count<(video_start_y + (input_receive_y) + free_digit_height) && v_count>=(video_start_y + (input_receive_y ))) begin
			
					vga_red[7:0]<=128*(gray_digits_r[(input_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
					vga_green[7:0]<=128*(gray_digits_g[(input_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
					vga_blue[7:0]<=128*(gray_digits_b[(input_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				end
				if (h_count<(gui_width*1+video_start_x + (input_receive_x) + (i+1)*free_digit_width) && h_count>= (gui_width*1+video_start_x + (input_receive_x) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_receive_y) + free_digit_height) && v_count>=(video_start_y + (input_receive_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(input_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(input_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(input_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				end
				if (h_count<(gui_width*2+video_start_x + (input_receive_x) + (i+1)*free_digit_width) && h_count>= (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_receive_y) + free_digit_height) && v_count>=(video_start_y + (input_receive_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(input_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(input_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(input_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				end
				if (h_count<(gui_width*3+video_start_x + (input_receive_x) + (i+1)*free_digit_width) && h_count>= (gui_width*3+video_start_x + (input_receive_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_receive_y) + free_digit_height) && v_count>=(video_start_y + (input_receive_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(input_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(input_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(input_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				end
				if (h_count<(gui_width*4+video_start_x + (input_receive_x) + (i+1)*free_digit_width) && h_count>= (gui_width*4+video_start_x + (input_receive_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_receive_y) + free_digit_height) && v_count>=(video_start_y + (input_receive_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(input_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(input_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(input_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*input_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_receive_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_receive_y )))])+64;
				end
			end
		
		
				// Drop input
				for (i=0;i<3;i=i+1) begin
				if (h_count<(gui_width*0+video_start_x + (input_dropped_x) + (i+1)*free_digit_width) && h_count>= (gui_width*0+video_start_x + (input_dropped_x) + (i)*free_digit_width) && 
				v_count<(video_start_y + (input_dropped_y) + free_digit_height) && v_count>=(video_start_y + (input_dropped_y ))) begin
				vga_red[7:0]<=128*(gray_digits_r[(drop_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(drop_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(drop_counts_bcd [0][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [0][3+i*4-:3] + (h_count - (gui_width*0+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				end
				if (h_count<(gui_width*1+video_start_x + (input_dropped_x) + (i+1)*free_digit_width) && h_count>= (gui_width*1+video_start_x + (input_dropped_x) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_dropped_y) + free_digit_height) && v_count>=(video_start_y + (input_dropped_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(drop_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(drop_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(drop_counts_bcd [1][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [1][3+i*4-:3] + (h_count - (gui_width*1+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				end
				if (h_count<(gui_width*2+video_start_x + (input_dropped_x) + (i+1)*free_digit_width) && h_count>= (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_dropped_y) + free_digit_height) && v_count>=(video_start_y + (input_dropped_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(drop_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(drop_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(drop_counts_bcd [2][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [2][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				end
				if (h_count<(gui_width*3+video_start_x + (input_dropped_x) + (i+1)*free_digit_width) && h_count>= (gui_width*3+video_start_x + (input_dropped_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_dropped_y) + free_digit_height) && v_count>=(video_start_y + (input_dropped_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(drop_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(drop_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(drop_counts_bcd [3][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [3][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				end
				if (h_count<(gui_width*4+video_start_x + (input_dropped_x) + (i+1)*free_digit_width) && h_count>= (gui_width*4+video_start_x + (input_dropped_x ) + (i)*free_digit_width) && 
				 v_count<(video_start_y + (input_dropped_y) + free_digit_height) && v_count>=(video_start_y + (input_dropped_y ))) begin
				
				vga_red[7:0]<=128*(gray_digits_r[(drop_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_green[7:0]<=128*(gray_digits_g[(drop_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				vga_blue[7:0]<=128*(gray_digits_b[(drop_counts_bcd [4][3+i*4-:3]+1)*(free_digit_gap_x) + free_digit_width*drop_counts_bcd [4][3+i*4-:3] + (h_count - (gui_width*2+video_start_x + (input_dropped_x ) + (i)*free_digit_width)) + free_digit_bitmap_width*(v_count-(video_start_y + (input_dropped_y )))])+64;
				end
			end
		
		// Paint buffers
		for (i=0;i<4;i=i+1) begin
			for (j=0;j<6;j=j+1) begin
				if (j < fullnesses[i]) begin
					for (k=0;k<2;k=k+1) begin
						temp2bit[k] = memories[i][j*4+k];
					end
					
					if (h_count<(video_start_x + buffer_pos_x + i*buffer_step_x + buffer_width) && h_count>= (video_start_x + buffer_pos_x + i*buffer_step_x) && 
					    v_count<(video_start_y + buffer_pos_y - j*buffer_step_y + buffer_height) && v_count>=(video_start_y + buffer_pos_y - j*buffer_step_y)) begin
						
						if (i == 0) begin
							vga_red[7:0]<=128*(red_digits_r[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_green[7:0]<=128*(red_digits_g[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_blue[7:0]<=128*(red_digits_b[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
						end
						
						if (i == 1) begin
							vga_red[7:0]<=128*(blue_digits_r[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_green[7:0]<=128*(blue_digits_g[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_blue[7:0]<=128*(blue_digits_b[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
						end
						
						if (i == 2) begin
							vga_red[7:0]<=128*(yellow_digits_r[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_green[7:0]<=128*(yellow_digits_g[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_blue[7:0]<=128*(yellow_digits_b[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
						end
						
						if (i == 3) begin
							vga_red[7:0]<=128*(green_digits_r[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_green[7:0]<=128*(green_digits_g[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
							vga_blue[7:0]<=128*(green_digits_b[(3-temp2bit)*(digit_step_y*buffer_width)+(h_count - (video_start_x + buffer_pos_x + i*buffer_step_x)) + buffer_width*(v_count-(video_start_y + buffer_pos_y - j*buffer_step_y))])+64;
						end
						
					end
				end
				
			end
		end
	end
	
	always @(posedge clk) begin
			
		vga_clk = !vga_clk;
			
	end
	
endmodule

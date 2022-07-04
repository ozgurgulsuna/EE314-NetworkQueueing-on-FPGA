module vga_test(
	input clk,
	output reg hsynch,
	output reg vsynch,
	output reg [7:0] vga_red,
	output reg [7:0] vga_green,
	output reg [7:0] vga_blue,
	output reg vga_clk,
	output vga_sync_n,
	output vga_blank_n
);
	
	integer h_count;
	integer v_count;
	
	reg background_r [307199:0];
	reg background_g [307199:0];
	reg background_b [307199:0];
	
	
	reg back_digits_r [307199:0];
	reg back_digits_g [307199:0];
	reg back_digits_b [307199:0];
	
	
	reg blue_digits_r [307199:0];
	reg blue_digits_g [307199:0];
	reg blue_digits_b [307199:0];
	
	
	reg gray_digits_r [307199:0];
	reg gray_digits_g [307199:0];
	reg gray_digits_b [307199:0];
	
	
	reg red_digits_r [307199:0];
	reg red_digits_g [307199:0];
	reg red_digits_b [307199:0];
	
	
	reg yellow_digits_r [307199:0];
	reg yellow_digits_g [307199:0];
	reg yellow_digits_b [307199:0];
	
	parameter video_start_h_count = 'd144;
	parameter video_start_v_count = 'd35;
	
	parameter background_width = 'd640;
	// parameter background_height = 'd480;
	assign vga_sync_n = 1'b1;
	assign vga_blank_n = 1'b1;
	
	initial begin
		vga_clk = 0;
		h_count=0;
		v_count=0;
		vsynch=1;
		hsynch=1;
		vga_red=0;
		vga_green=0;
		vga_blue=0;
		
		$readmemb("WIN95_r.mem",background_r);
		$readmemb("WIN95_g.mem",background_g);
		$readmemb("WIN95_b.mem",background_b);
		
		
		$readmemb("back-digits_r.mem",back_digits_r);
		$readmemb("back-digits_g.mem",back_digits_g);
		$readmemb("back-digits_b.mem",back_digits_b);
		
		
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
		
		if (h_count<784 && h_count>=144 && v_count<515 && v_count>=36 ) begin
			vga_red[7:0]<=128*(background_r[(h_count - video_start_h_count) + background_width*(v_count-video_start_v_count)])+64 ;
			vga_green[7:0]<=128*(background_g[(h_count - video_start_h_count) + background_width*(v_count-video_start_v_count)])+64 ;
			vga_blue[7:0]<=128*(background_b[(h_count - video_start_h_count) + background_width*(v_count-video_start_v_count)])+64 ;
		end
		else begin
				vga_red[7:0]=0;
				vga_green[7:0]=0;
				vga_blue[7:0]=0;
		end
		
	end
	
	
	always @(posedge clk) begin
		vga_clk = !vga_clk;
	end
	
	
endmodule

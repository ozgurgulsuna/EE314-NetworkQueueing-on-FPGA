/*
WARNING: Do NOT edit the input and output ports in this file in a text
editor if you plan to continue editing the block that represents it in
the Block Editor! File corruption is VERY likely to occur.
*/
/*
Copyright (C) 1991-2013 Altera Corporation
Your use of Altera Corporation's design tools, logic functions 
and other software and tools, and its AMPP partner logic 
functions, and any output files from any of the foregoing 
(including device programming or simulation files), and any 
associated documentation or information are expressly subject 
to the terms and conditions of the Altera Program License 
Subscription Agreement, Altera MegaCore Function License 
Agreement, or other applicable license agreement, including, 
without limitation, that your use is for the sole purpose of 
programming logic devices manufactured by Altera and sold by 
Altera or its authorized distributors.  Please refer to the 
applicable agreement for further details.
*/
(header "graphic" (version "1.4"))
(pin
	(input)
	(rect 272 360 448 376)
	(text "INPUT" (rect 133 0 161 10)(font "Arial" (font_size 6)))
	(text "pin_name1" (rect 9 0 62 12)(font "Arial" ))
	(pt 176 8)
	(drawing
		(line (pt 92 12)(pt 117 12))
		(line (pt 92 4)(pt 117 4))
		(line (pt 121 8)(pt 176 8))
		(line (pt 92 12)(pt 92 4))
		(line (pt 117 4)(pt 121 8))
		(line (pt 117 12)(pt 121 8))
	)
	(text "VCC" (rect 136 7 156 17)(font "Arial" (font_size 6)))
)
(pin
	(input)
	(rect 264 360 432 376)
	(text "INPUT" (rect 125 0 153 10)(font "Arial" (font_size 6)))
	(text "pin_name2" (rect 5 0 59 12)(font "Arial" ))
	(pt 168 8)
	(drawing
		(line (pt 84 12)(pt 109 12))
		(line (pt 84 4)(pt 109 4))
		(line (pt 113 8)(pt 168 8))
		(line (pt 84 12)(pt 84 4))
		(line (pt 109 4)(pt 113 8))
		(line (pt 109 12)(pt 113 8))
	)
	(text "VCC" (rect 128 7 148 17)(font "Arial" (font_size 6)))
)
(pin
	(output)
	(rect 600 360 776 376)
	(text "OUTPUT" (rect 1 0 39 10)(font "Arial" (font_size 6)))
	(text "pin_name3" (rect 90 0 143 12)(font "Arial" ))
	(pt 0 8)
	(drawing
		(line (pt 0 8)(pt 52 8))
		(line (pt 52 4)(pt 78 4))
		(line (pt 52 12)(pt 78 12))
		(line (pt 52 12)(pt 52 4))
		(line (pt 78 4)(pt 82 8))
		(line (pt 82 8)(pt 78 12))
		(line (pt 78 12)(pt 82 8))
	)
)
(pin
	(output)
	(rect 600 376 776 392)
	(text "OUTPUT" (rect 1 0 39 10)(font "Arial" (font_size 6)))
	(text "pin_name4" (rect 90 0 143 12)(font "Arial" ))
	(pt 0 8)
	(drawing
		(line (pt 0 8)(pt 52 8))
		(line (pt 52 4)(pt 78 4))
		(line (pt 52 12)(pt 78 12))
		(line (pt 52 12)(pt 52 4))
		(line (pt 78 4)(pt 82 8))
		(line (pt 82 8)(pt 78 12))
		(line (pt 78 12)(pt 82 8))
	)
)
(symbol
	(rect 448 336 592 416)
	(text "clk_div" (rect 5 0 40 12)(font "Arial" ))
	(text "inst" (rect 8 64 25 76)(font "Arial" ))
	(port
		(pt 0 32)
		(input)
		(text "clk" (rect 0 0 14 12)(font "Arial" ))
		(text "clk" (rect 21 27 35 39)(font "Arial" ))
		(line (pt 0 32)(pt 16 32))
	)
	(port
		(pt 144 32)
		(output)
		(text "read_clk" (rect 0 0 41 12)(font "Arial" ))
		(text "read_clk" (rect 89 27 130 39)(font "Arial" ))
		(line (pt 144 32)(pt 128 32))
	)
	(port
		(pt 144 48)
		(output)
		(text "fract_clk" (rect 0 0 43 12)(font "Arial" ))
		(text "fract_clk" (rect 87 43 130 55)(font "Arial" ))
		(line (pt 144 48)(pt 128 48))
	)
	(parameter
		"clockfreq"
		"10000000"
		""
		(type "PARAMETER_SIGNED_DEC")	)
	(drawing
		(rectangle (rect 16 16 128 64))
	)
	(annotation_block (parameter)(rect 608 288 808 320))
)
(connector
	(pt 592 384)
	(pt 600 384)
)
(connector
	(pt 592 368)
	(pt 600 368)
)

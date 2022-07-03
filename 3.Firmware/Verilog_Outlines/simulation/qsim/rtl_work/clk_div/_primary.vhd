library verilog;
use verilog.vl_types.all;
entity clk_div is
    port(
        clk             : in     vl_logic;
        read_clk        : out    vl_logic;
        fract_clk       : out    vl_logic;
        slow_clk        : out    vl_logic;
        vga_clk         : out    vl_logic
    );
end clk_div;

library verilog;
use verilog.vl_types.all;
entity clk_div_vlg_check_tst is
    port(
        fract_clk       : in     vl_logic;
        read_clk        : in     vl_logic;
        slow_clk        : in     vl_logic;
        vga_clk         : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end clk_div_vlg_check_tst;

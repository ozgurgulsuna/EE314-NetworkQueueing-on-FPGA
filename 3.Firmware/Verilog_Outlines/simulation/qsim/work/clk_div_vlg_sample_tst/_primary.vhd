library verilog;
use verilog.vl_types.all;
entity clk_div_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end clk_div_vlg_sample_tst;

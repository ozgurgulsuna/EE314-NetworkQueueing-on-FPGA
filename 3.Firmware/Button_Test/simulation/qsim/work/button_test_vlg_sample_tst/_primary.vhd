library verilog;
use verilog.vl_types.all;
entity button_test_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        in_0            : in     vl_logic;
        in_1            : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end button_test_vlg_sample_tst;

library verilog;
use verilog.vl_types.all;
entity debouncer_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        pb_1            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end debouncer_vlg_sample_tst;

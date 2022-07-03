library verilog;
use verilog.vl_types.all;
entity decision_test_vlg_sample_tst is
    port(
        fract_clk       : in     vl_logic;
        pin             : in     vl_logic_vector(3 downto 0);
        read_clk        : in     vl_logic;
        write           : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end decision_test_vlg_sample_tst;

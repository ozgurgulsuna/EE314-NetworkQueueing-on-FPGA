library verilog;
use verilog.vl_types.all;
entity button_test_vlg_check_tst is
    port(
        bouncy4         : in     vl_logic;
        ff              : in     vl_logic;
        p_out           : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end button_test_vlg_check_tst;

library verilog;
use verilog.vl_types.all;
entity switch_vlg_check_tst is
    port(
        p_out           : in     vl_logic_vector(3 downto 0);
        write           : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end switch_vlg_check_tst;

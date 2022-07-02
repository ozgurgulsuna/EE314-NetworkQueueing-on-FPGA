library verilog;
use verilog.vl_types.all;
entity switch_vlg_check_tst is
    port(
        count4          : in     vl_logic_vector(2 downto 0);
        p_out           : in     vl_logic_vector(3 downto 0);
        stop            : in     vl_logic;
        write           : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end switch_vlg_check_tst;

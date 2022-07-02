library verilog;
use verilog.vl_types.all;
entity main_vlg_check_tst is
    port(
        p_out           : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end main_vlg_check_tst;

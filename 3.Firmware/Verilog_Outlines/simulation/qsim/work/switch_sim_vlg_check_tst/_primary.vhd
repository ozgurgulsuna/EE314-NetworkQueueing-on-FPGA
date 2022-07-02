library verilog;
use verilog.vl_types.all;
entity switch_sim_vlg_check_tst is
    port(
        c_out1          : in     vl_logic_vector(1 downto 0);
        p_out           : in     vl_logic_vector(3 downto 0);
        write           : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end switch_sim_vlg_check_tst;

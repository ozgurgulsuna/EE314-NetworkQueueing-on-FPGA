library verilog;
use verilog.vl_types.all;
entity buffer_sim_vlg_check_tst is
    port(
        fullness        : in     vl_logic_vector(2 downto 0);
        memory          : in     vl_logic_vector(23 downto 0);
        sampler_rx      : in     vl_logic
    );
end buffer_sim_vlg_check_tst;

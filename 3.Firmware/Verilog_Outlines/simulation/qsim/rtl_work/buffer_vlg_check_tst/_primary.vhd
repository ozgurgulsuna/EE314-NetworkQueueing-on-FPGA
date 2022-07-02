library verilog;
use verilog.vl_types.all;
entity buffer_vlg_check_tst is
    port(
        drop_count      : in     vl_logic_vector(7 downto 0);
        fullness        : in     vl_logic_vector(2 downto 0);
        input_count     : in     vl_logic_vector(9 downto 0);
        memory          : in     vl_logic_vector(23 downto 0);
        time_total      : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end buffer_vlg_check_tst;

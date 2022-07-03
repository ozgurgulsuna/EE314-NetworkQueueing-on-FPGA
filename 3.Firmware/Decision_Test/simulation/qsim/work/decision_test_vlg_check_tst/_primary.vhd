library verilog;
use verilog.vl_types.all;
entity decision_test_vlg_check_tst is
    port(
        full1           : in     vl_logic_vector(2 downto 0);
        full2           : in     vl_logic_vector(2 downto 0);
        full3           : in     vl_logic_vector(2 downto 0);
        full4           : in     vl_logic_vector(2 downto 0);
        MEM_1           : in     vl_logic_vector(23 downto 0);
        MEM_2           : in     vl_logic_vector(23 downto 0);
        MEM_3           : in     vl_logic_vector(23 downto 0);
        MEM_4           : in     vl_logic_vector(23 downto 0);
        sampler_rx      : in     vl_logic
    );
end decision_test_vlg_check_tst;

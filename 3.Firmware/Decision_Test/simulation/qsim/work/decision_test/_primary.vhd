library verilog;
use verilog.vl_types.all;
entity decision_test is
    port(
        full1           : out    vl_logic_vector(2 downto 0);
        fract_clk       : in     vl_logic;
        read_clk        : in     vl_logic;
        write           : in     vl_logic_vector(3 downto 0);
        pin             : in     vl_logic_vector(3 downto 0);
        full2           : out    vl_logic_vector(2 downto 0);
        full3           : out    vl_logic_vector(2 downto 0);
        full4           : out    vl_logic_vector(2 downto 0);
        MEM_1           : out    vl_logic_vector(23 downto 0);
        MEM_2           : out    vl_logic_vector(23 downto 0);
        MEM_3           : out    vl_logic_vector(23 downto 0);
        MEM_4           : out    vl_logic_vector(23 downto 0)
    );
end decision_test;

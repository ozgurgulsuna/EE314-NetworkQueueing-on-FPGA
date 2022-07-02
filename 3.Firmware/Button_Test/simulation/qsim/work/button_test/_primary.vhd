library verilog;
use verilog.vl_types.all;
entity button_test is
    port(
        ff              : out    vl_logic;
        clk             : in     vl_logic;
        bouncy4         : out    vl_logic;
        start           : in     vl_logic;
        p_out           : out    vl_logic_vector(3 downto 0);
        in_0            : in     vl_logic;
        in_1            : in     vl_logic
    );
end button_test;

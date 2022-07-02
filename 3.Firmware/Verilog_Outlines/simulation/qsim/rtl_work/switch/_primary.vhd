library verilog;
use verilog.vl_types.all;
entity switch is
    port(
        fract_clk       : in     vl_logic;
        start           : in     vl_logic;
        in_0            : in     vl_logic;
        in_1            : in     vl_logic;
        write           : out    vl_logic_vector(3 downto 0);
        p_out           : out    vl_logic_vector(3 downto 0);
        count4          : out    vl_logic_vector(2 downto 0);
        stop            : out    vl_logic
    );
end switch;

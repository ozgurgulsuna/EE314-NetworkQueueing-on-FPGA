library verilog;
use verilog.vl_types.all;
entity switch_sim is
    port(
        c_out1          : out    vl_logic_vector(1 downto 0);
        fract_clk       : in     vl_logic;
        start           : in     vl_logic;
        in_0            : in     vl_logic;
        in_1            : in     vl_logic;
        p_out           : out    vl_logic_vector(3 downto 0);
        write           : out    vl_logic_vector(3 downto 0)
    );
end switch_sim;

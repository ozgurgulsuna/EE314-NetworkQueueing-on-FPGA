library verilog;
use verilog.vl_types.all;
entity \buffer\ is
    port(
        fract_clk       : in     vl_logic;
        p_in            : in     vl_logic_vector(3 downto 0);
        read            : in     vl_logic;
        write           : in     vl_logic;
        memory          : out    vl_logic_vector(23 downto 0);
        fullness        : out    vl_logic_vector(2 downto 0);
        time_total      : out    vl_logic_vector(15 downto 0);
        input_count     : out    vl_logic_vector(9 downto 0);
        drop_count      : out    vl_logic_vector(7 downto 0)
    );
end \buffer\;

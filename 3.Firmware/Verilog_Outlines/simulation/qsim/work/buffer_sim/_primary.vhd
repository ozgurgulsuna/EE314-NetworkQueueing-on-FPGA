library verilog;
use verilog.vl_types.all;
entity buffer_sim is
    port(
        fullness        : out    vl_logic_vector(2 downto 0);
        clk             : in     vl_logic;
        read            : in     vl_logic;
        write           : in     vl_logic;
        p_in            : in     vl_logic_vector(3 downto 0);
        memory          : out    vl_logic_vector(23 downto 0)
    );
end buffer_sim;

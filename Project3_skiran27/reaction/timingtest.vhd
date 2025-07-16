-- VHDL Testbench for Timer State Machine
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timingtest is
end entity;

architecture sim of timingtest is

    component timer
        port(
            clk     : in std_logic;
            reset   : in std_logic;
            start   : in std_logic;
            react   : in std_logic;
            cycles  : out unsigned(7 downto 0);
            leds    : out std_logic_vector(2 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal start   : std_logic := '1';
    signal react   : std_logic := '1';
    signal cycles  : unsigned(7 downto 0);
    signal leds    : std_logic_vector(2 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: timer
        port map (
            clk => clk,
            reset => reset,
            start => start,
            react => react,
            cycles => cycles,
            leds => leds
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stim_process : process
    begin
        wait for 10 ns;
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 10 ns;

        start <= '0';
        wait for 10 ns;
        start <= '1';
        wait for 30 ns;
		  
        react <= '0';
        wait for 10 ns;
        react <= '1';

        wait for 100 ns;

        start <= '0';
        wait for 10 ns;
        start <= '1';

        wait for 50 ns;
        react <= '0';
        wait for 10 ns;
        react <= '1';

        wait;
    end process;

end architecture;
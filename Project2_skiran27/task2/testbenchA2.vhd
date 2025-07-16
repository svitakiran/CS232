-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbenchA2 is
end testbenchA2;

architecture Behavioral of testbenchA2 is
    signal A      : UNSIGNED(3 downto 0);
    signal B      : UNSIGNED(3 downto 0);
    signal sum    : UNSIGNED(4 downto 0);

    component adder
        Port (
            A      : in UNSIGNED(3 downto 0);
            B      : in UNSIGNED(3 downto 0);
            sum    : out UNSIGNED(4 downto 0)
        );
    end component;

    signal hex_sum_low  : UNSIGNED(3 downto 0);
    signal hex_sum_high : UNSIGNED(3 downto 0);
    signal segments_low  : UNSIGNED(6 downto 0);
    signal segments_high : UNSIGNED(6 downto 0);

    component hexdisplay
        Port (
            hex_input : in UNSIGNED(3 downto 0);
            segments  : out UNSIGNED(6 downto 0)
        );
    end component;

begin
    uut: adder
        Port Map (
            A      => A,
            B      => B,
            sum    => sum
        );

    hex_low: hexdisplay
        Port Map (
            hex_input => hex_sum_low,
            segments  => segments_low
        );

    hex_high: hexdisplay
        Port Map (
            hex_input => hex_sum_high,
            segments  => segments_high
        );

    process
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                A <= to_unsigned(i, 4);
                B <= to_unsigned(j, 4);
                wait for 10 ns;

                hex_sum_low  <= sum(3 downto 0);
                hex_sum_high <= sum(4 downto 4) & "000";

                wait for 10 ns;
            end loop;
        end loop;

        wait;
    end process;

end Behavioral;
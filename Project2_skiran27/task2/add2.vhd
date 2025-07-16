-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add2 is
    Port (
        A      : in UNSIGNED(3 downto 0);
        B      : in UNSIGNED(3 downto 0);
        sum    : out UNSIGNED(4 downto 0)
    );
end add2;

architecture Behavioral of add2 is
begin
    process(A, B)
    begin
        sum <= ('0' & A) + ('0' & B);
    end process;
end Behavioral;

-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lightrom is

	port 
	(
		addr	   : in std_logic_vector (3 downto 0);
		data : out std_logic_vector (2 downto 0)
	);

end entity;

architecture rtl of lightrom is
begin

	data <= 
      "000" when addr = "0000" else -- move 0s to LR  00000000
      "101" when addr = "0001" else -- bit invert LR  11111111
      "101" when addr = "0010" else -- bit invert LR  00000000
      "101" when addr = "0011" else -- bit invert LR  11111111
      "001" when addr = "0100" else -- shift LR right 01111111
      "001" when addr = "0101" else -- shift LR right 00111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "111" when addr = "0111" else -- rotate LR left 11111100
      "111" when addr = "1000" else -- rotate LR left 11111001
      "111" when addr = "1001" else -- rotate LR left 11110011
      "010" when addr = "1010" else -- shift LR left  11100110
      "010" when addr = "1011" else -- shift LR left  11001100
      "011" when addr = "1100" else -- add 1 to LR    11001101
      "100" when addr = "1101" else -- sub 1 from LR  11001100
      "101" when addr = "1110" else -- bit invert LR  00110011
      "011";                        -- add 1 to LR    00110100

end rtl;
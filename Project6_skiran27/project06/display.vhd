library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
	port 
	(
		a	   : UNSIGNED (3 downto 0);
		HEX : out UNSIGNED(6 downto 0)
	);

end entity;

architecture rtl of hexdisplay is
begin
	HEX(0) <= '0' when a = "0000" or a = "0010" or a = "0011" or a = "0101" or a = "0110" or a = "0111" 
	or a = "1000" or a = "1001" or a = "1010" or a = "1100" or a = "1110" or a = "1111" else '1'; 
	HEX(1) <= '0' when a = "0000" or a = "0001" or a = "0010" or a = "0011" or a = "0100" or a = "0111" 
	or a = "1000" or a = "1001" or a = "1010" or a = "1101" else '1';
	HEX(2) <= '0' when a = "0000" or a = "0001" or a = "0011" or a = "0100" or a = "0101" or a = "0110" 
	or a = "0111" or a = "1000" or a = "1001" or a = "1010" or a = "1011" or a = "1101" else '1';
	HEX(3) <= '0' when a = "0000" or a = "0010" or a = "0011" or a = "0101" or a = "0110" or a = "1000" 
	or a = "1011" or a = "1100" or a = "1101" or a = "1110" else '1';
	HEX(4) <= '0' when a = "0000" or a = "0010" or a = "0110" or a = "1000" or a = "1010" or a = "1011" 
	or a = "1100" or a = "1101" or a = "1110" or a = "1111" else '1';
	HEX(5) <= '0' when a = "0000" or a = "0100" or a = "0101" or a = "0110" or a = "1000" or a = "1001" 
	or a = "1010" or a = "1011" or a = "1100" or a = "1110" or a = "1111" else '1';
	HEX(6) <= '0' when a = "0010" or a = "0011" or a = "0100" or a = "0101" or a = "0110" or a = "1000" 
	or a = "1001" or a = "1010" or a = "1011" or a = "1101" or a = "1110" or a = "1111" else '1';
	
end rtl;
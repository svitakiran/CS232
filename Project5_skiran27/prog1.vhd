-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pldrom is

	port 
	(
		addr	   : in std_logic_vector (3 downto 0);
		data : out std_logic_vector (9 downto 0)
	);

end entity;

architecture rtl of pldrom is
begin

	-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pldrom is

	port 
	(
		addr	   : in std_logic_vector (3 downto 0);
		data : out std_logic_vector (9 downto 0)
	);

end entity;

architecture rtl of pldrom is
begin

	data <= 
    "0001000000" when addr = "0000" else -- load 16
    "0100100000" when addr = "0001" else -- subtract 1
    "0111100000" when addr = "0010" else -- all 1s
    "0100000000" when addr = "0011" else -- all 0s
    "0000000000" when addr = "0100" else -- flash 
    "0000000000" when addr = "0101" else -- flash  
    "0001000000" when addr = "0110" else -- load 16
    "0000000000" when addr = "0111" else -- LR is 0
    "0000000000" when addr = "1000" else -- move
    "0000000000" when addr = "1001" else -- LR is 0
    "0000000000" when addr = "1010" else -- flash
    "0000000000" when addr = "1011" else -- flash
    "0000000000" when addr = "1100" else -- countdown
    "0000000000" when addr = "1101" else -- reset
    "1111111111" when addr = "1110" else -- all 1s 
    "0000000000";                        -- all 0s


end rtl;
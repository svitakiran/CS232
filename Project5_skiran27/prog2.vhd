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
    "0000000000" when addr = "0000" else -- set to 0
    "0110000000" when addr = "0001" else -- check count
    "0000000000" when addr = "0010" else -- move num
    "0000001010" when addr = "0011" else -- load 10
    "0110000000" when addr = "0100" else -- branch
    "0010100000" when addr = "0101" else -- add 1
    "0000000000" when addr = "0110" else -- move
    "1111111111" when addr = "0111" else -- set 1
    "0000000000" when addr = "1000" else -- set 0
    "0000000000" when addr = "1001" else -- flash
    "0000000000" when addr = "1010" else -- flash
    "0000000000" when addr = "1100" else -- reset flash
    "0000000000" when addr = "1101" else -- check flash
    "0000000000" when addr = "1110" else -- set
    "0000000000";                        -- garbage


end rtl;
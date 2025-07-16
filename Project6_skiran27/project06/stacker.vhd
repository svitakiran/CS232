-- CS232 Lab 6: stacker.vhd
-- Your name here
-- Date of the day you create this file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stacker is
	port( 
	
	clock: in std_logic;
   data:  in std_logic_vector(3 downto 0);
   b0:    in std_logic; -- switch values to mbr
   b1:    in std_logic; -- push mbr -> stack
   b2:    in std_logic; -- pop stack -> mbr
   mbrview : out std_logic_vector(3 downto 0);
   stackview: out std_logic_vector(3 downto 0);
   stateview: out std_logic_vector(2 downto 0)
	);	  
end entity;

architecture rtl of stacker is
	COMPONENT memram_lab IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	
END component memram_lab;
		
	signal RAM_input: std_logic_vector(3 downto 0);
	signal RAM_output: std_logic_vector(3 downto 0);
	signal RAM_we : std_LOGIC;
	signal stack_ptr : unsigned(3 downto 0);
	signal mbr : std_LOGIC_VECTOR(3 downto 0);
	signal state: std_LOGIC_VECTOR(2 downto 0);
	
begin
	
	RAMinstance : memram_lab
	
	port map (
		address => std_LOGIC_VECTOR (stack_ptr),
		clock => clock,
		data => RAM_input,
		wren => RAM_we,
		q => RAM_output
	);

	mbrview <= mbr;
	stackview <= std_LOGIC_vector (stack_ptr);
	stateview <= state; 

	process (clock, b1, b2)
	begin
		if b1 = '0' and b2 = '0' then
			stack_ptr <= "0000";
			mbr <= "0000";
			RAM_input <= "0000";
			RAM_we <= '0';
			state <= "000";
			
		elsif (rising_edge(clock)) then
			case state is
				when "000" => 
					if b0 = '0' then
						mbr <= data;
						state <= "111";
					elsif b1 = '0' then 
						RAM_input <= mbr; 
						RAM_we <= '1';
						state <= "001";
					elsif b2 = '0' then
						if stack_ptr /= 0 then 
							stack_ptr <= stack_ptr - 1;
							state <= "100";
						end if;
						
					end if;
				
				when "001" =>
					RAM_we <= '0';
					stack_ptr <= stack_ptr + 1; 
					state <= "111";
				when "100" =>
					state <= "101";
				when "101" =>
					state <= "110";
				when "110" =>
					state <= RAM_output;
				when "111" =>
				if b0 = '1' and b1 = '1' and b2 = '1' then 
					state <= "000";
					
				end if;
				when others => 
					state <= "000";
			end case;
		end if;
	end process;

end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
	port( 
	
	clock: in std_logic;
   data:  in std_logic_vector(7 downto 0);
   b0:    in std_logic; -- switch values to mbr
   b1:    in std_logic; -- push mbr -> stack
   b2:    in std_logic; -- pop stack -> mbr
	op : in std_logic_vector(1 downto 0);
   digit0 :out std_LOGIC_VECTOR(6 downto 0);
	digit1 : out std_LOGIC_VECTOR(6 downto 0)	
	);	  
end entity;

architecture rtl of calculator is
	COMPONENT memram IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	
END component memram;

Component hexdisplay is 
	port (
	a : in std_LOGIC_VECTOR(3 downto 0);
	HEX : out std_LOGIC_VECTOR(6 downto 0)
	);
	
end component hexdisplay;
		
	signal RAM_input: std_logic_vector(7 downto 0);
	signal RAM_output: std_logic_vector(7 downto 0);
	signal RAM_we : std_LOGIC;
	signal stack_ptr : unsigned(3 downto 0);
	signal mbr : std_LOGIC_VECTOR(7 downto 0);
	signal state: std_LOGIC_VECTOR(2 downto 0);
	signal temp_storage_mult : std_LOGIC_VECTOR(15 downto 0);
	
begin
	
	RAMinstance : memram
	
	port map (
		address => std_LOGIC_VECTOR (stack_ptr),
		clock => clock,
		data => RAM_input,
		wren => RAM_we,
		q => RAM_output
	);
	
	hexdisplay1: hexdisplay port map(a => mbr(3 downto 0), HEX => digit0);
	hexdisplay2: hexdisplay port map(a => mbr(7 downto 4), HEX => digit1);

	process (clock, b1, b2)
	begin
		if b1 = '0' and b2 = '0' then
			stack_ptr <= "0000";
			mbr <= "00000000";
			RAM_input <= "00000000";
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
					case op is 
						when "00" => 
							mbr <= std_LOGIC_VECTOR(unsigned(mbr) + unsigned(RAM_output));
							
						when "01" =>
							mbr <= std_LOGIC_VECTOR(unsigned(mbr) - unsigned(RAM_output));
							
						when "10" => 
							temp_storage_mult <= std_LOGIC_VECTOR(unsigned(mbr) * unsigned(RAM_output));
							mbr <= temp_storage_mult(7 downto 0);
							
						when "11" => 
							mbr <= std_LOGIC_VECTOR(unsigned(mbr) / unsigned(RAM_output));		
						
						when others =>
							end case;			
					state <= "111";
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
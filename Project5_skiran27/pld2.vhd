-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pld2 is

	port(
		clk		 : in	std_logic;
		reset	 : in	std_logic;
		lights	 : out	std_logic_vector(7 downto 0);
		IRview : out std_logic_vector(2 downto 0)
	);

end entity pld2;

architecture rtl of pld2 is

	component pldrom is
        port (
            addr : in std_logic_vector(3 downto 0);
            data : out std_logic_vector(9 downto 0)
        );
    end component;

	-- Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute1, sExecute2);

	-- Register to hold the current state
	signal IR   : std_logic_vector (9 downto 0);
	signal PC : unsigned (3 downto 0);
	signal LR : unsigned (7 downto 0);
	signal ROMvalue : std_logic_vector (9 downto 0);
	signal state : state_type;
	
	-- new internal signals 
	signal ACC : unsigned ( 7 downto 0);
	signal SRC : unsigned (7 downto 0);

begin

	ROMinstance: pldrom
			  port map (
					addr => std_logic_vector(PC),
					data => ROMvalue
			  );

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then 
			PC <= (others=>'0');
			IR <= (others=>'0');
			LR <= (others=>'0');
			ACC <= (others=>'0');
			state <= sFetch;
		elsif (rising_edge(clk)) then
			case state is
				when sFetch =>
					IR <= ROMvalue;
					PC <= PC + 1;
					state <= sExecute1;
					
				when sExecute1 =>
					if IR(9 downto 8) = "00" then -- move
						if IR(5 downto 4) = "00" then 
							SRC <= ACC;
							
						elsif IR(5 downto 4) = "01" then 
							SRC <= LR;
							
						elsif IR(5 downto 4) = "10" then 
							--SRC <= unsigned(IR(3) & IR(3) & IR(3) & IR(3) & IR(3 downto 0));
							if IR(3) = '1' then
								SRC <= "1111" & unsigned(IR(3 downto 0));
							else
								SRC <= "0000" & unsigned(IR(3 downto 0));
							end if;
							
						elsif IR(5 downto 4) = "11" then 
							SRC <= "11111111";
							
						
						end if;
						
					elsif IR(9 downto 8) = "01" then -- binary 
						if IR(4 downto 3) = "00" then 
							SRC <= ACC;
							
						elsif IR(4 downto 3) = "01" then 
							SRC <= LR; 
							
						elsif IR(4 downto 3) = "10" then 
							if IR(3) = '1' then
								SRC <= "1111" & unsigned(IR(3 downto 0));
							else
								SRC <= "0000" & unsigned(IR(3 downto 0));
							end if; 
							
						elsif IR(4 downto 3) = "11" then 
							SRC <= "11111111"; 
							
						end if;
						
							
					elsif IR(9 downto 8) = "11" then -- conditional branch
						if IR(7) = '0' then 
							if ACC = "00000000" then 
								PC <= unsigned(IR(3 downto 0));
								
							end if;
								
						else
							if LR = "00000000" then 
								PC <= unsigned(IR(3 downto 0));
							
							end if;
						
						end if;
							
					elsif IR(9 downto 8) = "10" then -- branch
						PC <= unsigned(IR(3 downto 0)); 
						--SRC <= unsigned(IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1 downto 0));
						
					end if;
				
				state <= sExecute2;
						
			--EXECUTE 2		
				when sExecute2 =>
					if IR(9 downto 8) = "00" then --MOVE
						if IR(7 downto 6) = "00" then 
							ACC <= SRC;
							
						elsif IR(7 downto 6) = "01" then 
							LR <= SRC;
							
						elsif IR(7 downto 6) = "10" then 
							ACC(3 downto 0) <= SRC(3 downto 0);
							
						elsif IR(7 downto 6) = "11" then 
							ACC(7 downto 4) <= SRC(3 downto 0);
							
					end if;
-----------------------
					elsif IR(9 downto 8) = "01" then -- BINARY
						if IR(7 downto 5) = "000" then -- add
							if IR(2) = '0' then 
								ACC <= ACC + SRC;
							else 
								LR <= LR +SRC;
								
							end if;
							
						elsif IR(7 downto 5) = "001" then -- subtract
							if IR(2) = '0' then
								ACC <= ACC - SRC;
								
							else 
								LR <= LR - SRC;
								
							end if;
							
						elsif IR(7 downto 5) = "010" then -- shift left
							if IR(2) = '0' then 
								ACC <= SRC(6 downto 0) & '0';
								
							else 
								LR <= SRC(6 downto 0) & '0';
								
							end if;
							
						elsif IR(7 downto 5) = "011" then -- shift right, maintain sign bit
							if IR(2) = '0' then 
								ACC <= SRC(7) & SRC(7 downto 1); 
								
							else 
								LR <= SRC(7) & SRC(7 downto 1); 
								
							end if;
						
						elsif IR(7 downto 5) = "100" then -- xor
							if IR(2) = '0' then
								ACC <= ACC xor SRC;
								
							else 
								LR <= LR xor SRC;
								
							end if;
						
						elsif IR(7 downto 5) = "101" then -- and
							if IR(2) = '0' then 
								ACC <= ACC and SRC;
								
							else 
								LR <= LR and SRC;
								
							end if;
								
						elsif IR(7 downto 5) = "110" then -- rotate left
							if IR(2) = '0' then 
								ACC <= SRC(6 downto 0) & SRC(7); 
								
							else 
								LR <= SRC(6 downto 0) & SRC(7);
								
							end if;
								
						elsif IR(7 downto 5) = "111" then -- rotate right 
							if IR(2) = '0' then 
								ACC <= SRC(0) & SRC(7 downto 1);
								
							else 
								LR <= SRC(0) & SRC(7 downto 1);
								
							end if;
					end if;
		  end if;
		  state <= sFetch;
		end case;
	end if;

end process;
	
	IRview <= IR(2 downto 0);
	lights <= std_logic_vector(LR);

end rtl;
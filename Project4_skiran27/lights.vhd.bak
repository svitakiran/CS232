-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lights is

	port(
		clk		 : in	std_logic;
		reset	 : in	std_logic;
		lightsig	 : out	std_logic_vector(7 downto 0);
		IRview : out std_logic_vector(2 downto 0)
	);

end entity lights;

architecture rtl of lights is

	component lightrom is
        port (
            addr : in std_logic_vector(3 downto 0);
            data : out std_logic_vector(2 downto 0)
        );
    end component;

	-- Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute);

	-- Register to hold the current state
	signal IR   : std_logic_vector (2 downto 0);
	signal PC : unsigned (3 downto 0);
	signal LR : unsigned (7 downto 0);
	signal ROMvalue : std_logic_vector (2 downto 0);
	signal state : state_type;

begin

	ROMinstance: lightrom
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
			state <= sFetch;
		elsif (rising_edge(clk)) then
			case state is
				when sFetch=>
					IR <= ROMvalue;
					PC <= PC + "0001";
					state <= sExecute;
					
				when sExecute=>
					if IR = "000" then
						LR <= "00000000";
					elsif IR = "001" then
						LR <= '0' & LR(7 downto 1);
					elsif IR = "010" then
						LR <= LR(6 downto 0) & '0';
					elsif IR = "011" then
						LR <= LR + 1;	
					elsif IR = "100" then
						LR <= LR - 1;
					elsif IR = "101" then
						LR <= not LR;
					elsif IR = "110" then
						LR <= LR(0) & LR(7 downto 1);
					elsif IR = "111" then
						LR <= LR(6 downto 0) & LR(7);
					end if;
					
					state <= sFetch;
			end case;
		end if;
	end process;
	
	IRview <= IR;
	lightsig <= std_logic_vector(LR);

end rtl;
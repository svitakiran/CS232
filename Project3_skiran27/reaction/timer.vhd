-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is

	port(
		clk		 : in	std_logic;
		reset	 : in	std_logic;
		start	 : in std_logic;
		react		: in std_logic;
		cycles	 : out	std_logic_vector(7 downto 0);
		leds		: out std_logic_vector(2 downto 0)
	);

end entity;

architecture rtl of timer is

	-- Build an enumerated type for the state machine
	type state_type is (sIdle, sWait, sCount);

	-- Register to hold the current state
	signal state   : state_type;
	
	signal count	: unsigned(7 downto 0);

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then
			state <= sIdle;
			count <= (others => '0');
		elsif (rising_edge(clk)) then
			case state is
				when sIdle=>
					if start = '1' then
						state <= sWait;
						count <= (others => '0');
					end if;
				when sWait=>
					if react = '1' then
						count <= (others => '1');
						state <= sIdle;
					else
						count <= count + 1;
						if count = "0100" then
							state <= sWait;
							count <= (others => '0');
						end if;
					end if;
				when sCount=>
					if react = '1' then
						state <= sIdle;
					else
						count <= count + 1;
					end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when sIdle =>
				output <= "00";
			when sWait =>
				output <= "01";
			when sCount =>
				output <= "10";
		end case;
	end process;

end rtl;

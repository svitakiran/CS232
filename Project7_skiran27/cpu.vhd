library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is 
		port (
    clk   : in  std_logic;                       -- main clock
    reset : in  std_logic;                       -- reset button

    PCview : out std_logic_vector( 7 downto 0);  -- debugging outputs
    IRview : out std_logic_vector(15 downto 0);
    RAview : out std_logic_vector(15 downto 0);
    RBview : out std_logic_vector(15 downto 0);
    RCview : out std_logic_vector(15 downto 0);
    RDview : out std_logic_vector(15 downto 0);
    REview : out std_logic_vector(15 downto 0);

    iport : in  std_logic_vector(7 downto 0);    -- input port
    oport : out std_logic_vector(15 downto 0));  -- output port
	 
end entity;

architecture rtl of cpu is

    component ProgramROM is 
        port (
            address : in std_logic_vector(7 downto 0);
            clock   : in std_logic := '1';
            q       : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component DataRAM is
        port (
            address : in std_logic_vector(7 downto 0);
            clock   : in std_logic := '1';
            data    : in std_logic_vector(15 downto 0);
            wren    : in std_logic;
            q       : out std_logic_vector(15 downto 0)
        );
    end component;
	 
	 component alu is 
		 port (
		 srcA : in  unsigned(15 downto 0);
		 srcB : in  unsigned(15 downto 0);
		 op   : in  std_logic_vector(2 downto 0);
		 cr   : out std_logic_vector(3 downto 0);
		 dest : out unsigned(15 downto 0)
		 );
	end component;

	type state_type is (start, fetch, execute_setup, execute_ALU, execute_memoryWait, execute_write, execute_returnPause1, execute_returnPause2, halt);
	signal state   : state_type;
	signal RA, RB, RC, RD, RE, SP, IR, MBR, dest : unsigned(15 downto 0);
	signal PC, MAR : unsigned(7 downto 0);
	signal outreg : std_LOGIC_VECTOR(15 downto 0);
	signal CR : std_LOGIC_VECTOR(3 downto 0);
	signal aluCR : std_LOGIC_VECTOR(3 downto 0);
	signal srcA, srcB : unsigned(15 downto 0);
	signal op : unsigned(2 downto 0);
	signal romOutput, ramOutput : std_LOGIC_VECTOR(15 downto 0);
	signal we : std_LOGIC;
	signal count : unsigned(2 downto 0);
	
begin

	romInstance : ProgramROM 
	port map(
		address => std_LOGIC_VECTOR(PC),
      clock => clk,
      q => romOutput
	);
	
	ramInstance : DataRAM
		port map(
			address => std_LOGIC_VECTOR(MAR),
			clock	=> clk,
			data	=> std_LOGIC_VECTOR(MBR),
			wren => we,
			q => ramOutput
		);
		
	aluInstance : alu
		port map (
		 srcA => srcA,
		 srcB => srcB,
		 op => std_LOGIC_VECTOR(op),
		 cr => aluCR,
		 unsigned(dest) => dest
		 );
	
	oport <= outreg;
	
	process (clk, reset)
	begin
		if reset = '0' then
			state <= start;
			PC <= (others => '0');
			IR <= (others => '0');
			outreg <= (others => '0');
			MAR <= (others => '0');
			MBR <= (others => '0');
			RA <= (others => '0');
			RB <= (others => '0');
			RC <= (others => '0');
			RD <= (others => '0');
			RE <= (others => '0');
			SP <= (others => '0');
			CR <= (others => '0');
			count <= (others => '0');
		elsif (rising_edge(clk)) then
			case state is
				when start=>
					if count = "111" then
						state <= fetch;
					else
						count <= count + 1;
					end if;
				when fetch=>
					IR <= unsigned(romOutput);
					PC <= PC + 1;
					state <= execute_setup;
				when execute_setup=>
					if IR(15 downto 10) = "001111" then 
						state <= halt;
					else 
						state <= execute_ALU;
					end if;
					op <= IR(14 downto 12);
					case IR(15 downto 12) is 
						when "0000" | "0001" =>
							if IR(11) = '1' then 
								MAR <= unsigned(IR(7 downto 0)) + unsigned(RE(7 downto 0));
							else 
								MAR <= unsigned(IR(7 downto 0));
							end if;
							
							case IR(10 downto 8) is 
								when "000" => 
									MBR <= RA;
								when "001" => 
									MBR <= RB;
								when "010" => 
									MBR <= RC;
								when "011" => 
									MBR <= RD;
								when "100" => 
									MBR <= RE;
								when "101" => 
									MBR <= SP;
								when others => 
							end case;
							
						when "0010" =>
							PC <= unsigned(IR(7 downto 0));
							
						when "0011" => 
							case IR(11 downto 10) is
								when "00" => 
									case IR(9 downto 8) is 
										when "00" => 
											PC <= unsigned(IR(7 downto 0));
										when "01" => 
											PC <= unsigned(IR(7 downto 0));
										when "10" =>
											PC <= unsigned(IR(7 downto 0));
										when "11" => 
											PC <= unsigned(IR(7 downto 0));
										when others =>
									end case;
									
								when "01" =>
									PC <= unsigned(IR(7 downto 0));
									MAR <= unsigned(SP(7 downto 0));
									MBR <= "0000" & unsigned(CR) & PC;
									SP <= SP + 1;
								
								when "10" =>
									MAR <= SP(7 downto 0) - 1;
									SP <= SP - 1;
								when others =>
									null;
							end case; 
							
						when "0100" | "0101" =>
							if IR(12) = '1' then
								MAR <= SP(7 downto 0) - 1;
								SP <= SP - 1;
							
							else 
								MAR <= SP(7 downto 0);
								SP <= SP + 1;
							
							case IR(11 downto 9) is 
								when "000" => 
									MBR <= RA;
								when "001" =>
									MBR <= RB;
								when "010" => 
									MBR <= RC;
								when "011" => 
									MBR <= RD; 
								when "100" => 
									MBR <= RE; 
								when "101" => 
									MBR <= SP;
								when "110" =>
									MBR <= "00000000" & PC;
								when others =>
									MBR <= unsigned("000000000000" & CR);
							end case;
						end if;
						
						when "0110" | "0111" =>
							null;
									
						when "1000" | "1001" | "1010" | "1011" | "1100" =>
							case IR(11 downto 9) is 
								when "000" => 
									srcA <= RA;
								when "001" => 
									srcA <= RB; 
								when "010" => 
									srcA <= RC;
								when "011" => 
									srcA <= RD;
								when "100" => 
									srcA <= RE;
								when "101" => 
									srcA <= SP; 
								when "110" => 
									srcA <= "0000000000000000";
								when "111" =>
									srcA <= "1111111111111111";
								when others => 
									null;
								end case;
								
							case IR(8 downto 6) is 
									when "000" => 
										srcB <= RA;
									when "001" => 
										srcB <= RB; 
									when "010" => 
										srcB <= RC;
									when "011" => 
										srcB <= RD;
									when "100" => 
										srcB <= RE;
									when "101" => 
										srcB <= SP; 
									when "110" => 
										srcB <= "0000000000000000";
									when "111" =>
										srcB <= "1111111111111111";
									when others => 
										null;
									end case;
						when "1101" | "1110" => 
							case IR(10 downto 8) is 
								when "000" => 
									srcA <= RA;
								when "001" => 
									srcA <= RB; 
								when "010" => 
									srcA <= RC;
								when "011" => 
									srcA <= RD;
								when "100" => 
									srcA <= RE;
								when "101" => 
									srcA <= SP; 
								when "110" => 
									srcA <= "0000000000000000";
								when "111" =>
									srcA <= "1111111111111111";
								when others => 
									null;
								end case;
							
							if IR(11) = '1' then 
								srcB <= "0000000000000001";						
							else 
								srcB <= "0000000000000000";						
							end if; 
							
						when "1111" =>
							if IR(11) = '1' then 
								srcA <= IR(10) & IR(10) & IR(10) & IR(10) & IR(10) & IR(10) & IR(10) & IR(10) & IR(10 downto 3);
							else 
								case IR(10 downto 8) is 
									when "000" => 
										srcA <= RA;
									when "001" => 
										srcA <= RB;
									when "010" => 
										srcA <= RC;
									when "011" => 
										srcA <= RD;
									when "100" => 
										srcA <= RE;
									when "101" => 
										srcA <= SP;
									when "110" => 
										srcA <= unsigned("00000000" & std_LOGIC_VECTOR(PC));
									when "111" => 
										srcA <= IR;
									when others => 
										null; 
								end case; 
							end if;
							
						when others => 
							null; 					
					end case;
								
				when execute_ALU=>
					if IR(15 downto 12) = "0001" or IR(15 downto 12) = "0100" or IR(15 downto 10) = "001101" then
						we <= '1'; 
					else 
						we <= '0';
					end if;			
					
					if IR(15 downto 12) = "0001" or IR(15 downto 12) = "0100" or IR(15 downto 12) = "0101" or IR(15 downto 10) = "001101" or IR(15 downto 12) = "0000" or IR(15 downto 10) = "010010" then
						state <= execute_memoryWait;
					else	
						state <= execute_write;
					end if; 
					
				when execute_memoryWait=>
					state <= execute_write;
					
				when execute_write=>
					we <= '0';
					
					case IR(15 downto 12) is 
						when "0000" => 
							case IR(10 downto 8) is 
								when "000" =>
									RA <= unsigned(ramOutput);
								when "001" => 
									RB <= unsigned(ramOutput);
								when "010" => 
									RC <= unsigned(ramOutput);
								when "011" => 
									RD <= unsigned(ramOutput);
								when "100" => 
									RE <= unsigned(ramOutput);
								when "101" => 
									SP <= unsigned(ramOutput); 
								when others => 
									null;
							end case;	
									
						when "0011" => 
							case IR(11 downto 10) is 
								when "10" => 
									CR <= ramOutput(11 downto 8);
									PC <= unsigned(ramOutput(7 downto 0));
								when others => 
									null; 
							end case; 
						 
						when "0101" =>
							case IR(11 downto 9) is 
								when "000" =>
									RA <= unsigned(ramOutput);
								when "001" => 
									RB <= unsigned(ramOutput);
								when "010" => 
									RC <= unsigned(ramOutput);
								when "011" => 
									RD <= unsigned(ramOutput);
								when "100" => 
									RE <= unsigned(ramOutput); 
								when "101" => 
									SP <= unsigned(ramOutput); 
								when "110" => 
									PC <= unsigned(ramOutput(7 downto 0));
								when "111" => 
									CR <= ramOutput(3 downto 0);
								when others => 
									null; 
							end case; 
								
						when "0110" => 
							case IR(11 downto 9) is 
								when "000" =>
									outreg <= std_LOGIC_VECTOR(RA);
								when "001" => 
									outreg <= std_LOGIC_VECTOR(RB);
								when "010" => 
									outreg <= std_LOGIC_VECTOR(RC);
								when "011" => 
									outreg <= std_LOGIC_VECTOR(RD);
								when "100" => 
									outreg <= std_LOGIC_VECTOR(RE); 
								when "101" => 
									outreg <= std_LOGIC_VECTOR(SP); 
								when "110" => 
									outreg <= "00000000" & std_LOGIC_VECTOR(PC); 
								when others => 
									outreg <= std_LOGIC_VECTOR(IR);
							end case; 
							
					 when "0111" => 
						case IR(11 downto 9) is 
							when "000" =>
									RA <= "00000000" & unsigned(iport);
								when "001" => 
									RB <= "00000000" & unsigned(iport);
								when "010" => 
									RC <= "00000000" & unsigned(iport);
								when "011" => 
									RD <= "00000000" & unsigned(iport);
								when "100" => 
									RE <= "00000000" & unsigned(iport); 
								when "101" => 
									SP <= "00000000" & unsigned(iport);
								when others => 
									null; 
									
							end case; 
							
					when "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111" => 
						case IR(2 downto 0) is 
							when "000" =>
									RA <= dest;
								when "001" => 
									RB <= dest;
								when "010" => 
									RC <= dest;
								when "011" => 
									RD <= dest;
								when "100" => 
									RE <= dest; 
								when "101" => 
									SP <= dest;
								when others => 
									null; 
							end case; 
							CR <= aluCR;
					when others => 
						null; 
					
					end case;
					
					if IR(15 downto 10) = "001110" then 
						state <= execute_returnPause1;					
					else 
						state <= fetch;					
					end if;
					
				when execute_returnPause1=>
					state <= execute_returnPause2;				
				when execute_returnPause2=>
					state <= fetch;				
				when halt => 
					state <= halt;				
				when others =>
					null;				
			end case;
		end if;
	end process;

end rtl;
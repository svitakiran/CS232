library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calctestbench is
end entity;

architecture test of calctestbench is
  constant num_cycles : integer := 45;
  signal clk : std_logic := '1';

  component calculator
    port(clock: in std_logic;
         data:  in std_logic_vector(7 downto 0);
         b0:    in std_logic; -- switch values to mbr
         b1:    in std_logic; -- push mbr -> stack
         b2:    in std_logic; -- pop stack -> mbr
         mbrview: out std_logic_vector(3 downto 0);
         stackview: out std_logic_vector(3 downto 0);
         stateview: out std_logic_vector(2 downto 0)
         );
			
  end component;

  signal mbrview : std_logic_vector(3 downto 0);
  signal stackview : std_logic_vector(3 downto 0);
  signal stateview : std_logic_vector(2 downto 0);

  signal b0, b1, b2 : std_logic;
  signal data: std_logic_vector(7 downto 0);

begin
  process
  begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  data <= "0000", "0001" after 50 ns, "0010" after 100 ns, "0011" after 150 ns, "0000" after 190 ns;
  b0 <= '1', '0' after 50 ns, '1' after 60 ns, '0' after 100 ns, '1' after 110 ns, '0' after 150 ns, '1' after 160 ns, '0' after 200 ns, '1' after 210 ns;
  b1 <= '0', '1' after 5 ns, '0' after 70 ns, '1' after 80 ns, '0' after 120 ns, '1' after 130 ns, '0' after 170 ns, '1' after 180 ns;
  b2 <= '0', '1' after 5 ns, '0' after 220 ns, '1' after 230 ns, '0' after 280 ns, '1' after 290 ns, '0' after 340 ns, '1' after 350 ns;
  L0: stacker port map(clk, data, b0, b1, b2, mbrview, stackview, stateview );

end test;
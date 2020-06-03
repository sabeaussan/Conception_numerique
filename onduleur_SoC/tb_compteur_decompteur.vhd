library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_compteur_decompteur is
	end tb_compteur_decompteur;
	
Architecture Arch_tb_compteur_decompteur of tb_compteur_decompteur is

component compteur_decompteur port(
	Fclk : in std_logic;
	clr : in std_logic;
	Q : out unsigned (15 downto 0);
	Tmod : in unsigned(15 downto 0);
	irq : out std_logic);
end component;



signal Fclk : std_logic;
signal clr : std_logic;
signal Q : unsigned (15 downto 0);
signal Tmod : unsigned(15 downto 0);
signal irq : std_logic;


begin
DUT: compteur_decompteur port map(Fclk=>Fclk,clr=>clr,Tmod=>Tmod,Q=>Q,irq=>irq);

horloge_process: process
begin
	Fclk <= '1';
	wait for 5 ns;
	Fclk <= '0';
	wait for 5 ns;
end process; 


user_input: process
begin
	Tmod <= to_unsigned(563,16);-- '0010110011100101';  --11493
	wait for 10 ms;
	Tmod <=  to_unsigned(1589,16); --'0100101000111000';  --19000
	wait for 10 ms;
	Tmod <= to_unsigned(3500,16);--'0000110110101100';  --3500
	wait for 10 ms;
end process; 

stimulus_process: process
begin
	clr <= '1';
	wait for 22 ns;
	clr <= '0';
	wait;
end process;

end Arch_tb_compteur_decompteur;
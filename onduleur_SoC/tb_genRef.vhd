library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_genRef is
	end tb_genRef;
	
Architecture Arch_tb_genRef of tb_genRef is

component genRef port(
	Fclk : in std_logic;
	duty_cycle : in unsigned (15 downto 0);
	demi_tps_mort : in unsigned (15 downto 0);
    ref_sup : out unsigned (15 downto 0);
    ref_inf : out unsigned (15 downto 0));
end component;



signal Fclk : std_logic;
signal duty_cycle : unsigned (15 downto 0);
signal demi_tps_mort : unsigned (15 downto 0);
signal ref_sup : unsigned(15 downto 0);
signal ref_inf : unsigned (15 downto 0);


begin
DUT: genRef port map(Fclk=>Fclk,duty_cycle=>duty_cycle,demi_tps_mort=>demi_tps_mort,ref_sup=>ref_sup,ref_inf=>ref_inf);

horloge_process: process
begin
	Fclk <= '1';
	wait for 20 ns;
	Fclk <= '0';
	wait for 20 ns;
end process; 


user_input: process
begin
	duty_cycle <= to_unsigned(521,16);
    demi_tps_mort <= to_unsigned(40,16);
    wait for 100 ns;
    duty_cycle <= to_unsigned(1400,16);
    demi_tps_mort <= to_unsigned(38,16);
    wait for 100 ns;
end process; 


end Arch_tb_genRef;
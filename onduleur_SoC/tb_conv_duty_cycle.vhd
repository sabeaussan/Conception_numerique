library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_conv_duty_cycle is
	end tb_conv_duty_cycle;
	
Architecture Arch_tb_conv_duty_cycle of tb_conv_duty_cycle is

component conv_duty_cycle port(
	periode : in unsigned (15 downto 0);
	duty_cycle_in : in unsigned (15 downto 0);
	duty_cycle_out : out unsigned (15 downto 0));
end component;



signal periode : unsigned (15 downto 0);
signal duty_cycle_in : unsigned (15 downto 0);
signal duty_cycle_out : unsigned(15 downto 0);


begin
DUT: conv_duty_cycle port map(periode=>periode,duty_cycle_in=>duty_cycle_in,duty_cycle_out=>duty_cycle_out);



user_input: process
begin
	periode <= to_unsigned(12045,16);
    duty_cycle_in <= to_unsigned(2654,16);
    wait for 100 ns;
    periode <= to_unsigned(16524,16);
    duty_cycle_in <= to_unsigned(5210,16);
    wait for 100 ns;
end process; 


end Arch_tb_conv_duty_cycle;
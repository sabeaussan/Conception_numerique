library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Convertit un rapport de cycle donné entre 0 et 65536 
-- en un rapport de cycle fonction de Tmod

Entity conv_duty_cycle is port(
    periode : in unsigned (15 downto 0);
	duty_cycle_in : in unsigned (15 downto 0);
	duty_cycle_out : out unsigned (15 downto 0));
end conv_duty_cycle;
	
architecture Arch_conv_duty_cycle of conv_duty_cycle is
        
        signal tmp : unsigned (31 downto 0);
        
		begin
            tmp <= (duty_cycle_in * periode)/65356;
            duty_cycle_out  <= resize(tmp,16);
        
        
end Arch_conv_duty_cycle;
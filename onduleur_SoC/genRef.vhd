library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- génère les références pour le comparateur

Entity genRef is port(
	--Fclk : in std_logic;
	duty_cycle : in unsigned (15 downto 0);
	demi_tps_mort : in unsigned (15 downto 0);
    ref_sup : out unsigned (15 downto 0);
    ref_inf : out unsigned (15 downto 0));

end genRef;
	
architecture Arch_genRef of genRef is


       signal ref1 : unsigned (15 downto 0);
		signal ref2 : unsigned (15 downto 0);
        
		begin 
		-- Process de génération de ref 
		--process (Fclk) begin
		--	if (Fclk' event and Fclk ='1') then
				ref1 <= duty_cycle + demi_tps_mort;
                ref2 <= duty_cycle - demi_tps_mort;
		--	end if;
		--end process;
		ref_sup <= ref1;
        ref_inf <= ref2;
        
end Arch_genRef;
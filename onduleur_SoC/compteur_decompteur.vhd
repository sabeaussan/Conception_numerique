library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity compteur_decompteur is port(
	Fclk : in std_logic;
	clr : in std_logic;						-- redémare le compteur
	MA : in std_logic;						-- stop/reprend le comptage
	Q : out unsigned (15 downto 0);
	Tmod : in unsigned(15 downto 0);
	irq : out std_logic						-- fin de cycle de comptage
	);
end compteur_decompteur;
	
architecture Arch_cpt_dct of compteur_decompteur is

		signal Q_int : unsigned (Q'range);
		signal count_down : std_logic;
        
		begin 
		
		-- Process de comptage/décomptage 
		process (clr,Fclk) begin
			if(clr='1') then
				-- on redémare le compteur
				Q_int <= (others =>'0');
			elsif (Fclk' event and Fclk ='1' and count_down='0' and MA = '0') then
				-- on compte 
				Q_int <= Q_int +1;
         elsif (Fclk' event and Fclk ='1' and count_down='1' and MA = '0') then
				-- on décompte 
				Q_int <= Q_int-1;
			elsif (Fclk' event and Fclk ='1' and MA = '1') then
				-- on stop le comptage
				Q_int <= Q_int;
			end if;
		end process;
		Q <= Q_int;
		
		
		-- Process de génération de signal
		process(clr,Fclk) begin
			if(clr='1') then
				count_down <= '0';
            irq <= '1';
			elsif (Fclk'event and Fclk='1') then
				irq <='0';
				if(Q_int=Tmod) then
					count_down <= '1';
				elsif(Q_int="0000000000000001" and count_down='1' ) then
					-- on arrive en fin de cycle
					-- on met le flag de fc à 1
					count_down <= '0';
					irq <='1';
				end if;
			end if;
		end process;
end Arch_cpt_dct;
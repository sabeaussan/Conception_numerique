library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity comparateur is port(
    cpt : in unsigned (15 downto 0);
	refSup : in unsigned (15 downto 0);
	refInf : in unsigned (15 downto 0);
    OutH : out std_logic;
    OutL : out std_logic
    );
end comparateur;
	
architecture Arch_comparateur of comparateur is
        
     begin
        process(cpt)       
            begin
            if(cpt < refInf) then 
                outH <= '1';
                outL <= '0';
            elsif(cpt > refSup) then 
                OutL <= '1';
                outH <= '0';
            elsif(cpt > refinf and cpt< refSup) then 
                outL <= '0';
                outH <= '0';
            end if;
        end process;
              
end Arch_comparateur;
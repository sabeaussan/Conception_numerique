library ieee;
use ieee.std_logic_1164.all;

entity lockRegister is port(
	clr :	in std_logic;
	clk :	in std_logic;
	update :	in std_logic;
	
	-- input
	W : in std_logic_vector(15 downto 0);
	V : in std_logic_vector(15 downto 0);
	U : in std_logic_vector(15 downto 0);
	DemiTM : in std_logic_vector(15 downto 0);
	T : in std_logic_vector(15 downto 0);
	etat : in std_logic_vector(15 downto 0);
	
	-- output
	Wup : out std_logic_vector(15 downto 0);
	Vup : out std_logic_vector(15 downto 0);
	Uup : out std_logic_vector(15 downto 0);
	DemiTMup : out std_logic_vector(15 downto 0);
	Tup : out std_logic_vector(15 downto 0);
	etatup : out std_logic_vector(15 downto 0)
	
	);
end lockRegister;


architecture archlockRegister of lockRegister is
	

	begin
		process (update, clr)
			begin
				if clr = '1' then								-- Reset
					Wup <= "0000000000000000";
					Vup <= "0000000000000000";
					Uup <= "0000000000000000";
					Tup <= "0000000000000000";
					DemiTMup <= "0000000000000000";
					etatup <= "0000000000000000";
				elsif (clk'event and clk= '1') then		-- mis à jour des sorties
					if(update='1') then
						Wup <= W;
						Vup <= V;
						Uup <= U;
						Tup <= T;
						DemiTMup <= DemiTM;
						etatup <= etat;
					end if;
				end if;
		end process;
end archlockRegister;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalonInterface is port(
	
	clk : in std_logic;
	rst : in std_logic;		-- remet les registres dans leur état initial 
	
	-- Avalon signal
	avs_address : in std_logic_vector(2 downto 0);
	avs_byteenable : in std_logic_vector(3 downto 0);
	avs_writedata : in std_logic_vector(31 downto 0);
	avs_readdata: out std_logic_vector(31 downto 0);
	avs_write : in std_logic;
	avs_read : in std_logic;
	
	-- Register
	W : out unsigned (15 downto 0);
	V : out unsigned (15 downto 0);
	U : out unsigned (15 downto 0);
	DemiTM : out unsigned (15 downto 0);
	T : out unsigned (15 downto 0);
	etat : out unsigned (15 downto 0);
	
	-- autre signaux
	clr : out std_logic; 		-- redémare compteurs/décompteurs
	MA : out std_logic;			-- arrête/reprend cycle de comptage et met les sorties à 0
	fc : in std_logic;			-- flag de fin de cycle 
	ins_fc : out std_logic 		-- interrupt sender fin de cycle
	
	);
end avalonInterface;


architecture archavalonInterface of avalonInterface is
	
	signal Treg : unsigned(15 downto 0) :="0000000000000000";				-- @001
	signal DemiTMreg : unsigned(15 downto 0) := "0000000000000000";		-- @010
	signal Wreg : unsigned(15 downto 0) := "0000000000000000";				-- @011
	signal Vreg : unsigned(15 downto 0) := "0000000000000000";				-- @100
	signal Ureg : unsigned(15 downto 0) := "0000000000000000";				-- @101
	signal etatreg : unsigned(15 downto 0) :="0000000000000111";			-- @110		interrupt_enable|Arret|clear actif

	
begin
	process (clk)
		variable frame : std_logic_vector (8 downto 0);		-- signal mis à jour avec un cycle de retard donc variable
		begin
			if(clk' event and clk ='1') then

				frame := avs_byteenable & avs_read & avs_write & avs_address;
				if(avs_read='0') then
					avs_readdata <= "00000000000000000000000000000000";
				end if;
				
				if(rst = '1') then
				-- on repart de l'état initial
					Treg <= "0000000000000000";
					DemiTMreg <= "0000000000000000";
					Wreg <= "0000000000000000";
					Vreg <= "0000000000000000";
					Ureg <= "0000000000000000";
					etatreg <= "0000000000000111";
				end if;
					
				--Process la trame du bus avalon
				case (frame) is
			
					-- Ecriture de registre 
					when "001101001" =>		
						Treg <= 	unsigned(avs_writedata(15 downto 0));
					when "001101010" =>
						DemiTMreg <= unsigned(avs_writedata(15 downto 0));
					when "001101011" =>		
						Wreg <= 	unsigned(avs_writedata(15 downto 0));
					when "001101100" =>
						Vreg <= unsigned(avs_writedata(15 downto 0));
					when "001101101" =>		
						Ureg <= 	unsigned(avs_writedata(15 downto 0));
					when "001101110" =>
						etatreg <= unsigned(avs_writedata(15 downto 0));
					
					-- Lecture de registre
					when "001110001" =>
						avs_readdata <="0000000000000000" & std_logic_vector(Treg);
					when "001110010" =>
						avs_readdata <="0000000000000000" & std_logic_vector(DemiTMreg);
					when "001110011" =>
						avs_readdata <="0000000000000000" & std_logic_vector(Wreg);
					when "001110100" =>
						avs_readdata <="0000000000000000" & std_logic_vector(Vreg);
					when "001110101" =>
						avs_readdata <="0000000000000000" & std_logic_vector(Ureg);
					when "001110110" =>
						avs_readdata <="0000000000000000" & std_logic_vector(etatreg);
					when others =>
						-- on ne fait rien
				
				end case;
			end if;
	end process;
	
	-- MAJ des registres et bits
	W <= Wreg;
	V <= Vreg;
	U <= Ureg;
	DemiTM <= DemiTMreg;
	T <= Treg;
	ins_fc <= fc and etatreg(2);		-- si ien est 0 (interrupt disable) alors ins_fc est à 0
	etat <= etatreg;
	clr <= etatreg(0) or rst; -- on clr cpt si on reset depuis avalon ou depuis registre d'état
	MA <= etatreg(1);
	
end archavalonInterface;
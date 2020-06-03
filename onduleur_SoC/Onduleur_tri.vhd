-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"
-- CREATED		"Tue Jan 14 15:57:46 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Onduleur_tri IS 
	PORT
	(
		secu :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		rst :  IN  STD_LOGIC;
		avs_write :  IN  STD_LOGIC;
		avs_read :  IN  STD_LOGIC;
		avs_address :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		avs_byteenable :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		avs_writedata :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		WH :  OUT  STD_LOGIC;
		WL :  OUT  STD_LOGIC;
		VH :  OUT  STD_LOGIC;
		VL :  OUT  STD_LOGIC;
		UH :  OUT  STD_LOGIC;
		UL :  OUT  STD_LOGIC;
		ins_fc :  OUT  STD_LOGIC;
		read_dgb :  OUT  STD_LOGIC;
		write_dbg :  OUT  STD_LOGIC;
		address_dbg :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		avs_readdata :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		byteenable_dbg :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		DemiTM_dbg :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		etat_dbg :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		T_dbg :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		U_dbg :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		V_dbg :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		W_dbg :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		writedata_dbg :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END Onduleur_tri;

ARCHITECTURE bdf_type OF Onduleur_tri IS 

COMPONENT avaloninterface
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 avs_write : IN STD_LOGIC;
		 avs_read : IN STD_LOGIC;
		 fc : IN STD_LOGIC;
		 avs_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 avs_byteenable : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 avs_writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 clr : OUT STD_LOGIC;
		 MA : OUT STD_LOGIC;
		 ins_fc : OUT STD_LOGIC;
		 avs_readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 DemiTM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 etat : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 T : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 U : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 V : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 W : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT genref
	PORT(demi_tps_mort : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 duty_cycle : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ref_inf : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ref_sup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT lockregister
	PORT(clr : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 update : IN STD_LOGIC;
		 DemiTM : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 etat : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 T : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 U : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 V : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 W : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DemiTMup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 etatup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Tup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Uup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Vup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Wup : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT compteur_decompteur
	PORT(Fclk : IN STD_LOGIC;
		 clr : IN STD_LOGIC;
		 MA : IN STD_LOGIC;
		 Tmod : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 irq : OUT STD_LOGIC;
		 Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT conv_duty_cycle
	PORT(duty_cycle_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 periode : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 duty_cycle_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT comparateur
	PORT(cpt : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 refInf : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 refSup : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 OutH : OUT STD_LOGIC;
		 OutL : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_53 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_54 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_55 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_56 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_57 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_58 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_42 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_44 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_46 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_48 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_50 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_52 :  STD_LOGIC;


BEGIN 
read_dgb <= avs_read;
write_dbg <= avs_write;
address_dbg <= avs_address;
byteenable_dbg <= avs_byteenable;
writedata_dbg <= avs_writedata;
DemiTM_dbg <= SYNTHESIZED_WIRE_5;
etat_dbg <= SYNTHESIZED_WIRE_6;
T_dbg <= SYNTHESIZED_WIRE_7;
U_dbg <= SYNTHESIZED_WIRE_8;
V_dbg <= SYNTHESIZED_WIRE_9;
W_dbg <= SYNTHESIZED_WIRE_10;



b2v_inst : avaloninterface
PORT MAP(clk => clk,
		 rst => rst,
		 avs_write => avs_write,
		 avs_read => avs_read,
		 fc => SYNTHESIZED_WIRE_53,
		 avs_address => avs_address,
		 avs_byteenable => avs_byteenable,
		 avs_writedata => avs_writedata,
		 clr => SYNTHESIZED_WIRE_55,
		 MA => SYNTHESIZED_WIRE_56,
		 ins_fc => ins_fc,
		 avs_readdata => avs_readdata,
		 DemiTM => SYNTHESIZED_WIRE_5,
		 etat => SYNTHESIZED_WIRE_6,
		 T => SYNTHESIZED_WIRE_7,
		 U => SYNTHESIZED_WIRE_8,
		 V => SYNTHESIZED_WIRE_9,
		 W => SYNTHESIZED_WIRE_10);


b2v_inst1 : genref
PORT MAP(demi_tps_mort => SYNTHESIZED_WIRE_54,
		 duty_cycle => SYNTHESIZED_WIRE_2,
		 ref_inf => SYNTHESIZED_WIRE_33,
		 ref_sup => SYNTHESIZED_WIRE_34);


b2v_inst11 : lockregister
PORT MAP(clr => SYNTHESIZED_WIRE_55,
		 clk => clk,
		 update => SYNTHESIZED_WIRE_53,
		 DemiTM => SYNTHESIZED_WIRE_5,
		 etat => SYNTHESIZED_WIRE_6,
		 T => SYNTHESIZED_WIRE_7,
		 U => SYNTHESIZED_WIRE_8,
		 V => SYNTHESIZED_WIRE_9,
		 W => SYNTHESIZED_WIRE_10,
		 DemiTMup => SYNTHESIZED_WIRE_54,
		 Tup => SYNTHESIZED_WIRE_57,
		 Uup => SYNTHESIZED_WIRE_18,
		 Vup => SYNTHESIZED_WIRE_20,
		 Wup => SYNTHESIZED_WIRE_15);


b2v_inst16 : compteur_decompteur
PORT MAP(Fclk => clk,
		 clr => SYNTHESIZED_WIRE_55,
		 MA => SYNTHESIZED_WIRE_56,
		 Tmod => SYNTHESIZED_WIRE_57,
		 irq => SYNTHESIZED_WIRE_53,
		 Q => SYNTHESIZED_WIRE_32);


SYNTHESIZED_WIRE_58 <= secu AND SYNTHESIZED_WIRE_14;


b2v_inst2 : conv_duty_cycle
PORT MAP(duty_cycle_in => SYNTHESIZED_WIRE_15,
		 periode => SYNTHESIZED_WIRE_57,
		 duty_cycle_out => SYNTHESIZED_WIRE_2);


SYNTHESIZED_WIRE_14 <= NOT(SYNTHESIZED_WIRE_56);



b2v_inst23 : conv_duty_cycle
PORT MAP(duty_cycle_in => SYNTHESIZED_WIRE_18,
		 periode => SYNTHESIZED_WIRE_57,
		 duty_cycle_out => SYNTHESIZED_WIRE_25);


b2v_inst24 : conv_duty_cycle
PORT MAP(duty_cycle_in => SYNTHESIZED_WIRE_20,
		 periode => SYNTHESIZED_WIRE_57,
		 duty_cycle_out => SYNTHESIZED_WIRE_23);


b2v_inst26 : genref
PORT MAP(demi_tps_mort => SYNTHESIZED_WIRE_54,
		 duty_cycle => SYNTHESIZED_WIRE_23,
		 ref_inf => SYNTHESIZED_WIRE_27,
		 ref_sup => SYNTHESIZED_WIRE_28);


b2v_inst27 : genref
PORT MAP(demi_tps_mort => SYNTHESIZED_WIRE_54,
		 duty_cycle => SYNTHESIZED_WIRE_25,
		 ref_inf => SYNTHESIZED_WIRE_30,
		 ref_sup => SYNTHESIZED_WIRE_31);


b2v_inst28 : comparateur
PORT MAP(cpt => SYNTHESIZED_WIRE_26,
		 refInf => SYNTHESIZED_WIRE_27,
		 refSup => SYNTHESIZED_WIRE_28,
		 OutH => SYNTHESIZED_WIRE_48,
		 OutL => SYNTHESIZED_WIRE_44);


b2v_inst29 : comparateur
PORT MAP(cpt => SYNTHESIZED_WIRE_29,
		 refInf => SYNTHESIZED_WIRE_30,
		 refSup => SYNTHESIZED_WIRE_31,
		 OutH => SYNTHESIZED_WIRE_50,
		 OutL => SYNTHESIZED_WIRE_52);


b2v_inst3 : comparateur
PORT MAP(cpt => SYNTHESIZED_WIRE_32,
		 refInf => SYNTHESIZED_WIRE_33,
		 refSup => SYNTHESIZED_WIRE_34,
		 OutH => SYNTHESIZED_WIRE_42,
		 OutL => SYNTHESIZED_WIRE_46);


b2v_inst31 : compteur_decompteur
PORT MAP(Fclk => clk,
		 clr => SYNTHESIZED_WIRE_55,
		 MA => SYNTHESIZED_WIRE_56,
		 Tmod => SYNTHESIZED_WIRE_57,
		 Q => SYNTHESIZED_WIRE_29);


b2v_inst32 : compteur_decompteur
PORT MAP(Fclk => clk,
		 clr => SYNTHESIZED_WIRE_55,
		 MA => SYNTHESIZED_WIRE_56,
		 Tmod => SYNTHESIZED_WIRE_57,
		 Q => SYNTHESIZED_WIRE_26);


WH <= SYNTHESIZED_WIRE_58 AND SYNTHESIZED_WIRE_42;


VL <= SYNTHESIZED_WIRE_58 AND SYNTHESIZED_WIRE_44;


WL <= SYNTHESIZED_WIRE_58 AND SYNTHESIZED_WIRE_46;


VH <= SYNTHESIZED_WIRE_58 AND SYNTHESIZED_WIRE_48;


UH <= SYNTHESIZED_WIRE_58 AND SYNTHESIZED_WIRE_50;


UL <= SYNTHESIZED_WIRE_58 AND SYNTHESIZED_WIRE_52;


END bdf_type;
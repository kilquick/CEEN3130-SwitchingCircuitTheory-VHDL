-- Tyler Zoucha
-- CEEN 3130-001
-- Four Bit Adder/Subtractor
-- Due: 02/14/2016

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY XORGate IS
	PORT (X, Y				: IN STD_LOGIC;
		  F					: OUT STD_LOGIC);
END XORGate;

ARCHITECTURE func OF XORGate IS
BEGIN
	F <= X XOR Y;
END func;
--------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.adder_package.all;

ENTITY AdderSubtractor IS
	PORT (A, B						: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  Ci0, Ci1, Ci2, Ci3		: IN STD_LOGIC;
		  SUB						: IN STD_LOGIC;
		  S							: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  Co3, Co2, Co1, Co0		: OUT STD_LOGIC);
END AdderSubtractor;

ARCHITECTURE Structure OF AdderSubtractor IS
COMPONENT XORGate IS
	port (X, Y						: IN STD_LOGIC;
		  F							: OUT STD_LOGIC);
END COMPONENT;

COMPONENT adder IS
	port (A, B, Cin					: IN STD_LOGIC;
		  S, Cout					: OUT STD_LOGIC);
END COMPONENT;
SIGNAL XOR_F						: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL C							: STD_LOGIC_VECTOR (3 DOWNTO 0);
BEGIN
	gate0: XORGate PORT MAP (B(0), SUB, XOR_F(0));
	gate1: XORGate PORT MAP (B(1), SUB, XOR_F(1));
	gate2: XORGate PORT MAP (B(2), SUB, XOR_F(2));
	gate3: XORGate PORT MAP (B(3), SUB, XOR_F(3));
	
	stage0: adder PORT MAP (A(0), XOR_F(0), SUB, S(0), C(0));
	stage1: adder PORT MAP (A(1), XOR_F(1), C(0), S(1), C(1));
	stage2: adder PORT MAP (A(2), XOR_F(2), C(1), S(2), C(2));
	stage3: adder PORT MAP (A(3), XOR_F(3), C(2), S(3), C(3));
	
	Co0 <= C(0);
	Co1 <= C(1);
	Co2 <= C(2);
	Co3 <= C(3);
END Structure;
--End Fout Bit Adder/Subtractor
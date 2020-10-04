-- Tyler Zoucha & Ethan Ashley
-- CEEN 3130-001
-- Lab 5
-- Due: 02/22/2016

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--FlipFlop
ENTITY flipflop IS
	PORT ( D, Clk : IN STD_LOGIC;
		   Q 	  : OUT STD_LOGIC);
END flipflop;

ARCHITECTURE Behavior OF flipflop IS
BEGIN
	PROCESS ( D, Clk )
	BEGIN
		IF Clk'EVENT AND Clk = '1' THEN
			Q <= D;
		END IF;
	END PROCESS;
END Behavior;
--End FlipFlip

---------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--XORGate
ENTITY XORGate IS
	PORT (X, Y				: IN STD_LOGIC;
		  F					: OUT STD_LOGIC);
END XORGate;

ARCHITECTURE func OF XORGate IS
BEGIN
	F <= X XOR Y;
END func;
--END XORGate

--------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.adder_package.all;

--Four Bit Adder with Flipflop and XOR gayes
ENTITY AdderSubtractor IS
	PORT (B3, B2, B1, B0			: IN STD_LOGIC;
		  Ci0, Ci1, Ci2, Ci3		: IN STD_LOGIC;
		  SUB, CLK					: IN STD_LOGIC;
		  S3, S2, S1, S0			: OUT STD_LOGIC;
		  Co3, Co2, Co1, Co0		: OUT STD_LOGIC);
	attribute loc: string;
	attribute loc of CLK: signal is "p1";
	attribute loc of B3: signal is "p2";
	attribute loc of B2: signal is "p3";
	attribute loc of B1: signal is "p4";
	attribute loc of B0: signal is "p5";
	attribute loc of Ci3: signal is "p7";
	attribute loc of Ci2: signal is "p8";
	attribute loc of Ci1: signal is "p9";
	attribute loc of Ci0: signal is "p10";
	attribute loc of SUB: signal is "p11";
	attribute loc of Co0: signal is "p16";
	attribute loc of Co1: signal is "p17";
	attribute loc of Co2: signal is "p18";
	attribute loc of Co3: signal is "p19";
	attribute loc of S0: signal is "p20";
	attribute loc of S1: signal is "p21";
	attribute loc of S2: signal is "p22";
	attribute loc of S3: signal is "p23";
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

COMPONENT flipflop IS
	PORT (D, Clk	: IN STD_LOGIC;
		  Q			: OUT STD_LOGIC);
END COMPONENT;

SIGNAL XOR0, XOR1, XOR2, XOR3, Dff0, Dff1, Dff2, Dff3		: STD_LOGIC;
SIGNAL tmp0, tmp1, tmp2, tmp3								: STD_LOGIC;
BEGIN
	gate0: XORGate PORT MAP (B0, SUB, XOR0);
	gate1: XORGate PORT MAP (B1, SUB, XOR1);
	gate2: XORGate PORT MAP (B2, SUB, XOR2);
	gate3: XORGate PORT MAP (B3, SUB, XOR3);
	
	stage0: adder PORT MAP (Dff0, XOR0, Ci0, tmp0, Co0);
	stage1: adder PORT MAP (Dff1, XOR1, Ci1, tmp1, Co1);
	stage2: adder PORT MAP (Dff2, XOR2, Ci2, tmp2, Co2);
	stage3: adder PORT MAP (Dff3, XOR3, Ci3, tmp3, Co3);
		
	ff0:	flipflop PORT MAP (tmp0, CLK, Dff0);
	ff1:	flipflop PORT MAP (tmp1, CLK, Dff1);
	ff2:	flipflop PORT MAP (tmp2, CLK, Dff2);
	ff3:	flipflop PORT MAP (tmp3, CLK, Dff3);
	
	S0 <= Dff0;
	S1 <= Dff1;
	S2 <= Dff2;
	S3 <= Dff3;
END Structure;
--End Four Bit Adder/Subtractor
-- Tyler Zoucha
-- February 29, 2016
-- Moore State Machine

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY flipflop IS 
	PORT (Dy1, Dy2, CLK, RESETn	: IN STD_LOGIC;
		  Q1, Q2				: OUT STD_LOGIC);
END flipflop;

ARCHITECTURE Behavior OF flipflop IS
SIGNAL D1, D2, Y2, Y1, X		: STD_LOGIC;
BEGIN
	D1 <= (X AND NOT Y2 AND NOT Y1) OR (X AND Y2 AND Y1);
	D2 <= (NOT X AND NOT Y2 AND Y1) OR (X AND Y2 AND Y1); 
	PROCESS (RESETn, Dy1, Dy2, CLK)
	BEGIN
		IF RESETn = '0' THEN
			Q1 <= '0';
			Q2 <= '0';
		ELSIF CLK'EVENT AND CLK = '1' THEN
			Y2 <= Dy2;
			Y1 <= Dy1;
		END IF;
	END PROCESS;
	
	Q2 <= Y2;
	Q1 <= Y1;
END Behavior;

---------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MooreState IS
	PORT (X, Clk			: IN STD_LOGIC;
		  RESET				: IN STD_LOGIC;
		  Y1, Y2, Z			: OUT STD_LOGIC);
END MooreState;

ARCHITECTURE Structure OF MooreState IS
COMPONENT flipflop IS
	PORT (Dy1, Dy2, CLK, RESETn	: IN STD_LOGIC;
		  Q1, Q2				: OUT STD_LOGIC);
END COMPONENT;

BEGIN
	ff0: flipflop PORT MAP (Dy1, Dy2, Clk, RESET, Q1, Q2);
	Z <= Y2 AND Y1;
END Structure;
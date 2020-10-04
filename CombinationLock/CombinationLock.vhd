LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CombinationLock IS
	PORT (	X2, X1	: IN STD_LOGIC;
			Z		: OUT STD_LOGIC);
	ATTRIBUTE loc : STRING;
	ATTRIBUTE loc of X1 : SIGNAL IS "P2";
	ATTRIBUTE loc of X2 : SIGNAL IS "P3";
	ATTRIBUTE loc of Z : SIGNAL IS "P17";
END CombinationLock;

ARCHITECTURE BEHAVIOR OF CombinationLock IS
	SIGNAL y2, y1, y0	: STD_LOGIC;
BEGIN
	Z <= y2;
	y2 <= '1' WHEN ((y2 = '0' AND y1 = '1' AND x2 = '1' AND x1 = '0') OR (y2 = '1' AND y1 = '1') OR (y0 = '1' AND x2 = '1' AND y2 = '1'))
			  ELSE '0';
	y1 <= '1' WHEN ((y2 = '1' AND y1 = '1' AND y0 = '0') OR (x2 = '1' AND y2 = '0' AND y1 = '1') OR (x1 = '1' AND y2 = '0' AND y0 = '1'))
			  ELSE '0';
	y0 <= '1' WHEN ((x2 = '0' AND x1 = '0') OR (y2 = '0' AND y0 = '1' AND x2 = '0') OR (y0 = '1' AND y2 = '1' AND x1 = '0'))
			  ELSE '0';
END;

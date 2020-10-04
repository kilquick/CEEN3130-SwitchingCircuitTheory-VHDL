-- Tyler Zoucha
-- CEEN 3130-001
-- Full Adder
-- Due: 02/14/2016

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY adder IS
	PORT (A, B, Cin		: IN STD_LOGIC;
		  S, Cout		: OUT STD_LOGIC);
END adder;

ARCHITECTURE LogicFunc of adder IS
BEGIN
	S <= A XOR B XOR Cin;
	Cout <= ((A XOR B) AND Cin) OR (A AND B);
END LogicFunc;
----------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE adder_package IS
	COMPONENT add_sub
		PORT (A, B, Cin	: IN STD_LOGIC;
			  S, Cout	: OUT STD_LOGIC);
	END COMPONENT;
END adder_package;
--End Full Adder
--Tyler Zoucha & Ethan Ashley
--Lab 8 Part A
--Moore State Machine that detects: 1-1-0-1 or 1-0-1-1

library ieee;
use ieee.std_logic_1164.all;

ENTITY Lab8 IS
	Port (x, clk, resetn			: IN STD_LOGIC;
		Z							: OUT STD_LOGIC;
		S2, S1, S0					: OUT STD_LOGIC);
END Lab8;

Architecture Behavior of Lab8 IS
	SIGNAL y_present, y_next		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL temp						: STD_LOGIC_VECTOR(2 DOWNTO 0);
	CONSTANT A	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	CONSTANT B	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT C	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
	CONSTANT D	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
	CONSTANT E	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
	CONSTANT F	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
	CONSTANT G	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
	CONSTANT H	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";
	ATTRIBUTE syn_state_machine : boolean;  							-- for Lattice so it
	ATTRIBUTE syn_state_machine of y_present : signal is false; 		-- doesn't use 1 hot

BEGIN
	Process (x, y_present)
	BEGIN
		CASE y_present IS
			WHEN A=>
				temp <= "000";
				IF x = '0' THEN
					y_next <= A;
				ELSE
					y_next <= B;
				END IF;
			WHEN B=>
				temp <= "001";
				IF x = '0' THEN
					y_next <= F;
				ELSE
					y_next <= C;
				END IF;
			WHEN C=>
				temp <= "011";
				IF x = '0' THEN
					y_next <= D;
				ELSE
					y_next <= C;
				END IF;
			WHEN D=>
				temp <= "010";
				IF x = '0' THEN
					y_next <= A;
				ELSE
					y_next <= E;
				END IF;
			WHEN E=>
				temp <= "100";
				IF x = '0' THEN
					y_next <= F;
				ELSE
					y_next <= C;
				END IF;
			WHEN F=>
				temp <= "101";
				IF x = '0' THEN
					y_next <= A;
				ELSE
					y_next <= G;
				END IF;
			WHEN G=>
				temp <= "111";
				IF x = '0' THEN
					y_next <= H;
				ELSE
					y_next <= C;
				END IF;
			WHEN H=>
				temp <= "101";
				IF x = '0' THEN
					y_next <= A;
				ELSE
					y_next <= G;
				END IF;
		END CASE;
	END PROCESS;

	Process (clk, resetn)
	BEGIN
		IF resetn = '0' THEN
			y_present <=  A;
		ELSIF (clk'EVENT AND clk = '1') THEN
			y_present <= y_next;
		END IF;
	END PROCESS;

	z <= '1' WHEN (y_present = E OR y_present = H) ELSE '0';
	S0 <= temp(0);
	S1 <= temp(1);
	S2 <= temp(2);
END Behavior;

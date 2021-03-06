--Tyler Zoucha
--CEEN 3130

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mealy110 IS
	PORT (Clock, Resetn, w	: IN STD_LOGIC;
			z				: OUT STD_LOGIC);
END Mealy110;

ARCHITECTURE Behavior OF Mealy110 IS
	SIGNAL y_present, y_next	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	CONSTANT A					: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	CONSTANT B					: STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
	CONSTANT C					: STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";
	BEGIN
		PROCESS (w, y_present)
		BEGIN
			CASE y_present IS
				WHEN A =>
					IF w ='0' THEN y_next <= A;
					ELSE y_next <= B;
					END IF;
				WHEN B => 
					IF w = '0' THEN y_next <= A;
					ELSE y_next <= C;
					END IF;
				WHEN C =>
					IF w = '0' THEN y_next <= A;
					ELSE y_next <= C;
					END IF;
				WHEN OTHERS =>
					IF w ='0' THEN y_next <= A;
					ELSE y_next <= B;
					END IF;
			END CASE;
		END PROCESS;
		
		PROCESS (y_present, w)
		BEGIN
			CASE y_present IS
				WHEN A =>
					z <= '0';
				WHEN B =>
					z <= '0';
				WHEN C =>
					z <= NOT w;
				WHEN OTHERS =>
					z <= '0';
			END CASE;
		END PROCESS;
	END Behavior;
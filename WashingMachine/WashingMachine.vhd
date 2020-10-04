--Tyler Zoucha
--CEEN 3130

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY COUNTER IS
	PORT ( CLK, LOAD, EN	: IN STD_LOGIC;
		   DATA				: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		   TCD				: OUT STD_LOGIC;
		   OUTPUT			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COUNTER;

ARCHITECTURE BEHAVIOR OF COUNTER IS
SIGNAL COUNTER				: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	TCD <= '1' WHEN COUNTER = "0000" ELSE '0';
	OUTPUT <= COUNTER;
	
	PROCESS(CLK, LOAD, EN)
	BEGIN
		IF (RISING_EDGE(CLK)) THEN
			IF LOAD = '0' AND EN = '0' THEN
			ELSIF LOAD = '1' AND EN = '1' THEN
				COUNTER <= DATA;
			ELSIF EN = '1' AND LOAD = '0' THEN
				COUNTER <= COUNTER - 1;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;

---------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MULTIPLEXER IS
	PORT ( SEL, LOAD		: IN STD_LOGIC;
		   OUTPUT			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END MULTIPLEXER;

ARCHITECTURE BEHAVIOR OF MULTIPLEXER IS
BEGIN
	PROCESS(SEL)
	BEGIN
		IF SEL = '1' THEN OUTPUT <= "1001";
		ELSE OUTPUT <= "0111";
		END IF;
	END PROCESS;
END BEHAVIOR;

---------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WashingMachine IS
	PORT ( CLK, RESETn, START, FULL		: IN STD_LOGIC;
		   TCD							: IN STD_LOGIC;
		   H, C, AGIT, SPIN, N7, LD, EC	: OUT STD_LOGIC);
END WashingMachine;

ARCHITECTURE Structure OF WashingMachine IS
TYPE State_type IS (S0, S1, S2, S3, S4);
SIGNAL y : State_type;
BEGIN
	PROCESS (CLK, RESETn, START, FULL, TCD)
	BEGIN
		IF RESETn = '0' THEN
			y <= S0;
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			CASE y IS
				WHEN S0 =>
					IF START = '0' THEN y <= S0;
					ELSE y <= S1;
					END IF;
				WHEN S1 =>
					IF FULL = '0' THEN y <= S1;
					ELSE y <= S2;
					END IF;
				WHEN S2 => 
					IF FULL = '0' THEN y <= S3;
					ELSIF TCD = '1' THEN y <= S4;
					ELSE y <= S2;
					END IF;
				WHEN S3 =>
					IF FULL = '0' THEN y <= S3;
					ELSE y <= S2;
					END IF;
				WHEN S4 =>
					IF TCD = '1' THEN y <= S0;
					ELSE y <= S4;
					END IF;
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS (y, FULL, TCD)
	BEGIN
		LD <= '0';
		EC <= '0';
		SPIN <= '0';
		H <= '0';
		C <= '0';
		AGIT <= '0';
		N7 <= '0';
		
		CASE y IS
			WHEN S1 =>
				H <= '1';
				C <= '1';
				IF FULL = '1' THEN
					EC <= '1';
					N7 <= '1';
					LD <= '1';
				END IF;
			WHEN S2 =>
				AGIT <= '1';
				EC <= '1';
				IF TCD = '1' THEN
					EC <= '1';
					LD <= '1';
				END IF;
			WHEN S3 =>
				H <= '1';
			WHEN S4 =>
				SPIN <= '1';
				EC <= '1';
			WHEN OTHERS =>
		END CASE;
	END PROCESS;
END Structure;
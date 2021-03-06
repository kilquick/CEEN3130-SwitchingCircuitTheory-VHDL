--Tyler Zoucha
--CEEN 3130
--Slow Multiplier

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SlowMultiplier IS
	PORT (RESET, S, MCANDn, MLTPn, CLK	: IN STD_LOGIC;
	      LDAn, LDBn, LDCn				: OUT STD_LOGIC;
	      ENAn, ENBn, ENCn				: OUT STD_LOGIC;
	      DONE							: OUT STD_LOGIC);
END SlowMultiplier;

ARCHITECTURE BEHAVIOR OF SlowMultiplier IS
TYPE STATE IS (S0, S1, S2, S3, S4);
SIGNAL Y : STATE;
BEGIN
	PROCESS (RESET, S, MCANDn, MLTPn, CLK, Y)
	BEGIN
		IF RESET = '1' THEN
			Y <= S0;
		ELSIF CLK'EVENT AND CLK = '1' THEN
			CASE Y IS
				WHEN S0 =>
					IF S = '1' THEN
						Y <= S1;
					ELSE
						Y <= S0;
					END IF;
				WHEN S1 =>
					IF MCANDn = '0' THEN
						Y <= S4;
					ELSIF MLTPn = '0' THEN
						y <= S4;
					ELSE 
						Y <= S2;
					END IF;
				WHEN S2 =>
					IF MCANDn = '0' THEN
						Y <= S3;
					ELSE
						Y <= S2;
					END IF;
				WHEN S3 =>
					IF MLTPn = '0' THEN
						Y <= S4;
					ELSE
						Y <= S2;
					END IF;
				WHEN S4 =>
					IF S = '0' THEN
						Y <= S0;
					ELSE
						Y <= S4;
					END IF;
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS (S, MCANDn, MLTPn, Y)
	BEGIN
		LDAn <= '1';
		LDBn <= '1';
		LDCn <= '1';
		ENAn <= '1';
		ENBn <= '1';
		ENCn <= '1';
		DONE <= '0';
		
		CASE Y IS
			WHEN S0 =>
				LDAn <= NOT S;
				LDBn <= NOT S;
				LDCn <= NOT S;
			WHEN S1 =>
			WHEN S2 =>
				ENAn <= NOT MCANDn;
				ENBn <= MCANDn;
				ENCn <= NOT MCANDn;
			WHEN S3 =>
				LDAn <= NOT MLTPn;
			WHEN S4 =>
				DONE <= '1';
		END CASE;
	END PROCESS;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY COUNTER4 IS
	PORT (LOADn, UP, ENn, CLK		: IN STD_LOGIC;
		  dIn						: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  TCDn						: OUT STD_LOGIC;
		  dOut						: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COUNTER4;

ARCHITECTURE BEHAVIOR OF COUNTER4 IS
SIGNAL TEMP : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	PROCESS (LOADn, TEMP, ENn, CLK, dIn)
	BEGIN
		IF LOADn = '0' THEN
			TEMP <= dIn;
		ELSIF CLK'EVENT AND CLK = '1' AND ENn = '0' THEN
			IF UP = '1' THEN
				TEMP <= TEMP + 1;
			ELSE
				TEMP <= TEMP - 1;
			END IF;
		END IF;
	END PROCESS;
		
	WITH TEMP SELECT
		TCDn <= '0' WHEN "0000",
				'1' WHEN OTHERS;
	
	dOut <= TEMP;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY COUNTER8 IS
	PORT (LOADn, UP, ENn, CLK		: IN STD_LOGIC;
		  dIn						: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  TCDn						: OUT STD_LOGIC;
		  dOut						: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COUNTER8;

ARCHITECTURE BEHAVIOR OF COUNTER8 IS
SIGNAL TEMP	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS (LOADn, TEMP, ENn, CLK, dIn)
	BEGIN
		IF LOADn = '0' THEN
			TEMP <= dIn;
		ELSIF CLK'EVENT AND CLK = '1' AND ENn = '0' THEN
			IF UP = '1' THEN
				TEMP <= TEMP + 1;
			ELSE
				TEMP <= TEMP - 1;
			END IF;
		END IF;
	END PROCESS;
		
	WITH TEMP SELECT
		TCDn <= '0' WHEN "00000000",
				'1' WHEN OTHERS;
	
	dOut <= TEMP;
END BEHAVIOR;
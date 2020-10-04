--Tyler Zoucha
--CEEN 3130
--Portfolio Project 1 - Laser Tag
--April 27, 2016

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY LaserTag IS
	PORT (RESETn, New_Game, Hit_A, Hit_B, Strike, CLK		: IN STD_LOGIC;
		  CompA_EQn, CompA_LTn, CompB_GTn, CTR_TCDn			: IN STD_LOGIC;
		  SUB, StorReg_EN, StorReg_CLRn						: OUT STD_LOGIC;
		  CTR_LDn, CTR_ENn, CTR_UP, CODd0, CODd1			: OUT STD_LOGIC;
		  Done_A, Done_B, Done_S, Game_Over					: OUT STD_LOGIC);		  
END LaserTag;

ARCHITECTURE BEHAVIOR OF LaserTag IS
TYPE STATE IS (S0, S1, S2, S3, S4, S5, S6);
SIGNAL Y : STATE;
BEGIN
	PROCESS (RESETn, CLK, CTR_TCDn, CompA_EQn, CompA_LTn, CompB_GTn, New_Game, Hit_A, Hit_B, Strike)
	BEGIN
		IF RESETn = '0' THEN
			Y <= S0;
		ELSIF CLK'EVENT AND CLK = '1' THEN
			CASE Y IS
				WHEN S0 =>
					Y <= S1;
				WHEN S1 =>
					IF CTR_TCDn = '0' THEN
						Y <= S2;
					ELSIF CompA_EQn = '0' OR CompA_LTn = '0' THEN
						Y <= S6;
					ELSIF Hit_A = '1' THEN
						Y <= S3;
					ELSIF Hit_B = '1' THEN
						Y <= S4;
					ELSIF Strike = '1' THEN
						Y <= S5;
					END IF;
				WHEN S2 =>
					IF CompB_GTn = '0' THEN
						Y <= S1;
					ELSE
						Y <= S6;
					END IF;
				WHEN S3 =>
					IF Hit_A = '1' THEN
						Y <= S3;
					ELSE
						Y <= S1;
					END IF;
				WHEN S4 =>
					IF Hit_B = '1' THEN
						Y <= S4;
					ELSE
						Y <= S1;
					END IF;
				WHEN S5 =>
					IF Strike = '1' THEN
						Y <= S5;
					ELSE
						Y <= S1;
					END IF;
				WHEN S6 =>
					IF New_Game = '1' THEN
						Y <= S0;
					ELSE
						Y <= S6;
					END IF;
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS (New_Game, CTR_TCDn, CompB_GTn, CompA_EQn, CompA_LTn, Hit_A, Hit_B, Strike)
	BEGIN
		SUB <= '0';
		StorReg_EN <= '0';
		StorReg_CLRn <= '1';
		CTR_LDn <= '1';
		CTR_ENn <= '1';
		CTR_UP <= '0';
		CODd0 <= '0';
		CODd1 <= '0';
		Done_A <= '0';
		Done_B <= '0';
		Done_S <= '0';
		Game_Over <= '0';
		
		CASE Y IS
			WHEN S0 =>
				IF RESETn = '0' THEN
					StorReg_CLRn <= '0';
				ELSE
					StorReg_EN <= '1';
					CTR_LDn <= '0';
				END IF;
			When S1 =>
				IF Hit_A = '1' THEN
					SUB <= '1';
					CODd0 <= '1';
				ELSIF Hit_B = '1' THEN
					SUB <= '1';
					CODd0 <= '1';
					CODd1 <= '1';
				ELSIF Strike = '1' THEN
					CODd1 <= '1';
				ELSIF CTR_TCDn = '0' THEN
					--NOTHING
				ELSIF CompA_EQn = '0' OR CompA_LTn = '0' THEN
					--NOTHING
				ELSE
					CTR_ENn <= '0';
				END IF;
			WHEN S2 =>
				IF CompB_GTn = '0' THEN
					CTR_LDn <= '0';
				END IF;
			WHEN S3 =>
				Done_A <= '1';
				SUB <= '1';
				CODd0 <= '1';
				IF Hit_A = '0' THEN
					StorReg_EN <= '1';
				END IF;
			WHEN S4 =>
				Done_B <= '1';
				SUB <= '1';
				CODd0 <= '1';
				CODd1 <= '1';
				IF Hit_B = '0' THEN
					StorReg_EN <= '1';
				END IF;
			When S5 =>
				Done_S <= '1';
				CODd1 <= '1';
				IF Strike = '0' THEN
					StorReg_EN <= '1';
				END IF;
			WHEN S6 =>
				Game_Over <= '1';
				IF New_Game = '1' THEN
					StorReg_CLRn <= '0';
				END IF;
		END CASE;
	END PROCESS;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY COUNTER5 IS
	PORT (LOADn, UP, ENn, CLK		: IN STD_LOGIC;
		  dIn						: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		  TCDn						: OUT STD_LOGIC;
		  dOut						: OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END COUNTER5;

ARCHITECTURE BEHAVIOR OF COUNTER5 IS
SIGNAL TEMP : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
	PROCESS (LOADn, TEMP, ENn, CLK, dIn)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF ENn = '0' THEN
				IF UP = '1' THEN
					TEMP <= TEMP + 1;
				ELSE
					TEMP <= TEMP - 1;
				END IF;
			ELSIF LOADn = '0' THEN
				TEMP <= dIn;
			END IF;
		END IF;
	END PROCESS;
		
	WITH TEMP SELECT
		TCDn <= '0' WHEN "00000",
				'1' WHEN OTHERS;
	
	dOut <= TEMP;
END BEHAVIOR;

-----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY STOR_REG IS
	PORT (CLK, CLRn, LOAD			: IN STD_LOGIC;
		  Din						: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  Dout						: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END STOR_REG;

ARCHITECTURE BEHAVIOR OF STOR_REG IS
BEGIN
	PROCESS (CLRn, CLK)
	BEGIN
		IF (CLK'EVENT AND CLK = '1') THEN
			IF CLRn = '0' THEN
				Dout <= "0000";
			ELSIF LOAD = '1' THEN
				Dout <= Din;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;

--------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ADD_SUB IS
	PORT (DATA, PREVDATA		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  SUB 					: IN STD_LOGIC;
		  TOTAL					: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END ADD_SUB;

ARCHITECTURE BEHAVIOR OF ADD_SUB IS
BEGIN
	PROCESS (DATA, PREVDATA, SUB)
	BEGIN
		IF SUB = '0' THEN
			TOTAL <= DATA + PREVDATA;
		ELSE
			TOTAL <= PREVDATA - DATA;
		END IF;
	END PROCESS;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DECODER IS
	PORT (dI0, dI1					: IN STD_LOGIC;
		  dOut						: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END DECODER;

ARCHITECTURE BEHAVIOR OF DECODER IS
SIGNAL dIn							: STD_LOGIC_VECTOR (1 DOWNTO 0);
BEGIN
	dIn(0) <= dI0;
	dIn(1) <= dI1;
	
	WITH dIn SELECT
		dOut <= "0101" WHEN "00",
			    "0001" WHEN "01",
				"0011" WHEN "11",
				"0010" WHEN "10",
				"0000" WHEN OTHERS;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY COMPAR IS
	PORT (dIn, dComp				: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  EQn, LTn, GTn				: OUT STD_LOGIC);
END COMPAR;

ARCHITECTURE BEHAVIOR OF COMPAR IS
BEGIN
	PROCESS (dIn, dComp)
	BEGIN
		IF dIn = dComp THEN
			EQn <= '0';
			LTn <= '1';
			GTn <= '1';
		ELSIF dIn > dComp THEN
			EQn <= '1';
			LTn <= '1';
			GTn <= '0';
		ELSIF dIn < dComp THEN
			EQn <= '1';
			LTn <= '0';
			GTn <= '1';
		END IF;
	END PROCESS;
END BEHAVIOR;
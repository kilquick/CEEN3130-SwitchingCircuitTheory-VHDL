--Tyler Zoucha
--CEEN 3130
--Portfolio Project Two - Power Computer
--May 4, 2016

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PowerComputer IS
	PORT(RESETn, CLK, S, VB_EQn, SV_LTn, VB_LSB		: IN STD_LOGIC;
		 StorReg_CLRn, StorReg_EN, SUB				: OUT STD_LOGIC;
		 V_DONE, DONE, CTR_ENn, CTR_CLRn			: OUT STD_LOGIC;
		 VA_EN, VA_LD, VB_EN, VB_LD					: OUT STD_LOGIC);
END PowerComputer;

ARCHITECTURE BEHAVIOR OF PowerComputer IS
TYPE STATE IS (S0, S1, S2, S3, S4);
SIGNAL Y : STATE;
BEGIN
	PROCESS (RESETn, CLK, S, VB_EQn, SV_LTn)
	BEGIN
		IF RESETn = '0' THEN
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
					IF VB_EQn = '0' THEN
						Y <= S2;
					ELSE
						Y <= S1;
					END IF;
				WHEN S2 =>
					Y <= S3;
				WHEN S3 =>
					IF SV_LTn = '0' THEN
						Y <= S4;
					ELSE
						Y <= S3;
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
	
	PROCESS (S, VB_EQn, SV_LTn)
	BEGIN
		StorReg_CLRn <= '1';
		StorReg_EN <= '0';
		SUB <= '0';
		V_DONE <= '0';
		DONE <= '0';
		CTR_ENn <= '1';
		CTR_CLRn <= '1';
		VA_EN <= '0';
		VA_LD <= '0';
		VB_EN <= '0';
		VB_LD <= '0';
		
		CASE Y IS
			WHEN S0 =>
				CTR_CLRn <= '0';
				StorReg_CLRn <= '0';
				IF S = '0' THEN
					VA_LD <= '1';
					VB_LD <= '1';
				END IF;
			WHEN S1 =>
				VA_EN <= '1';
				VB_EN <= '1';
				IF VB_EQn = '0' THEN
					V_DONE <= '1';
					SUB <= '1';
				ELSIF VB_LSB = '1' THEN
					StorReg_EN <= '1';
				END IF;
			WHEN S2 =>
				V_DONE <= '1';
				SUB <= '1';
				StorReg_EN <= '1';
			WHEN S3 =>
				StorReg_EN <= '1';
				V_DONE <= '1';
				IF SV_LTn = '1' THEN
					SUB <= '1';
					CTR_ENn <= '0';
				END IF;
			WHEN S4 =>
				DONE <= '1';
				V_DONE <= '1';
		END CASE;
	END PROCESS;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY MUX IS
	PORT (SEL					: IN STD_LOGIC;
		  Di0, Di1				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  Dout					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END MUX;

ARCHITECTURE BEHAVIOR OF MUX IS
BEGIN
	WITH SEL SELECT
		Dout <= Di0 WHEN '0',
				Di1 WHEN '1';
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY COUNTER IS
	PORT (LOADn, UP, ENn, CLK		: IN STD_LOGIC;
		  dIn						: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  TCDn						: OUT STD_LOGIC;
		  dOut						: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COUNTER;

ARCHITECTURE BEHAVIOR OF COUNTER IS
SIGNAL TEMP : STD_LOGIC_VECTOR(7 DOWNTO 0);
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
		TCDn <= '0' WHEN "00000000",
				'1' WHEN OTHERS;
	
	dOut <= TEMP;
END BEHAVIOR;

--------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ADD_SUB IS
	PORT (DATA					: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  PREVDATA				: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  SUB 					: IN STD_LOGIC;
		  TOTAL					: OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END ADD_SUB;

ARCHITECTURE BEHAVIOR OF ADD_SUB IS
SIGNAL TEMP : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
	PROCESS (DATA, PREVDATA, SUB)
	BEGIN
		TEMP <= "00000000" & DATA;
		IF SUB = '0' THEN
			TOTAL <= TEMP + PREVDATA;
		ELSE
			TOTAL <= PREVDATA - TEMP;
		END IF;
	END PROCESS;
END BEHAVIOR;

--------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ADD_SUB_BIT IS
	PORT (DATA	 				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  SUB, P7, P6, P5		: IN STD_LOGIC;
		  P4, P3, P2, P1, P0	: IN STD_LOGIC;
		  TOTAL					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END ADD_SUB_BIT;

ARCHITECTURE BEHAVIOR OF ADD_SUB_BIT IS
SIGNAL PREVDATA	: STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
	PROCESS (DATA, PREVDATA, SUB)
	BEGIN
		PREVDATA(0) <= P0;
		PREVDATA(1) <= P1;
		PREVDATA(2) <= P2;
		PREVDATA(3) <= P3;
		PREVDATA(4) <= P4;
		PREVDATA(5) <= P5;
		PREVDATA(6) <= P6;
		PREVDATA(7) <= P7;
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
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY COMPAR8 IS
	PORT (dIn, dComp				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  EQn, LTn, GTn				: OUT STD_LOGIC);
END COMPAR8;

ARCHITECTURE BEHAVIOR OF COMPAR8 IS
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

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY COMPAR16 IS
	PORT (dIn, dComp				: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  EQn, LTn, GTn				: OUT STD_LOGIC);
END COMPAR16;

ARCHITECTURE BEHAVIOR OF COMPAR16 IS
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
---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY INVERT IS
	PORT (dIn		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  dOut		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END INVERT;

ARCHITECTURE BEHAVIOR OF INVERT IS
BEGIN
 dOut <= NOT dIn;
END BEHAVIOR;

---------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SHIFT IS
	PORT (dIn					: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  CLK, CLR, LD, R, EN	: IN STD_LOGIC;
		  dOut					: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END SHIFT;

ARCHITECTURE BEHAVIOR OF SHIFT IS
SIGNAL TEMPinR		: STD_LOGIC_VECTOR (6 DOWNTO 0);
SIGNAL TEMPinL		: STD_LOGIC_VECTOR (6 DOWNTO 0);
SIGNAL TEMPout 		: STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
	PROCESS (CLR, CLK)
	BEGIN
		TEMPinR <= TEMPout(7 DOWNTO 1);
		TEMPinL <= TEMPout(6 DOWNTO 0);
		IF (CLK'EVENT AND CLK = '1') THEN
			IF EN = '1' THEN
				IF R = '1' THEN
					TEMPout <=	'0' & TEMPinR;
				ELSE
					TEMPout <= TEMPinL & '0';
				END IF;
			ELSIF CLR = '1' THEN
				TEMPout <= "00000000";
			ELSIF LD = '1' THEN
				TEMPout <= dIn;
			END IF;
		END IF;
	END PROCESS;
	dOut <= TEMPout;
END BEHAVIOR;

-----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY STOR_REG IS
	PORT (Din						: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  CLK, CLRn, EN				: IN STD_LOGIC;
		  Dout						: OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END STOR_REG;

ARCHITECTURE BEHAVIOR OF STOR_REG IS
BEGIN
	PROCESS (CLRn, CLK)
	BEGIN
		IF (CLK'EVENT AND CLK = '1') THEN
			IF CLRn = '0' THEN
				Dout <= "0000000000000000";
			ELSIF EN = '1' THEN
				Dout <= Din;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;

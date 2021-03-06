-- Tyler Zoucha and Ethan Ashley
-- CEEN 3130-002
-- Monday Section
-- Lab 6

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY BCD_Counter IS
	PORT ( CLK, EN, RESET, OE			: IN STD_LOGIC;
		   COUNT						: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		   TC							: OUT STD_LOGIC);
END BCD_COUNTER;

ARCHITECTURE Behavior OF BCD_COUNTER IS
SIGNAL TEMP								: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	PROCESS (RESET, CLK, EN)
	BEGIN
		IF RESET = '1' THEN
			TEMP <= "0000";
		ELSIF CLK'EVENT AND CLK = '1' AND EN = '1' THEN
			IF TEMP = "1001" THEN
				TC <= '1';
				TEMP <= "0000";
			ELSE
				TEMP <= TEMP + 1;
			END IF;	
		END IF;	
	END PROCESS;

COUNT <= TEMP WHEN (OE = '1') ELSE "ZZZZ";

END Behavior;

-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TwoDecadeCounter IS
	PORT ( CLK, EN2, RESET, SEL, EN		: IN STD_LOGIC;
		   A7, A6, A5, A4				: OUT STD_LOGIC;
		   SELECTn						: OUT STD_LOGIC;
		   A3, A2, A1, A0				: OUT STD_LOGIC;
		   TCOUT						: OUT STD_LOGIC);
		  
		  attribute loc: string;
		  attribute loc of CLK: signal is "p1";
		  attribute loc of RESET: signal is "p2";
		  attribute loc of EN: signal is "p3";
		  attribute loc of SEL: signal is "p4";
		  attribute loc of EN2: signal is "p5";
		  attribute loc of TCOUT: signal is "p14";
		  attribute loc of SELECTN: signal is "p15";
		  attribute loc of A0: signal is "p16";
		  attribute loc of A1: signal is "p17";
		  attribute loc of A2: signal is "p18";
		  attribute loc of A3: signal is "p19";
		  attribute loc of A4: signal is "p20";
		  attribute loc of A5: signal is "p21";
		  attribute loc of A6: signal is "p22";
		  attribute loc of A7: signal is "p23";
END TwoDecadeCounter;

ARCHITECTURE Structure OF TwoDecadeCounter IS
COMPONENT BCD_COUNTER
	PORT ( CLK, EN, RESET, OE			: IN STD_LOGIC;
		   COUNT						: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		   TC							: OUT STD_LOGIC);
END COMPONENT;

SIGNAL COUNT1, COUNT2					: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL SEL2								: STD_LOGIC;
SIGNAL TEMP								: STD_LOGIC;
BEGIN
	SEL2 <= NOT SEL;

	counter0: BCD_COUNTER PORT MAP (CLK, EN2, RESET, SEL, COUNT2, TEMP);
	counter1: BCD_COUNTER PORT MAP (CLK, EN, RESET, SEL2, COUNT1, TCOUT);
	
	SELECTn <= SEL2;
	
	A7 <= COUNT1(0);
	A6 <= COUNT1(1);
	A5 <= COUNT1(2);
	A4 <= COUNT1(3);
	A3 <= COUNT2(0);
	A2 <= COUNT2(1);
	A1 <= COUNT2(2);
	A0 <= COUNT2(3);
END Structure;
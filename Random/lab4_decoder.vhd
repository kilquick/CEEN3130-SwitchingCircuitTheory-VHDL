LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY lab4_decoder IS
	PORT (bcd								: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  hex								: IN STD_LOGIC;
		  sign								: OUT STD_LOGIC;
		  seg								: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
attribute loc: string;
attribute loc of bcd : signal is "p1,p2,p3,p4"; -- Assigns IN_VECTOR(3) to pin 1
-- IN_VECTOR(2) to pin 2, etc.
attribute loc of hex : signal is "p5";
attribute loc of seg : signal is "p23,p22,p21,p20,p19,p18,p17"; -- Assigns OUT_VECTOR(3) to pin 23, etc
attribute loc of sign : signal is "p16";
END lab4_decoder;
	
	
ARCHITECTURE Behavior OF lab4_decoder IS
SIGNAL s: STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
	s(4) <= hex;
	s(3 DOWNTO 0) <= bcd;
	
	sign <= NOT(bcd(3) AND NOT hex);
	
	WITH s SELECT
		seg <= "0000001" WHEN "00000",
			   "1001111" WHEN "00001",
			   "0010010" WHEN "00010",
			   "0000110" WHEN "00011",
			   "1001100" WHEN "00100",
			   "0100100" WHEN "00101",
			   "0100000" WHEN "00110",
			   "0001111" WHEN "00111",
			   "0000000" WHEN "01000",
			   "0001111" WHEN "01001",
			   "0100000" WHEN "01010",
			   "0100100" WHEN "01011",
			   "1001100" WHEN "01100",
			   "0000110" WHEN "01101",
			   "0010010" WHEN "01110",
			   "1001111" WHEN "01111",
			   "0000001" WHEN "10000",
			   "1001111" WHEN "10001",
			   "0010010" WHEN "10010",
			   "0000110" WHEN "10011",
			   "1001100" WHEN "10100",
			   "0100100" WHEN "10101",
			   "0100000" WHEN "10110",
			   "0001111" WHEN "10111",
			   "0000000" WHEN "11000",
			   "0000100" WHEN "11001",
			   "0001000" WHEN "11010",
			   "0000000" WHEN "11011",
			   "0110001" WHEN "11100",
			   "0000001" WHEN "11101",
			   "0110000" WHEN "11110",
			   "0111000" WHEN "11111",
			   "0000000" WHEN OTHERS;
		
END Behavior;
	
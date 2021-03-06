--Tyler Zoucha
--CEEN 3130
--Slow Multiply 169

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SlowMult169 IS
	PORT (RESET, S, MCANDn, MLTPn, CLK	: IN STD_LOGIC;
	      LDNAn, LDNBn, LDNCn			: OUT STD_LOGIC;
	      ENPNAn, ENPNBn, ENPNCn		: OUT STD_LOGIC;
	      DONE							: OUT STD_LOGIC);
END SlowMult169;

ARCHITECTURE BEHAVIOR OF SlowMult169 IS
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
		LDNAn <= '1';
		LDNBn <= '1';
		LDNCn <= '1';
		ENPNAn <= '1';
		ENPNBn <= '1';
		ENPNCn <= '1';
		DONE <= '0';
		
		CASE Y IS
			WHEN S0 =>
				IF S = '1' THEN
					LDNAn <= '0';
					LDNBn <= '0';
					LDNCn <= '0';
				END IF;
			WHEN S1 =>
			WHEN S2 =>
				IF MCANDn = '1' THEN
					ENPNAn <= '0';
					ENPNCn <= '0';
				ELSE
					ENPNBn <= '0';
				END IF;
			WHEN S3 =>
				IF MLTPn = '1' THEN
					LDNAn <= '0';
				END IF;
			WHEN S4 =>
				DONE <= '1';
		END CASE;
	END PROCESS;
END BEHAVIOR;
--Tyler Zoucha & Ethan Ashley
--Lab 8 Part B
--LED Turn Signal Patterns

LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY Lab8PartB IS
	PORT (H, X, CLOCK, RESETn			: IN STD_LOGIC;
		  B5, B4, B3, B2, B1, B0		: OUT STD_LOGIC);
	ATTRIBUTE loc: string;
	ATTRIBUTE loc of CLOCK: signal is "p1";
	ATTRIBUTE loc of H: signal is "p2";
	ATTRIBUTE loc of X: signal is "p3";
	ATTRIBUTE loc of RESETn: signal is "p4";
	ATTRIBUTE loc of B5: signal is "p23";
	ATTRIBUTE loc of B4: signal is "p22";
	ATTRIBUTE loc of B3: signal is "p21";
	ATTRIBUTE loc of B2: signal is "p20";
	ATTRIBUTE loc of B1: signal is "p19";
	ATTRIBUTE loc of B0: signal is "p18";
END Lab8PartB;

ARCHITECTURE Behavior of Lab8PartB IS
SIGNAL y_present, y_next		: STD_LOGIC_VECTOR(5 DOWNTO 0);

ATTRIBUTE syn_state_machine : boolean;  							--for Lattice so it
ATTRIBUTE syn_state_machine of y_present : signal is false; 		-- doesn't use 1 hot

BEGIN
	PROCESS (X, H, y_present)
	BEGIN
		IF (H = '0' AND X = '0') THEN
			CASE y_present IS
				WHEN "000000" => y_next <= "001000";
				WHEN "001000" => y_next <= "011000";
				WHEN "011000" => y_next <= "111000";
				WHEN "111000" => y_next <= "000000";
				WHEN OTHERS => y_next <= "000000";
			END CASE;
		ELSIF (H = '0' AND X = '1') THEN
			CASE y_present IS
				WHEN "000000" => y_next <= "000100";
				WHEN "000100" => y_next <= "000110";
				WHEN "000110" => y_next <= "000111";
				WHEN "000111" => y_next <= "000000";
				WHEN OTHERS => y_next <= "000000";
			END CASE;
		ELSE 
			CASE y_present IS
				WHEN "000000" => y_next <= "111111";
				WHEN "111111" => y_next <= "000000";
				WHEN OTHERS => y_next <= "000000";
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS (CLOCK, RESETn)
	BEGIN
		IF RESETn = '0' THEN
			y_present <= "000000";
		ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
			y_present <= y_next;
		END IF;
	END PROCESS;
	
	B0 <= y_present(0);
	B1 <= y_present(1);
	B2 <= y_present(2);
	B3 <= y_present(3);
	B4 <= y_present(4);
	B5 <= y_present(5);
	
END Behavior;

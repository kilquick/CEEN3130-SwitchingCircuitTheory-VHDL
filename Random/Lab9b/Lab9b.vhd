library ieee;
use ieee.std_logic_1164.all;


ENTITY Lab9b IS
	PORT ( 	N, D, Q, P15, P20, P25, clk, reset	: IN STD_LOGIC;
		No, Do, Qo, Z5, Z10						: OUT STD_LOGIC);
			
END Lab9b;

ARCHITECTURE Behavior OF Lab9b IS

TYPE State_type IS (S0, S5, S10, S15, S20, S25, S30, R5, R10, R15);
SIGNAL state: State_type;
SIGNAL N0, N1, D0, D1, Q0, Q1: STD_LOGIC;

BEGIN
		
	PROCESS (N, D, Q, clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF N = '1' THEN
				IF N1 = '0' THEN  --N1 created as a watchdog for N0
					N0 <= '1';    --N0 used to ensure that no matter how long N is high N0 will be only 1 clock long
					N1 <= '1';     
				ELSIF N1 = '1' THEN  --When N1 goes high N0 goes low to make sure N0 is only 1 clock in length
					N0 <= '0';
				END IF;
				D0 <= '0';
				D1 <= '0';
				Q0 <= '0';
				Q1 <= '0';				
			ELSIF D = '1' THEN
				IF D1 = '0' THEN
					D0 <= '1';
					D1 <= '1';
				ELSIF D1 = '1' THEN
					D0 <= '0';
				END IF;
				Q0 <= '0';
				Q1 <= '0';
			ELSIF Q = '1' THEN
				IF Q1 = '0' THEN
					Q0 <= '1';
					Q1 <= '1';
				ELSIF Q1 = '1' THEN
					Q0 <= '0';
				END IF;
			ELSE
				N0 <= '0';
				N1 <= '0';
				D0 <= '0';
				D1 <= '0';
				Q0 <= '0';
				Q1 <= '0';
			END IF;
		END IF;
	END PROCESS;

	PROCESS (state, N, D, Q, clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF reset = '1' THEN
				state <= S0;
			END IF;
			CASE (state) IS
				WHEN S0 =>
					IF N0 = '1' THEN
						state <= S5;
					ELSIF D0 = '1' THEN
						state <= S10;
					ELSIF Q0 = '1' THEN
						state <= S25;
					ELSE
						state <= S0;
					END IF;
				WHEN S5 =>
					IF N0 = '1' THEN
						state <= S10;
					ELSIF D0 = '1' THEN
						state <= S15;
					ELSIF Q0 = '1' THEN
						state <= S30;
					ELSE
						state <= S5;
					END IF;
				WHEN S10 =>
					IF N0 = '1' THEN
						state <= S15;
					ELSIF D0 = '1' THEN
						state <= S20;
					ELSIF Q0 = '1' THEN
						state <= S30;
					ELSE
						state <= S10;
					END IF;
				WHEN S15 =>
					IF P15 = '1' AND P20 ='0' AND P25 = '0' THEN
						state <= S0;
					ELSIF N0 = '1' THEN
						state <= S20;
					ELSIF D0 = '1' THEN
						state <= S25;
					ELSIF Q0 = '1' THEN
						state <= S30;
					ELSE
						state <= S15;
					END IF;
				WHEN S20 =>
					IF P15 = '1' AND P20 ='0' AND P25 = '0' THEN   --R5 is used to create a state for a change refund 
						state <= R5;                                 --without having the change refund in this process
					ELSIF P15 = '0' AND P20 ='1' AND P25 = '0' THEN
						state <= S0;
					ELSIF N0 = '1' THEN
						state <= S25;
					ELSIF D0 = '1' THEN
						state <= S30;
					ELSIF Q0 = '1' THEN
						state <= S30;
					ELSE
						state <= S20;
					END IF;				
				WHEN S25 =>
					IF P15 = '1' AND P20 ='0' AND P25 = '0' THEN
						state <= R10;
					ELSIF P15 = '0' AND P20 ='1' AND P25 = '0' THEN
						state <= R5;
					ELSIF P15 = '0' AND P20 ='0' AND P25 = '1' THEN
						state <= S0;
					ELSIF N0 = '1' THEN
						state <= S30;
					ELSIF D0 = '1' THEN
						state <= S30;
					ELSIF Q0 = '1' THEN
						state <= S30;
					ELSE
						state <= S25;
					END IF;					
				WHEN S30 =>
					IF P15 = '1' AND P20 ='0' AND P25 = '0' THEN
						state <= R15;
					ELSIF P15 = '0' AND P20 ='1' AND P25 = '0' THEN
						state <= R10;
					ELSIF P15 = '0' AND P20 ='0' AND P25 = '1' THEN
						state <= R5;
					ELSIF N0 = '1' THEN
						state <= S30;
					ELSIF D0 = '1' THEN
						state <= S30;
					ELSIF Q0 = '1' THEN
						state <= S30;
					ELSE
						state <= S30;
					END IF;
				WHEN R5 =>
					state <= S0;
				WHEN R10 =>
					state <= S0;
				WHEN R15 =>
					state <= S0;
			END CASE;
		END IF;	
	END PROCESS;

	PROCESS (state)    --This process is used to give correct change
	BEGIN
		CASE (state) IS
			WHEN S0 =>         --Each state has to be declared in the case declaration
				Z5 <= '0';     --so at each non change state the change output is 0
				Z10 <= '0';
			WHEN S5 =>
				Z5 <= '0';
				Z10 <= '0';
			WHEN S10 =>
				Z5 <= '0';
				Z10 <= '0';
			WHEN S15 =>
				Z5 <= '0';
				Z10 <= '0';
			WHEN S20 =>
				Z5 <= '0';
				Z10 <= '0';
			WHEN S25 =>
				Z5 <= '0';
				Z10 <= '0';
			WHEN S30 =>
				Z5 <= '0';
				Z10 <= '0';
			WHEN R5 =>
				Z5 <= '1';
				Z10 <= '0';
			WHEN R10 =>
				Z5 <= '0';
				Z10 <= '1';
			WHEN R15 =>
				Z5 <= '1';
				Z10 <= '1';
		END CASE;
	END PROCESS;
	
	No <= N0;
	Do <= D0;
	Qo <= Q0;
	
END Behavior;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY  ram_fsm IS
      PORT( 
         clk, reset, start  			:IN	 std_logic;
         addr, data						:IN  std_logic_vector;
		 delay,vwrite					:OUT std_logic;
		 addr_del,data_del				:OUT std_logic_vector
         );
END ram_fsm;

ARCHITECTURE synth OF ram_fsm IS
  TYPE   state_t IS (m3, m2, m1, mx);
  SIGNAL state, nstate : state_t;
 
--Finite state machine implementation
BEGIN
FSM: PROCESS(state, start)
	BEGIN
		nstate<=state;
		delay<='0';
		vwrite<='0';	
		CASE state IS
		WHEN mx=> 
			IF start='1' THEN 
				nstate<=m1; 
			END IF;
		WHEN m1=> 
			nstate<=m2;
			IF start='1' THEN 
				delay<='1'; 
			END IF;
		WHEN m2=> 
			nstate<=m3;
			IF start='1' THEN 
				delay<='1'; 
			END IF;
		WHEN m3=>
			vwrite<='1'; 
			IF start='1' THEN 
				nstate<=m1; 
			ELSE
				nstate<=mx;
			END IF;		
		END CASE;
	
END PROCESS FSM;

--Positively triggered process to change state and reset
clk_pos:	PROCESS
BEGIN
	WAIT UNTIL clk'EVENT and CLK='1';
	state<=nstate;
	IF reset='1' THEN
		state<=mx;
	END IF;
END PROCESS clk_pos;

--Negatively triggered process to pass address and data
clk_neg:	PROCESS
BEGIN
	WAIT UNTIL clk'EVENT and CLK='0';
	addr_del<=addr;
	data_del<=data;
END PROCESS clk_neg;

END ARCHITECTURE synth;


LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.project_pack.ALL;

ENTITY rcb IS
	GENERIC(vsize : INTEGER := 6);
	PORT(
		clk          : IN  std_logic;
		reset        : IN  std_logic;

		-- db connections
		x            : IN std_logic_vector(VSIZE-1 DOWNTO 0);
		y            : IN std_logic_vector(VSIZE-1 DOWNTO 0);
		rcbcmd       : IN std_logic_vector(2 DOWNTO 0);
		startcmd     : IN std_logic;
		dbb_delaycmd : OUT STD_LOGIC;
		dbb_rcbclear : OUT STD_LOGIC;

		-- vram connections
		vdout        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		vdin         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		vwrite       : OUT STD_LOGIC;
		vaddr        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

		-- vdp connection
		rcb_finish   : OUT STD_LOGIC
	);
END rcb;

ARCHITECTURE rtl1 OF rcb IS
--pix_word_cache
        SIGNAL pw, wen_all 				:  std_logic;
        SIGNAL pixnum           		:  std_logic_vector(3 DOWNTO 0);
        SIGNAL pixopin          		:  pixop_t;       
        SIGNAL opout,opram            	:	pixop_t;
  		SIGNAL rdout_par                :	store_t;
--ram_fsm
        SIGNAL start  					:	std_logic;
		SIGNAL delay					: 	std_logic;
		TYPE   state_t IS (m3, m2, m1, mx); --FSM states 
		SIGNAL state, nstate : state_t;
--split
		SIGNAL xin,yin 					:	 std_logic_vector(VSIZE-1 DOWNTO 0);
		SIGNAL word_num_new				:  	 std_logic_vector(7 DOWNTO 0);
--word_reg
		SIGNAL word_num_old				:  	 std_logic_vector(7 DOWNTO 0);
--equals
		SIGNAL same_word				:	 std_logic;	--check whether word number is same
--clear
		SIGNAL clrx_reg,clry_reg		:	 std_logic_vector(VSIZE-1 DOWNTO 0);
		SIGNAL clrxy_new_reg,clrxy_old_reg		:	 std_logic_vector(2*VSIZE-1 DOWNTO 0);
		SIGNAL delaycmd					:   	std_logic;
		SIGNAL scan_done				:		std_logic;--check whether scan process is finished
--rcb_fsm
		TYPE   rstate_t IS (r3,r2, r1,rx); --rcb_fsm states
		SIGNAL rstate,nrstate 			:		rstate_t;
		SIGNAL timer					:		std_logic_vector(3 DOWNTO 0);--terminate the process at the end of program
		SIGNAL cmd_slv					:		std_logic_vector(31 DOWNTO 0);--slv form of commands from pix_word_cache
		SIGNAL ram_in_slv				:		std_logic_vector(15 DOWNTO 0);--correct value of ram after drawing
		SIGNAL p1,p2					:		std_logic_vector(15 DOWNTO 0);--intermediate signal for generating correct value of ram
		SIGNAL delaycmd_i				:  		std_logic;--delay command request for clearing screen
--detect cmd is about draw or clear '1' means draw, '0' means clear
		SIGNAL draw_or_clear			:		std_logic;--signal to track type of command
		SIGNAL draw_or_clear_old		:		std_logic;--track the previous value of draw_or_clear
--ram_clear
		SIGNAL is_clear					:		std_logic;--check whether clearing process is finished
BEGIN
	
--pix_word_cache design starts here, similar to previous exercises, but is_same signal is removed-------------------------------------------------------------------------------------------------------- 
change: PROCESS(pixopin,opram,pw,wen_all)
BEGIN
        opout<=pixopin;
        IF pixopin=pinvert OR pixopin = psame THEN
                IF wen_all='0' THEN
                        IF pixopin=psame THEN
                        opout<=opram;
                        ELSIF  opram=pblack THEN
                        opout<=pwhite;
                        ELSIF  opram=pwhite THEN
                        opout<=pblack;
                        ELSIF  opram=pinvert THEN
                        opout<=psame;
                        END IF;
                        ELSIF pw='0' THEN
                        opout<=psame;
                END IF;
        END IF;
END PROCESS change;

--ram command generator for pix_word_cache
store_ram: PROCESS
BEGIN
        WAIT UNTIL clk'EVENT AND clk='1';
        IF reset='1'THEN
        rdout_par<=(OTHERS=>psame);
        ELSIF wen_all='1'AND  pw='1' THEN
        rdout_par<=(OTHERS=>psame);
        rdout_par(to_integer(unsigned(pixnum)))<=opout;
        ELSIF wen_all='1'THEN
        rdout_par<=(OTHERS=>psame);
        ELSIF pw='1' THEN
                rdout_par(to_integer(unsigned(pixnum)))<=opout;
                IF opout=psame THEN
                END IF;
        END IF;
        IF same_word='0'THEN
        	rdout_par<=(OTHERS=>psame);
        END IF;
END PROCESS store_ram;

opram<=rdout_par(to_integer(unsigned(pixnum)));

--pix_word_cache ends here--------------------------------------------------------------------------------------------------------------------------

--ram_fsm design. Same as previous exercises--------------------------------------------------------------------------------------------------------
ram_fsm: PROCESS(state, start)
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
	
END PROCESS ram_fsm;

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
	vaddr<=word_num_new;
	vdin<=ram_in_slv;
END PROCESS clk_neg;
cmd_slv<=store2slv(rdout_par);

--RAM_FAM ends here--------------------------------------------------------------------------------------------------------------------------

--This block splits x&y into pixel number and word number	
split: BLOCK
BEGIN
	word_num_new(3 DOWNTO 0)<=xin(5 DOWNTO 2);
	word_num_new(7 DOWNTO 4)<=yin(5 DOWNTO 2);
	pixnum(1 DOWNTO 0)<=xin(1 DOWNTO 0);
	pixnum(3 DOWNTO 2)<=yin(1 DOWNTO 0);
END BLOCK split;	

--This block stores the previous word number for comparison
word_reg: PROCESS
BEGIN
	WAIT UNTIL clk'EVENT and CLK='1'; --positive clock triggered
	word_num_old<=word_num_new;
END PROCESS word_reg;	

--This block checks whether word location changes, and set same_word to 0 if so.
equals: PROCESS(word_num_old,word_num_new)
BEGIN
	same_word<='1';
	IF word_num_old /= word_num_new and startcmd='1' THEN
		same_word<='0';
	END IF;
END PROCESS equals;	
	
--This block implements the function when command is 'clear screen'
clear: PROCESS--performs raster scan
BEGIN
	WAIT UNTIL clk'EVENT and CLK='1'; --positive clock triggered
--reset value and default value
	IF reset='1'THEN
		draw_or_clear_old<='1';
		scan_done<='1';
	END IF;
	clrx_reg<=clrx_reg;
	clry_reg<=clry_reg;
	scan_done<=scan_done;

--increment or decrement pixel coordinates depending on orientation
	IF delay='0' and rstate=rx THEN
		scan_done<='0';
		IF clrx_reg=clrxy_new_reg(2*VSIZE-1 DOWNTO VSIZE)THEN
			IF clrxy_new_reg(2*VSIZE-1 DOWNTO VSIZE)<clrxy_old_reg(2*VSIZE-1 DOWNTO VSIZE) THEN
				clry_reg<=std_logic_vector(signed(clry_reg)-1);
			ELSE
				clry_reg<=std_logic_vector(signed(clry_reg)+1);
			END IF;
				clrx_reg<=clrxy_old_reg(2*VSIZE-1 DOWNTO VSIZE);
		ELSE
			IF clrxy_new_reg(VSIZE-1 DOWNTO 0) < clrxy_old_reg(VSIZE-1 DOWNTO 0) THEN
				clrx_reg<=std_logic_vector(signed(clrx_reg)-1);
			ELSE
				clrx_reg<=std_logic_vector(signed(clrx_reg)+1);
			END IF;
		END IF;
	END IF;

--only changes termination location of clearing screen if there is new command coming in
	IF delaycmd='0' THEN
		clrxy_old_reg<=clrxy_new_reg;
	END IF;

--set scanner indicator to 1 if curser reaches final location or command is not 'clear screen'
	IF clrx_reg=clrxy_new_reg(2*VSIZE-1 DOWNTO VSIZE) and clry_reg=clrxy_new_reg(VSIZE-1 DOWNTO 0) THEN
		scan_done<='1';
	END IF;
	IF draw_or_clear='1' THEN
		scan_done<='1';
	END IF;

--initialise registers for clearing in the first cycle after command becomes 'clear screen'	
	IF draw_or_clear='0' and draw_or_clear_old='1' THEN
		clrx_reg<=clrxy_new_reg(2*VSIZE-1 DOWNTO VSIZE);
		clry_reg<=clrxy_new_reg(VSIZE-1 DOWNTO 0);		
	END IF;

--track the previous type of command for comparison	
	draw_or_clear_old<=draw_or_clear;
END PROCESS clear;

--always save latest coordinates in clrxy_new_reg
clrxy_new_reg(2*VSIZE-1 DOWNTO VSIZE)<=x;
clrxy_new_reg(VSIZE-1 DOWNTO 0)<=y;

--Multiplexer to choose coordinates(either from db or from clear screen block)
mux: PROCESS(draw_or_clear, clrx_reg, clry_reg, x, y)
BEGIN
	xin<=x;
	yin<=y;
	IF draw_or_clear='0' THEN
		xin<=clrx_reg;
		yin<=clry_reg;
	END IF;
END PROCESS mux;

--detect type of command. Either write or clear. Not_use and move_pen is implemented as psame command
cmd_type:PROCESS(rcbcmd)
BEGIN
	draw_or_clear<='1';
	IF rcbcmd(2)='1' OR rcbcmd="000" THEN
		draw_or_clear<='0';
	END IF;
END PROCESS cmd_type;

--generate colour input for pix_word_cache
cnv: PROCESS(rcbcmd)
BEGIN
	IF rcbcmd(1)='1' THEN
		pixopin<=pblack;
		IF rcbcmd(0)='1'THEN
			pixopin<=pinvert;
		END IF;
	ELSE
		pixopin<=psame;
		IF rcbcmd(0) ='1'THEN
			pixopin<=pwhite;
		END IF;
	END IF;
END PROCESS cnv;

--FSM for rcb controller, which is similar to RAM_FSM but with extra outputs--------------------------------------------------------------------------------------------------------
rcb_fsm: Process(draw_or_clear,rstate,startcmd,delay,scan_done,same_word,rdout_par,is_clear)
BEGIN
	nrstate<=rstate;
	delaycmd_i<='1';
	wen_all<=wen_all;
	pw<=pw;
	start<='0';

	CASE rstate IS
	WHEN rx=>
		pw<='0';
		IF startcmd='1'THEN
			nrstate<=r1;
			start<='1';
		END IF;
		IF draw_or_clear_old='1' and draw_or_clear='0'THEN
			nrstate<=rx;
			delaycmd_i<='0';
		END IF;
	WHEN r1=>
		wen_all<='0';
		pw<='1';
		nrstate<=r2;
		IF draw_or_clear='0'THEN
			wen_all<='1';
		END IF;
	WHEN r2=>
		wen_all<='1';
		nrstate<=r3;
	WHEN r3=>
		nrstate<=rx;
		delaycmd_i<='0';
		IF draw_or_clear='0'and is_clear='0'THEN
			delaycmd_i<='1';
		END IF;
	END CASE;
END PROCESS rcb_fsm;

--set delay_cmd to high whenever ram is busy or in the process of clearing screen
delaycmd<=delaycmd_i or delay;--code in running slow, so delay is always low.

rcb_clk_pos: PROCESS
BEGIN
	WAIT UNTIL clk'EVENT and CLK='1';
	rcb_finish<='0';
	rstate<=nrstate;
	IF reset='1' THEN
		rstate<=r1;
	END IF;
	IF timer="0000"THEN
		rcb_finish<='1';
	END IF;
	IF rstate/=rx THEN
		timer<="1111";
	ELSE
		timer<=std_logic_vector(unsigned(timer)-1);
	END IF;
END PROCESS rcb_clk_pos;
dbb_delaycmd<=delaycmd;
--RAM_FSM ENDS HERE----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check whether clear_screen is done or not
ram_clear: PROCESS(draw_or_clear, delay, scan_done)
BEGIN
	is_clear<='1';
	IF draw_or_clear='0' THEN
		is_clear<='0';
	END IF;
	IF scan_done='1'and delay='0'THEN
		is_clear<='1';
	END IF;
END PROCESS ram_clear;

--this process compare command with value stored in RAM to produce output value
reg3_pro: PROCESS(cmd_slv,vdout)
BEGIN
	FOR i in 0 to 15 LOOP
		p1(i)<=cmd_slv(2*i+1) and (not vdout(i)) ;
		p2(i)<=vdout(i) and (not cmd_slv(2*i)) ;
	END LOOP;
END PROCESS reg3_pro;
ram_in_slv<= p1 or p2;

--rcbclear function setting
dbb_rcbclear<='1';

END rtl1;      
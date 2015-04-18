-- **********************************
-- * draw_octant entity declaration *
-- **********************************
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY draw_octant IS
  GENERIC(vsize: INTEGER := 6);
  PORT(
    clk, resetx, draw, xbias, disable : IN  std_logic;
    xin, yin                 : IN  std_logic_vector(vsize-1 DOWNTO 0);
    done                     : OUT std_logic;
    x, y                     : OUT std_logic_vector(vsize-1 DOWNTO 0)
    );
END ENTITY draw_octant;

ARCHITECTURE comb OF draw_octant IS

  SIGNAL done1                    : std_logic; -- internal done
  SIGNAL x1, y1                   : unsigned(vsize-1 DOWNTO 0); -- internal x,y
  SIGNAL xincr, yincr, xnew, ynew : unsigned(vsize-1 DOWNTO 0);
  SIGNAL error                    : signed(vsize-1 DOWNTO 0);
  SIGNAL err1, err2               : unsigned(vsize DOWNTO 0);

BEGIN
  x    <= std_logic_vector(x1);
  y    <= std_logic_vector(y1);
  done <= done1;

  C1 : PROCESS(error, xincr, yincr, x1, y1, xnew, ynew, resetx, draw)  
  BEGIN

    err1 <= unsigned(abs(resize(error, vsize+1) + signed(resize(yincr,vsize+1))));
    err2 <= unsigned(abs(resize(error, vsize+1) - signed(resize(unsigned(xincr - yincr),vsize+1))));
    done1 <= '0';
    IF x1 = xnew and y1 = ynew and resetx = '0' and draw = '0' THEN
      done1 <= '1';
    END IF;

  END PROCESS C1;

  R1 : PROCESS
  BEGIN
    WAIT UNTIL clk'event AND clk = '1';
    IF disable = '0' THEN
      IF resetx = '1' THEN
        x1    <= unsigned(xin);
        y1    <= unsigned(yin);
        xincr <= (OTHERS => '0');
        yincr <= (OTHERS => '0');
        xnew  <= unsigned(xin);
        ynew  <= unsigned(yin);
        error <= (OTHERS => '0');
      
      ELSIF draw = '1' THEN
        xincr <= unsigned(xin) - x1;
        yincr <= unsigned(yin) - y1;
        xnew  <= unsigned(xin);
        ynew  <= unsigned(yin);
      
        ELSIF done1 = '1' THEN
          NULL; 
	  ELSE    
      IF err1 > err2 OR (err1 = err2 AND xbias = '0') THEN 
        y1    <= y1 + 1;
        x1    <= x1 + 1;
        error <= error + signed(yincr) - signed(xincr);
      ELSE
        x1    <= x1 + 1;
        error <= error + signed(yincr);    
      END IF;
    END IF;
  END IF;
    
  END PROCESS R1;

END ARCHITECTURE comb; 





-- **************************************
-- * draw_any_octant entity declaration *
-- **************************************
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SWAP IS
  GENERIC(  vsize: INTEGER := 6);
  PORT (
    xin, yin                : IN std_logic_vector(vsize-1 DOWNTO 0);
    c                       : IN std_logic;
    xout, yout              : OUT std_logic_vector(vsize-1 DOWNTO 0)
  );
END ENTITY SWAP;

ARCHITECTURE s1 OF SWAP IS
BEGIN
  C1 : PROCESS(xin, yin, c)
  BEGIN
    IF c = '1' THEN
       xout <= yin;
       yout <= xin;
    ELSE
       xout <= xin;
       yout <= yin;
    END IF;
  END PROCESS C1;
END ARCHITECTURE s1;


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY INVER IS
  GENERIC( vsize: INTEGER := 6);
  PORT (
    a                     : IN std_logic_vector(vsize-1 DOWNTO 0);
    c                     : IN std_logic;
    b                     : OUT std_logic_vector(vsize-1 DOWNTO 0)
  );
END ENTITY INVER;

ARCHITECTURE i1 OF INVER IS
BEGIN
  C1: PROCESS(a, c)
  BEGIN
    IF c = '1' THEN
       b <= NOT(a);
    ELSE
       b <= a;
    END IF;
  END PROCESS C1;
END ARCHITECTURE i1;


LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.INVER;
USE WORK.SWAP;
USE WORK.draw_octant;

ENTITY draw_any_octant IS
  GENERIC( vsize: INTEGER := 6);
  
  PORT(
    clk, resetx, draw, xbias, disable   : IN  std_logic;
    xin, yin                            : IN  std_logic_vector(vsize-1 DOWNTO 0);
    done                                : OUT std_logic;
    x, y                                : OUT std_logic_vector(vsize-1 DOWNTO 0);
    swapxy, negx, negy                  : IN  std_logic
    );
END ENTITY draw_any_octant;

ARCHITECTURE comb OF draw_any_octant IS
  
  SIGNAL xin1, yin1, xin2, yin2                   : std_logic_vector(vsize-1 DOWNTO 0);
  SIGNAL xout1, yout1, xout2, yout2               : std_logic_vector(vsize-1 DOWNTO 0);
  SIGNAL swapxy1, negx1, negy1, xbiasin           : std_logic;

BEGIN

    xbiasin <= swapxy xor xbias;
    -- Note that the order of SWAP and INV block is swaped to make sure it is correct when both swap and 
    -- negx/negy is 1.
    SWAP1: ENTITY SWAP GENERIC MAP(vsize) PORT MAP(xin1, yin1, swapxy, xin2, yin2);
    INV1: ENTITY INVER GENERIC MAP(vsize) PORT MAP(xin, negx, xin1);
    INV2: ENTITY INVER GENERIC MAP(vsize) PORT MAP(yin, negy, yin1);  
    SWAP2: ENTITY SWAP GENERIC MAP(vsize) PORT MAP(xout2, yout2, swapxy1, xout1, yout1);
    INV3: ENTITY INVER GENERIC MAP(vsize) PORT MAP(xout1, negx1, x);
    INV4: ENTITY INVER GENERIC MAP(vsize) PORT MAP(yout1, negy1, y);
    DRAW1: ENTITY draw_octant GENERIC MAP(vsize) PORT MAP(clk, resetx, draw, xbiasin, disable, xin2, yin2, done, xout2, yout2);
    
  R1: PROCESS
  
  BEGIN
    WAIT UNTIL clk'EVENT AND clk = '1';
    negx1 <= negx;
    negy1 <= negy;
    swapxy1 <= swapxy;    
  END PROCESS R1;
  
END ARCHITECTURE comb;





-- *************************
-- * Main part of DB BLOCK *
-- *************************
LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.project_pack.ALL;
USE WORK.draw_any_octant;
USE WORK.draw_octant;

ENTITY db IS
	GENERIC(vsize : INTEGER := 6);
	PORT(
		clk          : IN  std_logic;
		reset        : IN  std_logic;

		-- host processor connections
		hdb          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		dav          : IN  STD_LOGIC;
		hdb_busy     : OUT STD_LOGIC;

		-- rcb connections
		dbb_bus      : OUT db_2_rcb;
		dbb_delaycmd : IN  STD_LOGIC;
		dbb_rcbclear : IN  STD_LOGIC;

		-- vdp connection
		db_finish    : OUT STD_LOGIC
	);
END db;

ARCHITECTURE rtl OF db IS
  
  -- signals needed to be passed to RCB block
  SIGNAL cmd, pen : std_logic_vector(1 DOWNTO 0);
  SIGNAL dbb      : db_2_rcb;
  -- register to eliminate hdb latches
  SIGNAL hdb_i, hdb_pre    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
  -- registers to save the points of last action
  SIGNAL xpre,ypre         : std_logic_vector(vsize - 1 DOWNTO 0);
  -- registers to save the value of new incoming data
  SIGNAL xhold,yhold       : std_logic_vector(vsize - 1 DOWNTO 0);
  -- input to the draw_any_octant entity
  SIGNAL xnew,ynew        : std_logic_vector(vsize - 1 DOWNTO 0);
  -- output of the draw_any_octant entity
  SIGNAL xcurrent,ycurrent : std_logic_vector(vsize - 1 DOWNTO 0);

  -- internal signal to save the correct input parameters to draw_any_octant entity
  -- and interface with host processor
  SIGNAL negx, negy, swap, xbias, draw, done, disable, busy, resetx: std_logic;

  -- declaration of the FSM
  TYPE   state_t IS (idle, move, drawoct, drawoct_1, clear_add, clear_1, clearing);
  SIGNAL state, nstate : state_t;
  
BEGIN 
  
-- Process using 2 registers to eliminate hdb latches
HDBCMB: PROCESS(hdb, state, dav, hdb_pre)
BEGIN
  IF state = idle and dav = '1'  THEN
  hdb_i <= hdb;
  ELSE
  hdb_i <= hdb_pre;
  END IF; 
END PROCESS HDBCMB;
 
-- Process to generate input parameters to draw_any_octant entity  
OCTANTCMB: PROCESS(state,xhold,yhold, xpre, ypre, nstate,negx,negy) 
BEGIN
  -- default value is '0'
  negx <= '0'; negy <= '0'; swap <= '0';
  -- only change the value of negx, negy, swap when the draw command is read
  IF (state = idle and nstate = drawoct_1) or state = drawoct_1 or state = drawoct  THEN  
    
    IF  unsigned(xpre)>unsigned(xhold) THEN
      negx <= '1';
    END IF;   
           
    IF  unsigned(ypre)>unsigned(yhold) THEN
      negy <= '1';
    END IF;
    
    
    -- sequential IF statement to determine the correct value for swap
    IF unsigned(xpre)=unsigned(xhold) and unsigned(ypre)>unsigned(yhold) THEN
        IF unsigned(xpre)-unsigned(xhold) < unsigned(ypre)-unsigned(yhold) THEN
          swap <= '1';
        END IF;   
    END IF; 
    
    IF unsigned(xpre)=unsigned(xhold) and unsigned(ypre)<unsigned(yhold) THEN
        IF unsigned(xpre)-unsigned(xhold) < unsigned(yhold)-unsigned(ypre) THEN
          swap <= '1';
        END IF;   
    END IF; 

    IF unsigned(xpre)>unsigned(xhold) and unsigned(ypre)=unsigned(yhold) THEN
        IF unsigned(xpre)-unsigned(xhold) < unsigned(ypre)-unsigned(yhold) THEN
          swap <= '1';
        END IF;   
    END IF; 

    IF unsigned(xpre)<unsigned(xhold) and unsigned(ypre)=unsigned(yhold) THEN
        IF unsigned(xhold)-unsigned(xpre) < unsigned(ypre)-unsigned(yhold) THEN
          swap <= '1';
        END IF;   
    END IF;   
    
    IF unsigned(xpre)>unsigned(xhold) and unsigned(ypre)>unsigned(yhold) THEN
        IF unsigned(xpre)-unsigned(xhold) < unsigned(ypre)-unsigned(yhold) THEN
          swap <= '1';
        END IF;   
    END IF; 

    IF unsigned(xpre)<unsigned(xhold) and unsigned(ypre)>unsigned(yhold) THEN
        IF unsigned(xhold)-unsigned(xpre) < unsigned(ypre)-unsigned(yhold) THEN
          swap <= '1';
        END IF;   
    END IF;
    
    IF unsigned(xpre)>unsigned(xhold) and unsigned(ypre)<unsigned(yhold) THEN
        IF unsigned(xpre)-unsigned(xhold) < unsigned(yhold)-unsigned(ypre) THEN
          swap <= '1';
        END IF;   
    END IF;
    
    IF unsigned(xpre)<unsigned(xhold) and unsigned(ypre)<unsigned(yhold) THEN
        IF unsigned(xhold)-unsigned(xpre) < unsigned(yhold)-unsigned(ypre) THEN
          swap <= '1';
        END IF;   
    END IF;
       
  END IF;       
  
  -- Only the negx is needed to change when clear command is read since the y-value will 
  -- automatically increment or decrement 
  IF (state = idle and nstate =clear_1) or state = clear_1 or state = clearing or state = clear_add THEN

    IF  unsigned(xpre)>unsigned(xhold) THEN
      negx <= '1';
    END IF;
  END IF;    
  
  -- xbias is determined by vlaue of negx and negy to resolve corner cases
  xbias <= negx xnor negy;
  
END PROCESS OCTANTCMB;


-- state transition and signals which require 1 cycle delay
SS_PROC:PROCESS
BEGIN
  WAIT UNTIL clk'EVENT and clk = '1';
  
  -- register to save last hdb value to eliminate latches
  hdb_pre <= hdb_i;
  
  IF  dbb_delaycmd = '0' THEN
    state <= nstate;
  END IF;
  
  IF reset = '1' THEN
    state <= idle;
  END IF;  
  
  -- copy present value to register which save last value before reading next command
  IF nstate = idle and disable = '0' THEN
    xpre <= xhold;
    ypre <= yhold;
  END IF;
  
  -- increment or decrement y-value depending on the y-value of target point and that of 
  -- present point
  IF nstate = clear_add and disable = '0' THEN
    IF yhold > ypre THEN
      ypre <= std_logic_vector(unsigned(ypre) + 1); 
    END IF;
    IF yhold < ypre THEN
      ypre <= std_logic_vector(unsigned(ypre) - 1);
    END IF; 
  END IF;
END PROCESS SS_PROC;


-- declaration of FSM and how it transit to next state
STATE_PROC:PROCESS(state, hdb_i, cmd, pen, xcurrent, ycurrent, xpre, ypre, done, dav, dbb_rcbclear, xhold, yhold, dbb_delaycmd)
BEGIN
    
    -- initialise signals to eliminate the latches
    resetx <= '0';
    disable <= dbb_delaycmd;  
    draw <= '0';
    nstate <= state;
    busy <= '1';
    dbb.startcmd <= '1';
    xhold <= hdb_i(13 DOWNTO 14-vsize);
    yhold <= hdb_i(1+vsize DOWNTO 2);
    cmd <= hdb_i(15 DOWNTO 14);
    pen <= hdb_i(1 DOWNTO 0);
    dbb.rcb_cmd <= "000";
    xnew <= xhold;
    ynew <= yhold;
    CASE state IS
    -- idle state is to read command and send resetx signal to draw_any_octant entity
    -- if the next command is draw or clear 
    WHEN idle => busy <= '0'; 
                 dbb.startcmd <= '0';
                 IF dav = '1' and dbb_delaycmd = '0' THEN
                   CASE cmd IS
                     WHEN "00" => nstate <= move;
                     WHEN "01" => nstate <= drawoct_1;
                                  resetx <= '1';
                                  xnew <= xpre;
              	                   ynew <= ypre;
                     WHEN "10" => IF dbb_rcbclear = '0' THEN 
                                    nstate <= clear_1;
                                    resetx <= '1';
                                    xnew <= xpre;
                                    ynew <= ypre;
                                  END IF;
                     WHEN OTHERS => NULL;
                   END CASE;
                 END IF;
            	       
    WHEN move => 
                 
                 dbb.startcmd <= '0';
			           nstate <= idle;     
			           
		-- the cycle before drawing the line. It is used to give a pulse to draw signal, which
		-- will tell draw_any_octant entity to start working                   
		WHEN drawoct_1 => 
		                  nstate <= drawoct;
		                  draw <= '1';
		                  xnew <= xhold;
                      ynew <= yhold;
		                  dbb.startcmd <= '0';
             
    WHEN drawoct =>  
                 CASE pen IS
	               		WHEN "01"  => dbb.rcb_cmd <= "001";
	               		WHEN "10"  => dbb.rcb_cmd <= "010";
			             WHEN "11"  => dbb.rcb_cmd <= "011";
			             WHEN OTHERS  => NULL;
			           END CASE;
			           IF done = '1' THEN
			             nstate <= idle;
			           END IF;
			           
		-- same function as drawoct_1  
		WHEN clear_1 => nstate <= clearing;
		                draw <= '1';
		                xnew <= xhold;
                    ynew <= ypre;
		                dbb.startcmd <= '0';
		  
		WHEN clearing => 
		                 CASE pen IS
	               		    WHEN "01"  => dbb.rcb_cmd <= "001";   --since clearscreen is done in DB BLOCK, so the rcb_cmd passed
	                		   WHEN "10"  => dbb.rcb_cmd <= "010";   --to RCB BLOCK will be same as the one in case DRAW
			                 WHEN "11"  => dbb.rcb_cmd <= "011";
			                 WHEN OTHERS  => NULL;
		                 END CASE;
		-- Check if the current pen reaches the target point
		                 IF done = '1' THEN
		                   IF xcurrent = xhold and ycurrent = yhold THEN
		                     nstate <= idle;
		                   ELSE
		                     nstate <= clear_add;
		                   END IF;
		                 END IF;
		-- reset draw_any_octant entity to start drawing new line
		WHEN clear_add =>  	dbb.startcmd <= '0';
		                    resetx <= '1';
		                    xnew <= xpre;
		                    ynew <= ypre;
		                    nstate <= clear_1;             

		WHEN OTHERS => NULL;
		END CASE;
  
END PROCESS STATE_PROC;

-- Output correct value to RCB block based on the state
MUX: PROCESS(state, xhold, yhold, xcurrent,ycurrent)
BEGIN
  dbb.X <= (others => '0');
  dbb.Y <= (others => '0');
  IF state = drawoct THEN
    dbb.X <= xcurrent;
    dbb.Y <= ycurrent;
  END IF;
  IF state = clearing THEN
    dbb.X <= xcurrent;
    dbb.Y <= ycurrent;
  END IF;
  IF state = move THEN
    dbb.X <= xhold;
    dbb.Y <= yhold;
  END IF;

END PROCESS MUX;



-- line drawing part
  OCT: ENTITY draw_any_octant GENERIC MAP(vsize) PORT MAP(clk, resetx, draw, xbias, disable, xnew, ynew, done, xcurrent, ycurrent, swap, negx, negy);
  
  dbb_bus <= dbb;
-- check whether DB block is finished or not
  db_finish <= not(dav) and not(busy);
  hdb_busy <= busy;
 
END ARCHITECTURE rtl;    
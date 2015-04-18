LIBRARY IEEE;

USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.ALL;

--Main entity to include and connect all other entities
ENTITY draw_any_octant IS

  GENERIC(
    vsize: INTEGER := 12
  );
  
  PORT(
    clk, resetx, draw, xbias : IN  std_logic;
    xin, yin                 : IN  std_logic_vector(vsize-1 DOWNTO 0);
    done                     : OUT std_logic;
    x, y                     : OUT std_logic_vector(vsize-1 DOWNTO 0);
    swapxy, negx, negy       : IN  std_logic;
    disable		     		 : IN  std_logic
    );
END ENTITY draw_any_octant;

ARCHITECTURE comb OF draw_any_octant IS
--Signal declaration
	SIGNAL xbias_d,negx_rd,negy_rd,swapxy_rd			 : std_logic;
	SIGNAL xin1,xin2,xin3,xin4,yin1,yin2,yin3,yin4 		 : std_logic_vector(vsize-1 DOWNTO 0);
	
BEGIN
	
--Register to delay signal for one cycle
DR: PROCESS
BEGIN
	WAIT UNTIL clk'EVENT AND clk='1' AND disable='0';
	negx_rd<=negx;
	negy_rd<=negy;
	swapxy_rd<=swapxy;
END PROCESS DR;

--Specify port map for draw_octant, which is not included in this vhd file
DRAW1: ENTITY draw_octant
	GENERIC MAP(vsize=>vsize)
	PORT MAP(
		clk=>clk,
		resetx=>resetx,
		draw=>draw,
		xbias=>xbias_d,
		disable=>disable,
		xin=>xin2,
		yin=>yin2,
		done=>done,
		x=>xin3,
		y=>yin3
	);

--Declare two swap functions.
swaps: PROCESS(xin,yin,swapxy,xin4,yin4,swapxy_rd)
	BEGIN
		xin1<=xin;yin1<=yin;	--initialise signals
		x<=xin4;y<=yin4; 		
		IF swapxy='1'THEN		--swap inputs if swap signal is high
			yin1<=xin;xin1<=yin;
		END IF;
		IF swapxy_rd='1'THEN
			y<=xin4;x<=yin4;
		END IF;
		
	END PROCESS swaps;

--Declare four inverse functions
invs: 	PROCESS(xin1,negx,yin1,negy,xin3,negx_rd,yin3,negy_rd)
	BEGIN
		xin2<=xin1;				--initialise signals
		yin2<=yin1;
		xin4<=xin3;
		yin4<=yin3;
		IF negx='1'THEN			--inverse input signal if corresponding neg is driven high
			xin2<=not xin1;
		END IF;
		IF negY='1'THEN
			yin2<=not yin1;
		END IF;
		IF negx_rd='1'THEN
			xin4<=not xin3;
		END IF;
		IF negy_rd='1'THEN
			yin4<=not yin3;
		END IF;
		
	END PROCESS invs;
	
--Combinational logic for xbias and swapxy
	xbias_d<=xbias xor swapxy;
	
END ARCHITECTURE comb;
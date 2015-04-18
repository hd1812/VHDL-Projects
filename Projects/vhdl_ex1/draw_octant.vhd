LIBRARY IEEE;

USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY draw_octant IS
  PORT(
    clk, resetx, draw, xbias,disable : IN  std_logic;
    xin, yin                 		 : IN  std_logic_vector(11 DOWNTO 0);
    done                       	     : OUT std_logic;
    x, y                  		     : OUT std_logic_vector(11 DOWNTO 0)
    );
END ENTITY draw_octant;

ARCHITECTURE comb OF draw_octant IS

  SIGNAL done1                    : std_logic;
  SIGNAL x1, y1                   : std_logic_vector(11 DOWNTO 0);
  SIGNAL xincr, yincr, xnew, ynew : std_logic_vector(11 DOWNTO 0);
  SIGNAL error                    : std_logic_vector(11 DOWNTO 0);
  SIGNAL err1, err2               : std_logic_vector(12 DOWNTO 0);

  ALIAS slv IS std_logic_vector;

BEGIN
	
  C1 : PROCESS(error, xincr, yincr, x1, y1, xnew, ynew, resetx, draw)

    VARIABLE err1_v, err2_v : std_logic_vector(12 DOWNTO 0);
    
  BEGIN
    
    err1_v := slv(abs(signed(resize(signed(error),13)) + signed(resize(unsigned(yincr),13))));     --abs only works for signed number
    
    err2_v := slv(abs(signed(resize(signed(error),13)) + signed(resize(unsigned(yincr),13)) - signed(resize(unsigned(xincr),13))));  --yincr and xincr is the amout of difference, which should be unsigned, while error should be signed
     
    IF x1=xnew AND y1=ynew AND resetx='0' AND draw = '0'THEN
        done1<='1';
	ELSE
		done1<='0';
    END IF;
	
	err1 <= err1_v;		--connect to output port
	err2 <= err2_v;

  END PROCESS C1;   --x1,y1 is pre-output to read

  R1 : PROCESS		--Translate the truth table into nested if statements
  BEGIN
	
	WAIT UNTIL clk'EVENT and clk = '1'; 
	IF disable='0' THEN
		IF resetx='1' THEN
			error<=(OTHERS=>'0');
			x1<=xin; 
			y1<=yin; 
			xnew<=xin; 
			ynew<=yin;
			xincr<=(OTHERS=>'0');
			yincr<=(OTHERS=>'0');
		ELSIF draw='1' THEN
			error<=(OTHERS=>'0');
			x1<=x1; 
			y1<=y1; 
			xincr<= slv(signed(xin)-signed(x1)); 
			yincr<= slv(signed(yin)-signed(y1));
			xnew<=xin; 
			ynew<=yin;
		ELSIF done1='0' THEN
			IF err1=err2 THEN
				IF xbias='1' THEN
					error<=slv(signed(error)+signed(yincr));
					x1<=slv(signed(x1)+1);
					y1<=y1;
				ELSE	
					error<=slv(signed(error)+signed(yincr)-signed(xincr));
					x1<=slv(signed(x1)+1);
					y1<=slv(signed(y1)+1);
				END IF;
			ELSIF err1<err2 THEN		
				error<=slv(signed(error)+signed(yincr));
				x1<=slv(signed(x1)+1);
				y1<=y1;
			ELSIF err1>err2 THEN
				error<=slv(signed(error)+signed(yincr)-signed(xincr));
				x1<=slv(signed(x1)+1);
				y1<=slv(signed(y1)+1);
			END IF;
		END IF;
	END IF;
	

  END PROCESS R1;
  
  	done<=done1;		--connect output ports to variable defined in block
	x<=x1;
	y<=y1;
	
END ARCHITECTURE comb;


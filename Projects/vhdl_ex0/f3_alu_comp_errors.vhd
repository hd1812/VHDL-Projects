LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;  -- add +,- on signed, unsigned


ENTITY f3_alu IS
   PORT(
      clk,reset : IN  STD_LOGIC;                 -- register clock
      y   : IN  STD_LOGIC_VECTOR( 15 DOWNTO 0);  -- alu y data input
      f   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);    -- alu function select inputs
      z   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)    -- alu register output
      );
END f3_alu;

ARCHITECTURE rtl OF f3_alu IS

  SIGNAL z_int, y1, x : STD_LOGIC_VECTOR(15 DOWNTO 0);

  ALIAS usg  IS unsigned;
  ALIAS slv IS std_logic_vector;
   
BEGIN



   ALU : PROCESS(y, z_int, f, y1)
   BEGIN
      CASE f  IS
         WHEN "000"|"100" =>
            x <= y1 AND z_int;
         WHEN "001"|"101" =>
            x <= y1 OR z_int;
         WHEN "010"|"110" =>
            x <= y1 XNOR z_int;
         WHEN "011" =>
            x <= slv( usg(y1) + usg(z_int));
         WHEN "111" =>
            x <= slv( usg(y1) - usg(z_int));
         WHEN OTHERS => NULL;
      END CASE;
          -- y1 is used internally, and is either y or complement of y.
      CASE f IS
         WHEN "100"|"101"|"110" => y1 <= NOT y;
         WHEN OTHERS =>  y1 <= y;
      END CASE;
   


   END PROCESS ALU;



   REG : PROCESS
   BEGIN     
      WAIT UNTIL clk'EVENT AND clk = '1';
      IF reset = '1' THEN
        z_int <= (OTHERS=>'0');
      ELSE
        z_int <= x;
      END IF;
   END PROCESS REG;

   -- keep z separate since can't read an output
   z <= z_int;
   
END rtl;

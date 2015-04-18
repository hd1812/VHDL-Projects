LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;               -- add unsigned, signed
USE work.ALL;


ENTITY f3_alu_tb IS
END f3_alu_tb;



ARCHITECTURE testbench OF f3_alu_tb IS

  
  SIGNAL clk, reset : std_logic;

  SIGNAL x_i, y_i : std_logic_vector(15 DOWNTO 0);
  SIGNAL f_i      : std_logic_vector(2 DOWNTO 0);
  SIGNAL z_i      : std_logic_vector(15 DOWNTO 0);

  SIGNAL result  : std_logic_vector(15 DOWNTO 0);
  SIGNAL result1 : integer;

  ALIAS slv IS std_logic_vector;
  
BEGIN
  dut : ENTITY f3_alu
    PORT MAP (
      clk   => clk,
      reset => reset,
      y     => y_i,
      f     => f_i,
      z     => z_i);

  p1_clkgen : PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR 50 ns;
    clk <= '1';
    WAIT FOR 50 ns;
  END PROCESS p1_clkgen;


  p2_rstgen : PROCESS
  BEGIN
    reset <= '1';
    WAIT UNTIL clk'event AND clk = '1';
    reset <= '0';
    WAIT;                               -- wait forever (don't want to loop!)
  END PROCESS p2_rstgen;


  p3_test : PROCESS
    -- test f3_alu;
    TYPE test_rec_type IS
    RECORD
      y      : integer;                       -- signed integer for y input
      f      : std_logic_vector(2 DOWNTO 0);  -- f3_alu operation
      result : integer;                       --signed integer result
    END RECORD;

    TYPE test_table_type IS ARRAY (natural RANGE <>) OF test_rec_type;

    CONSTANT test_table : test_table_type := (
      -- AND  OR   XNOR  +  NAND NOR XNOR  -
      -- 000  001  010  011 100  101 110  111
      -- 
      (y => 3, f => "011", result=>3),
      (y => 13, f => "111", result=> 10),
      (y => 0, f => "000", result=>0),
      (y => 123, f => "001", result=>123)
      );
  BEGIN

    WAIT UNTIL reset'event AND reset = '0';
    -- after reset
    FOR n IN test_table'range LOOP
      y_i <= slv(to_signed(test_table(n).y, 16));
      f_i <= test_table(n).f;
      REPORT "Starting Test " & integer'image(n) &
        ", Y=" & integer'image(test_table(n).y) &
        ", F=" & integer'image(to_integer(unsigned(test_table(n).f)));
      
      WAIT UNTIL clk'event AND clk = '1';  -- enter data
      WAIT UNTIL clk'event AND clk = '0';  -- wait till data from next cycle is OK
      -- process the result
      result  <= z_i;
      result1 <= to_integer(signed(z_i));
      WAIT FOR 0 ns;                    -- update result & result1
      IF result1 = test_table(n).result THEN
        REPORT "test " & integer'image(n) & " PASSED.";
      ELSE
        REPORT "test " & integer'image(n) & " FAILED." &
          " Z is " & integer'image(result1) &
          ", should be " & integer'image(test_table(n).result)
          SEVERITY error;
      END IF;

    END LOOP;  -- n


    -- only way to stop Modelsim at end is using a failure assert
    -- this leads to a 'failure' message when everything is OK. ;)
    --
    REPORT "All tests finished OK, terminating with failure ASSERT."
      SEVERITY failure;
    
  END PROCESS p3_test;
  
  
  

  
END testbench;



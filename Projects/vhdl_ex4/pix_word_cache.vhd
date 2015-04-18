LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE work.pix_cache_pak.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pix_word_cache IS
PORT(
        SIGNAL clk,reset, pw, wen_all : IN std_logic;
        SIGNAL pixnum           : IN std_logic_vector(3 DOWNTO 0);
        SIGNAL pixopin          : IN pixop_t;
        SIGNAL store            : OUT store_t;
        SIGNAL is_same          : OUT std_logic
);
END pix_word_cache;

ARCHITECTURE behav OF pix_word_cache IS
  
  SIGNAL opout,opram            :pixop_t;
  SIGNAL rdout_par                      :store_t;
  CONSTANT all_same                     :store_t :=(OTHERS=>psame);
BEGIN

--module named change
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

--ram implementation
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
        
END PROCESS store_ram;

--combinational logic for is_same, opram and store
same: PROCESS(rdout_par)
BEGIN
        is_same<='0';
        IF rdout_par = all_same THEN
        is_same<='1';
END IF;
END PROCESS same;
opram<=rdout_par(to_integer(unsigned(pixnum)));
store<=rdout_par;

END behav;
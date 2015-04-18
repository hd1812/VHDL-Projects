USE WORK.config_pack.ALL;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE project_pack IS

--pix_cache_pak
  TYPE pixop_t IS ARRAY (1 DOWNTO 0) OF std_logic;

  CONSTANT psame   : pixop_t := "00";
  CONSTANT pblack  : pixop_t := "10";
  CONSTANT pwhite  : pixop_t := "01";
  CONSTANT pinvert : pixop_t := "11";

  TYPE store_t IS ARRAY (0 TO 15) OF pixop_t;
  
 --project pack 
	CONSTANT RAM_WORD_SIZE : INTEGER := 16; -- fixed for this project could be changed by other applications

	TYPE db_2_rcb IS RECORD             -- possible type for interface from DB to RCD. Change as required
		X, Y     : std_logic_vector(VSIZE - 1 DOWNTO 0);
		rcb_cmd  : std_logic_vector(2 DOWNTO 0);
		startcmd : std_logic;
	END RECORD;

--type conversion
FUNCTION slv2pixop (p : std_logic_vector(1 DOWNTO 0)) RETURN pixop_t;
FUNCTION slv2store(p:std_logic_vector (31 DOWNTO 0))RETURN store_t;
	
FUNCTION pixop2slv(p:pixop_t)RETURN std_logic_vector;
FUNCTION store2slv(p:store_t)RETURN std_logic_vector;
	
END PACKAGE project_pack;


PACKAGE BODY project_pack IS

FUNCTION slv2pixop(p :std_logic_vector(1 DOWNTO 0)) RETURN pixop_t IS
	VARIABLE result:pixop_t;
BEGIN
	CASE p IS
		WHEN "10"=>result:=pblack;
		WHEN "01"=>result:=pwhite;
		WHEN "11"=>result:=pinvert;
		WHEN OTHERS=> result:=psame;
	END CASE;
RETURN result;
END FUNCTION slv2pixop;


FUNCTION slv2store(p :std_logic_vector(31 DOWNTO 0)) RETURN store_t IS
	VARIABLE result:store_t;
BEGIN
	FOR i in 0 to 15 loop
		result(i):=slv2pixop(p(2*i+1 DOWNTO 2*i));
	END LOOP;
RETURN result;
END FUNCTION slv2store;


FUNCTION pixop2slv(p :pixop_t) RETURN std_logic_vector IS
	VARIABLE result:std_logic_vector(1 DOWNTO 0);
BEGIN
	CASE p IS
		WHEN pblack=>result:="10";
		WHEN pwhite=>result:="01";
		WHEN pinvert=>result:="11";
		WHEN psame=> result:="00";
		WHEN OTHERS=>NULL;
	END CASE;
RETURN result;
END FUNCTION pixop2slv;


FUNCTION store2slv(p :store_t) RETURN std_logic_vector IS
	VARIABLE result:std_logic_vector(31 DOWNTO 0);
BEGIN
	FOR i in 0 to 15 loop
		result(2*i+1 DOWNTO 2*i):=pixop2slv(p(i));
	END LOOP;
RETURN result;
END FUNCTION store2slv;


END PACKAGE BODY;
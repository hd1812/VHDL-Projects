-- top-level Vector Display Processor
-- this file is fully synthesisable
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE work.project_pack.ALL;
USE work.config_pack.ALL;

USE work.ALL;

ENTITY vdp IS
	PORT(
		clk      : IN  std_logic;
		reset    : IN  std_logic;
		-- bus from host
		hdb      : IN  STD_LOGIC_VECTOR(VSIZE * 2 + 3 DOWNTO 0);
		dav      : IN  STD_LOGIC;
		hdb_busy : OUT STD_LOGIC;

		-- bus to VRAM
		vdin     : OUT STD_LOGIC_VECTOR(RAM_WORD_SIZE - 1 DOWNTO 0);
		vdout    : IN  STD_LOGIC_VECTOR(RAM_WORD_SIZE - 1 DOWNTO 0);
		vaddr    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- open port, exact size depends on VSIZE
		vwrite   : OUT STD_LOGIC;

		-- to testbench
		finish   : OUT std_logic
	);
END vdp;

ARCHITECTURE rtl OF vdp IS

  SIGNAL dbb : db_2_rcb;
  SIGNAL dbb_delaycmd, dbb_rcbclear, db_finish, rcb_finish : STD_LOGIC;

BEGIN
  
d1: ENTITY work.db 
  PORT MAP(
		clk          => clk,
		reset        => reset,

		-- host processor connections
		hdb          => hdb,
		dav          => dav,
		hdb_busy     => hdb_busy,

		-- rcb connections
		dbb_bus          => dbb,
		dbb_delaycmd => dbb_delaycmd,
		dbb_rcbclear => dbb_rcbclear,

		-- vdp connection
		db_finish    => db_finish
	);

r1: ENTITY work.rcb
  PORT MAP(
		clk     => clk,
		reset   => reset,

		-- bus to DB
		x          => dbb.x,
		y          => dbb.y,
		rcbcmd     => dbb.rcb_cmd,
		startcmd   => dbb.startcmd,
		dbb_delaycmd => dbb_delaycmd,
		dbb_rcbclear => dbb_rcbclear,

		-- signal to testbench
		rcb_finish   => rcb_finish,
		-- bus to VRAM
		vdin         => vdin,
		vdout        => vdout,
		vaddr        => vaddr, -- open port, exact size depends on VSIZE
		vwrite       => vwrite
	);
	
finish <= rcb_finish and db_finish;
END rtl;      



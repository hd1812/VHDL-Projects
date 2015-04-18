vsim  work.vdp_testbench
radix unsigned
view *
add wave sim:/vdp_testbench/*
add wave sim:/vdp_testbench/dut/*
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/vdout
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/vdin
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/vaddr
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/pw
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/wen_all
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/pixnum
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/pixopin
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/is_same
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/opout
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/opram
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/rdout_par
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/start
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/delay
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/state
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/nstate
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/xin
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/yin
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/word_num_new
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/word_num_old
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/same_word
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/clrx_reg
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/clry_reg
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/clrxy_new_reg
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/clrxy_old_reg
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/delaycmd
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/scan_done
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/rstate
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/nrstate
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/timer
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/cmd_slv
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/ram_in_slv
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/p1
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/p2
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/draw_or_clear
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/is_clear
add wave -noupdate /vdp_testbench/DUT/rcb_block/a1/clk
-- simulation will stop at end of test
run -all
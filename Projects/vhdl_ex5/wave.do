vsim  work.vdp_testbench
radix unsigned
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vdp_testbench/hdb_i
add wave -noupdate /vdp_testbench/dav_i
add wave -noupdate /vdp_testbench/hdb_busy_i
add wave -noupdate /vdp_testbench/vdin_i
add wave -noupdate /vdp_testbench/vdout_i
add wave -noupdate /vdp_testbench/vaddr_i
add wave -noupdate /vdp_testbench/vwrite_i
add wave -noupdate /vdp_testbench/cycle_init
add wave -noupdate /vdp_testbench/cycle_done
add wave -noupdate /vdp_testbench/trace_commands
add wave -noupdate /vdp_testbench/clk_i
add wave -noupdate /vdp_testbench/reset_i
add wave -noupdate /vdp_testbench/finish_i
add wave -noupdate /vdp_testbench/DUT/vdin
add wave -noupdate /vdp_testbench/DUT/vdout
add wave -noupdate /vdp_testbench/DUT/vaddr
add wave -noupdate /vdp_testbench/DUT/dbb
add wave -noupdate /vdp_testbench/DUT/dbb_delaycmd
add wave -noupdate /vdp_testbench/DUT/dbb_rcbclear
add wave -noupdate /vdp_testbench/DUT/db_finish
add wave -noupdate /vdp_testbench/DUT/rcb_finish
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12427833 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {12421654 ns} {12437833 ns}
run -all
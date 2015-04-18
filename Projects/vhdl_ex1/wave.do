vcom -93 -explicit -work work ex1_data_pak.vhd
vcom -93 -explicit -work work draw_octant.vhd
vcom -93 -explicit -work work draw_octant_tb.vhd

restart

view wave

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /draw_octant_tb/clk_gen
add wave -noupdate /draw_octant_tb/clk
add wave -noupdate /draw_octant_tb/reset_i
add wave -noupdate /draw_octant_tb/draw_i
add wave -noupdate /draw_octant_tb/xbias_i
add wave -noupdate /draw_octant_tb/done_i
add wave -noupdate /draw_octant_tb/disable_i
add wave -noupdate /draw_octant_tb/xin_i
add wave -noupdate /draw_octant_tb/yin_i
add wave -noupdate /draw_octant_tb/x_i
add wave -noupdate /draw_octant_tb/y_i
add wave -noupdate /draw_octant_tb/counter
add wave -noupdate /draw_octant_tb/dut/xin
add wave -noupdate /draw_octant_tb/dut/yin
add wave -noupdate /draw_octant_tb/dut/x
add wave -noupdate /draw_octant_tb/dut/y
add wave -noupdate /draw_octant_tb/dut/done1
add wave -noupdate /draw_octant_tb/dut/x1
add wave -noupdate /draw_octant_tb/dut/y1
add wave -noupdate /draw_octant_tb/dut/xincr
add wave -noupdate /draw_octant_tb/dut/yincr
add wave -noupdate /draw_octant_tb/dut/xnew
add wave -noupdate /draw_octant_tb/dut/ynew
add wave -noupdate /draw_octant_tb/dut/error
add wave -noupdate /draw_octant_tb/dut/err1
add wave -noupdate /draw_octant_tb/dut/err2
add wave -noupdate /draw_octant_tb/dut/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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

run -all


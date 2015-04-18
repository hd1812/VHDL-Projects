vcom -93 -explicit -work work ex4_data_pak.vhd
vcom -93 -explicit -work work draw_any_octant.vhd
vcom -93 -explicit -work work draw_any_octant_tb_generic.vhd

restart

view wave

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /draw_any_octant_tb/clk_gen
add wave -noupdate -radix decimal /draw_any_octant_tb/clk
add wave -noupdate -radix decimal /draw_any_octant_tb/resetx_i
add wave -noupdate -radix decimal /draw_any_octant_tb/draw_i
add wave -noupdate -radix decimal /draw_any_octant_tb/xbias_i
add wave -noupdate -radix decimal /draw_any_octant_tb/done_i
add wave -noupdate -radix decimal /draw_any_octant_tb/disable_i
add wave -noupdate -radix decimal /draw_any_octant_tb/xin_i
add wave -noupdate -radix decimal /draw_any_octant_tb/yin_i
add wave -noupdate -radix decimal /draw_any_octant_tb/x_i
add wave -noupdate -radix decimal /draw_any_octant_tb/y_i
add wave -noupdate -radix decimal /draw_any_octant_tb/swapxy_i
add wave -noupdate -radix decimal /draw_any_octant_tb/negx_i
add wave -noupdate -radix decimal /draw_any_octant_tb/negy_i
add wave -noupdate -radix hexadecimal /draw_any_octant_tb/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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

run -all

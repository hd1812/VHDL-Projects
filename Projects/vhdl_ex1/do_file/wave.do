onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /draw_octant/clk
add wave -noupdate /draw_octant/resetx
add wave -noupdate /draw_octant/draw
add wave -noupdate /draw_octant/xbias
add wave -noupdate /draw_octant/disable
add wave -noupdate -radix decimal /draw_octant/xin
add wave -noupdate -radix decimal /draw_octant/yin
add wave -noupdate /draw_octant/done
add wave -noupdate -radix decimal /draw_octant/x
add wave -noupdate -radix decimal /draw_octant/y
add wave -noupdate /draw_octant/done1
add wave -noupdate -radix decimal /draw_octant/x1
add wave -noupdate -radix decimal /draw_octant/y1
add wave -noupdate -radix decimal /draw_octant/xincr
add wave -noupdate -radix decimal /draw_octant/yincr
add wave -noupdate -radix decimal /draw_octant/xnew
add wave -noupdate -radix decimal /draw_octant/ynew
add wave -noupdate -radix decimal /draw_octant/error
add wave -noupdate -radix decimal /draw_octant/err1
add wave -noupdate -radix decimal /draw_octant/err2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {454 ns} 0}
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
WaveRestoreZoom {0 ns} {1 us}

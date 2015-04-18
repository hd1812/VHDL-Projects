vcom -93 -explicit -work work ram_fsm.vhd
vcom -93 -explicit -work work ram_fsm_wrapper.vhd
vcom -93 -explicit -work work ram_fsm_tb.vhd

view
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /ram_fsm_tb/z
add wave -noupdate -radix decimal /ram_fsm_tb/clk
add wave -noupdate -radix decimal /ram_fsm_tb/reset_hard
add wave -noupdate -radix decimal /ram_fsm_tb/reset
add wave -noupdate -radix decimal /ram_fsm_tb/reset_i
add wave -noupdate -radix decimal /ram_fsm_tb/start_i
add wave -noupdate -radix decimal /ram_fsm_tb/delay_i
add wave -noupdate -radix decimal /ram_fsm_tb/vwrite_i
add wave -noupdate -radix decimal /ram_fsm_tb/estate
add wave -noupdate -radix decimal /ram_fsm_tb/addr_i
add wave -noupdate -radix decimal /ram_fsm_tb/addr_del_i
add wave -noupdate -radix decimal /ram_fsm_tb/data_i
add wave -noupdate -radix decimal /ram_fsm_tb/data_del_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {194 ns} 0}
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
WaveRestoreZoom {0 ns} {910 ns}
run -all
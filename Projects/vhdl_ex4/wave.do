vcom -93 -explicit -work work pix_tb_pak.vhd
vcom -93 -explicit -work work ex4_data_pak.vhd
vcom -93 -explicit -work work pix_cache_pak.vhd
vcom -93 -explicit -work work pix_word_cache.vhd
vcom -93 -explicit -work work pix_word_cache_tb.vhd


restart

view wave

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pix_word_cache_tb/reset
add wave -noupdate /pix_word_cache_tb/pw
add wave -noupdate /pix_word_cache_tb/is_same
add wave -noupdate /pix_word_cache_tb/wen_all
add wave -noupdate /pix_word_cache_tb/pixnum
add wave -noupdate /pix_word_cache_tb/pixopin
add wave -noupdate /pix_word_cache_tb/store
add wave -noupdate /pix_word_cache_tb/Clk
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
WaveRestoreZoom {0 ns} {1 us}

run -all
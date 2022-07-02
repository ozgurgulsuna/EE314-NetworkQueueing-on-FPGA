onerror {exit -code 1}
vlib work
vlog -work work button_test.vo
vlog -work work Waveform.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.button_test_vlg_vec_tst -voptargs="+acc"
vcd file -direction button_test.msim.vcd
vcd add -internal button_test_vlg_vec_tst/*
vcd add -internal button_test_vlg_vec_tst/i1/*
run -all
quit -f

onerror {exit -code 1}
vlib work
vlog -work work verilog_outlines.vo
vlog -work work debouncer_sim.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.debouncer_vlg_vec_tst -voptargs="+acc"
vcd file -direction verilog_outlines.msim.vcd
vcd add -internal debouncer_vlg_vec_tst/*
vcd add -internal debouncer_vlg_vec_tst/i1/*
run -all
quit -f

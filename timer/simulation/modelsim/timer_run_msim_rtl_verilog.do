transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/timer {C:/intelFPGA_lite/18.1/timer/timer.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/timer {C:/intelFPGA_lite/18.1/timer/sec_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/ktane_mem {C:/intelFPGA_lite/18.1/ktane_mem/bcd_to_sevseg.v}


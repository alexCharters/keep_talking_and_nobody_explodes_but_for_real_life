transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/wire_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/timer.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/sec_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/rgb_led.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/mux5.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/morse_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/ktane_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/keypad_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/I2C.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/extras_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/divider.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/button_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/bcd_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/mux4to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/mux2to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ALUControl.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ZeroExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/InstructionRegister.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/alex-stuff/oleds.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/BlockRam.v}


transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/wire_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/timer.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/sec_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/rgb_led.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/mux5.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/morse_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/ktane_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/keypad_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/I2C.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/extras_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/divider.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/button_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/bcd_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/adc.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ALUController.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/InstructionRegister.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/mux2to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/mux4to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/ZeroExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/PSR.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/adc_ltc2308.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/morse_blink.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/oleds.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/IO/BlockRam.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/keep_talking_and_nobody_explodes_but_for_real_life/InstructionMem.v}


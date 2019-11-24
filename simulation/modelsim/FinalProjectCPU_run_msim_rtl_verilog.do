transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

<<<<<<< HEAD
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/ALUController.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/InstructionRegister.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/StorageRam.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/mux2to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/mux4to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/ZeroExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/kenne/Documents/ECE\ 3710\ Final\ Project {C:/Users/kenne/Documents/ECE 3710 Final Project/InstructionMem.v}
=======
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/wire_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/timer.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/sec_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/rgb_led.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/mux5.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/morse_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/ktane_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/keypad_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/I2C.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/extras_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/divider.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/button_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/bcd_to_sevseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/ALUController.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/InstructionRegister.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/mux2to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/mux4to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/ZeroExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/oleds.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/IO/BlockRam.v}
vlog -vlog01compat -work work +incdir+C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life {C:/Users/alexc/OneDrive/Desktop/new_repo/keep_talking_and_nobody_explodes_but_for_real_life/InstructionMem.v}
>>>>>>> final/redoneCPU


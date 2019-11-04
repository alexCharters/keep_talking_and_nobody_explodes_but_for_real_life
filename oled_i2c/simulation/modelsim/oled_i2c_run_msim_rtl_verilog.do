transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/I2C {C:/intelFPGA_lite/18.1/I2C/I2C.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/oled_i2c/output_files {C:/intelFPGA_lite/18.1/oled_i2c/output_files/divider.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/oled_i2c {C:/intelFPGA_lite/18.1/oled_i2c/oled_i2c.v}


    #Wires setup
    movi 0, r3
    movi 0, r4
    movi 0, r5
    #step 1 get value from ch0
    moviw 0xD800, r1 #get addr from adc0
    LOAD r6, r1 #adc read
    moviw 0xD900, r2 #get addr for adc1
    LOAD r7, r2
    #
    #we need to go through each possible wire combo
    cmpi 10, r6 # is ch0 white?
    JGT wire1
    mov r1, r3 #yes put the address for ch0 into r3
wire1:   cmpi 100, r6
    JGT wire2
    mov r1, r4 #yes put the address for ch0 into r4
wire2:   mov r1, r5 #if nothing else this is probably blue

    cmpi 10, r7 # is ch1 white?
    JGT wire3
    mov r1, r3 #yes put the address for ch1 into r3
wire3:    cmpi 100, r7
    JGT wire4
    mov r1, r4 #yes put the address for ch1 into r4
wire4:    mov r1, r5 #if nothing else this is probably blue

# r3, r4, and r5 should hold the adc address for a white, orange, 
# and blue wire respectively. Now we must determine the state from this
# 0xACDC in memory will hold the adc address of the wire you need to pull
    moviw 0xACDC, r8
    moviw 0xACDD, r9
# do I have a white wire?
    CMPI 0, r3
    JEQ nowhite
    CMPI 0, r4 # do I have an orange
    JEQ whtandblu
    STOR r3, r8
    stor r4, r9
    JUC continue
nowhite: STOR r4, r8 # if no white then we have blu and orng, pull orange
    STOR r5, r9
whtandblu: STOR r5, r8
    STOR r3, r9

continue: or r0, r0
wires: MOVIW 0x0010, R13 #loads if this has passed already
    LOAD R1, R13 
    CMPi 0x0001, R1
    JEQ wires
    moviw 0xACDC, r8
    moviw 0xACDD, r9
    LOAD r9, r2
    CMPI 255, r2 # did they pull the wrong wire
    JEQ strike
    LOAD r8, r3
    CMPI 255, r3 # did they pull the right wire
    JEQ wirepass
    JUC wires
strike: movi 1, r4
    moviw 0xE400, r12
    LOAD r11, r12
    addi 1, r11
    stor r11, r12
wirepass: moviw 0x0010, r12
    movi 1, r11
    stor r11, r12
    JUC wires
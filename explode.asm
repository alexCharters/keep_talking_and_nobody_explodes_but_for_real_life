main: OR R0, R0
JAL setup
mloop: OR R0, R0 #main loop that will repeat until completion
MOVIW 0xBBBB, R13 #loads # passed modules
LOAD R1, R13
CMPi 4, R1 #while( )
JEQ ending #while is done and jumps to ending sequence
JAL button
JAL wires
JAL passcode
JAL morsecode
JUC mloop
setup: OR R0, R0
MOVIW 0xC000, r1 #write to button
MOVIW 1, r2
STOR r2, r1
MOVIW 0xC200, r1 #write to button color
MOVIW 0xFFFF, r2
STOR r2, r1
MOVIW 0xC400, r1 #write to strip color
MOVIW 0x001F, r2
STOR r2, r1
MOVIW 0xC800, r1 #write to all keypad LED's
MOVIW 1, r2
STOR r2, r1
MOVIW 0xC900, r1
MOVIW 1, r2
STOR r2, r1
MOVIW 0xCA00, r1
MOVIW 1, r2
STOR r2, r1
MOVIW 0xCB00, r1
MOVIW 1, r2
STOR r2, r1
MOVIW 0xCC00, r1 #write to glyph1
MOVIW 2, r2
STOR r2, r1
MOVIW 0xCE00, r1 #write to glyph3
MOVIW 4, r2
STOR r2, r1 #must wait about 327,675â€¬ cycles between a write to glyph1 then glyph2 or glyph3 then glyph4
MOVIW 5, r3
BUSYLOOP: OR r0, r0
MOVIW 0xFFFF, r4
BUSYWAIT: OR r0, r0
SUBI 1, r4
CMP r4, r0
JNE BUSYWAIT
SUBI 1, r3
CMP r3, r0
JNE BUSYLOOP
MOVIW 0xCD00, r1 #write to glyph2
MOVIW 3, r2
STOR r2, r1
MOVIW 0xCF00, r1 #write to glyph4
MOVIW 5, r2
STOR r2, r1 #write to morse sev-segs bits 7:4 is left number, bits 3:0 is right number
MOVIW 0xD000, r1
MOVIW 0x0025, r2
STOR r2, r1
MOVIW 0xD400, r1 #write to morse (not totally finished)
MOVIW 5, r2
STOR r2, r1
MOVIW 0xE000, r1 #write to timer (in seconds)
MOVIW 180, r2
STOR r2, r1
MOVIW 0xE400, r1 #write to strikes (in seconds)
MOVIW 1, r2
STOR r2, r1
JUC R14
button: OR R0, R0
MOVIW 0x0000, R13 #address of save if complete
MOVIW 0x0001, R12 #a one in for a cmp
LOAD R1, R13 #load from address in r13
CMP R1, R12 #is this module already complete?
JEQ R14 #yes leave, no procede
MOVIW 0x0001, R13 #load address for button pushed last time
MOVIW 0xC000, R12 #i/o read on button
LOAD R1, R13
LOAD R2, R12
MOVIW 0x0001, R3
CMP R2, R3 #is the button pushed?
JLT letgo #nope move along
CMP R1, R2 #it is pushed
JNE buttonpushed #it was not previously pushed
JUC buttonheld #previously pushed
letgo: OR R0, R0
CMP R1, R3 #held before but now let go of
JLT check
JUC R14
buttonpushed: OR R0, R0
MOVIW 0xF330, R13
MOVIW 0x0001, R12
MOVIW 0xC000, R11
MOVIW 0xE000, R10
LOAD R13, R3 #load in the time
STOR R11, R12 #store the button being pushed
STOR R3, R10 #store time when button first pushed
JUC R14
buttonheld: OR R0, R0
JUC R14
check: OR R0, R0
MOVIW 0x0001, R13
MOVIW 0xC000, R12
MOVIW 0xF330, R11
MOVIW 0xE000, R10
STOR R13, R12 #stores not pressed into memory that remembers that
LOAD R3, R10 #load in time button first pressed to r3
LOAD R4, R11 #load in the current time to r4
MOV R4, R5
SUB R3, R5
CMP R5, 3 #the answer to this test version is always hold the button for three seconds
BEQ 6
MOVIW 0xE400, R9 #address to failure
LOAD R1, R9
ADDi 1, R1
STOR R1, R9 #record failure
JUC R14
wires: OR R0, R0
JUC R14
passcode: OR R0, R0
JUC R14
morsecode: OR R0, R0
JUC R14
ending: OR R0, R0 #the end

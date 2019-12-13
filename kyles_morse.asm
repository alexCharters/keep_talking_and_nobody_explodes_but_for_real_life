main: OR R0, R0
JAL setup
mloop: OR R0, R0 #main loop that will repeat until completion
JAL morsecode
JUC mloop


morsecode: OR R0, R0
MOVIW 0x0040, R13 #loads if this has passed already
LOAD R1, R13 
CMPi 0x0001, R1
BNE 4
JUC R14
up: OR R0, R0
MOVIW 0x0042, R13 #button held last time save
MOVIW 0xC200, R12 #io for up button
LOAD R2, R13 # was button held last time
LOAD R4, R12 #i/o read on button
CMP 0x0001, R4 #is the button pushed?
JLT moveup #nope move along
CMP R2, R4 #it is pushed
BNE 3 #it was not previously pushed
JUC R14 #previously pushed

MOV r14, r5
JAL WAIT
MOV r5, r14


MOVIW 1, R1
STOR R1, R13 #saves that this button was pushed
JUC R14
down: OR R0, R0
MOVIW 0x0043, R13 #button held last time save
MOVIW 0xC100, R12 #io for down button
LOAD R2, R13 # was button held last time
LOAD R4, R12 #i/o read on button
CMP R4, 1 #is the button pushed?
JLT movedown #nope move along
CMP R2, R4 #it is pushed
BNE 3 #it was not previously pushed
JUC R14 #previously pushed
MOVIW 1, R1
STOR R1, R13 #saves that this button was pushed
JUC R14
enter: OR R0, R0
MOVIW 0x0043, R13 #button held last time save
MOVIW 0xC300, R12 #io for enter button
LOAD R2, R13 # was button held last time
LOAD R4, R12 #i/o read on button
CMP R4, 1 #is the button pushed?
JLT mccheck #nope move along
CMP R2, R4 #it is pushed
BNE 3 #it was not previously pushed
JUC R14 #previously pushed
MOVIW 1, R1
STOR R1, R13 #saves that this button was pushed
JUC R14
mccheck: OR R0, R0
CMPi 0x0001, R2 #button held last time
JNE R14 #if not go away
STOR R0, R13 #button held last time now cleared
MOVIW 0x0045, R11
MOVIW 0x0044, R10
LOAD R5, R11 #load answer
LOAD R6, R10 #load user input
CMP R5, R6 #compare input to answer
BEQ 7 #correct
MOVIW 0xE400, R9
LOAD R7, R9 #failures
ADDi 1, R7 #add this failure
STOR R7, R9 #store the number of failures
MOVIW 0x0040, R8
LOAD R3, R8 #load passed
ADDi 1, R3 #this has now passed
STOR R3, R8 #save that it has passed
JUC R14
moveup: OR R0, R0
CMP 1, R2 #button held last time
JNE R14 #if not go away
STOR R0, R13 #button held last time now cleared
MOVIW 0x0044, R9 #my save for freq
MOVIW 0xD000, R8 #write to 7seg
LOAD R5, R9
LOAD R6, R8
ADDi 1, R5
STOR R5, R9
STOR R5, R9
JUC R14
movedown: OR R0, R0
CMP 1, R2 #button held last time
JNE R14 #if not go away
STOR R0, R13 #button held last time now cleared
MOVIW 0x0041, R9 #my save for freq
MOVIW 0xD000, R8 #write to 7seg
LOAD R5, R9
LOAD R6, R8
SUBi 1, R5
STOR R5, R9
STOR R5, R9
JUC R14



WAIT: NOPE
MOVIW 5, r3 #debouncing things I hope
BUSYLOOP: OR r0, r0
MOVIW 0xFFFF, r4
BUSYWAIT: OR r0, r0
SUBI 1, r4
CMP r4, r0
JNE BUSYWAIT
SUBI 1, r3
CMP r3, r0
JNE BUSYLOOP
JUC r14


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
MOVIW 10, r2
STOR r2, r1
MOVIW 0xCE00, r1 #write to glyph3
MOVIW 12, r2
STOR r2, r1
#must wait about 327,675â€¬ cycles between a write to glyph1 then glyph2 or glyph3 then glyph4
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
MOVIW 9, r2
STOR r2, r1
#write to morse sev-segs bits 7:4 is left number, bits 3:0 is right number
MOVIW 0xD000, r1
MOVIW 0x0025, r2
STOR r2, r1
MOVIW 0xD400, r1 #write to morse (not totally finished)
MOVIW 1, r2
STOR r2, r1
MOVIW 0xE000, r1 #write to timer (in seconds)
MOVIW 180, r2
STOR r2, r1
MOVIW 0xE400, r1 #write to strikes (in seconds)
MOVIW 1, r2
STOR r2, r1
JUC r14

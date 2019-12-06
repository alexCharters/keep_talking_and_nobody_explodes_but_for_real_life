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
MOVIW 0x0003, R8
CMP R5, R8 #the answer to this test version is always hold the button for three seconds
BEQ 6
MOVIW 0xE400, R9 #address to failure
LOAD R1, R9
ADDi 1, R1
STOR R1, R9 #record failure
JUC R14
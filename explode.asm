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
MOVIW 10, r2
STOR r2, r1
MOVIW 0xCE00, r1 #write to glyph3
MOVIW 12, r2
STOR r2, r1
#must wait about 327,675Ã¢â‚¬Â¬ cycles between a write to glyph1 then glyph2 or glyph3 then glyph4
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
MOVIW 5, r2
STOR r2, r1
MOVIW 0xE000, r1 #write to timer (in seconds)
MOVIW 180, r2
STOR r2, r1
MOVIW 0xE400, r1 #write to strikes (in seconds)
MOVIW 1, r2
STOR r2, r1
MOVIW 0x0045, R13
MOVIW 69, R12
STOR R12, R13
MOVIW 0x0021, R1 #answer to glyphs
MOVIW 0x0022, R2
MOVIW 0x0023, R3
MOVIW 0x0024, R4
MOVIW 3, R5
MOVIW 4, R6
MOVIW 2, R7
MOVIW 1, R8
STOR R5, R1
STOR R6, R2
STOR R7, R3
STOR R8, R4
JUC mloop
button: OR R0, R0
MOVIW 0x0000, R13 #address of save if complete
MOVIW 0x0001, R12 #a one in for a cmp
LOAD R1, R13 #load from address in r13
CMP R1, R12 #is this module already complete?
JEQ wires #yes leave, no procede
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
JUC wires
buttonpushed: OR R0, R0
MOVIW 0xF330, R13
MOVIW 0x0001, R12
MOVIW 0xC000, R11
MOVIW 0xE000, R10
LOAD R13, R3 #load in the time
STOR R11, R12 #store the button being pushed
STOR R3, R10 #store time when button first pushed
JUC wires
buttonheld: OR R0, R0
JUC wires
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
JUC wires
wires: OR R0, R0
JUC passcode
passcode: OR R0, R0
MOVIW 0x0020, R13 #loads if this has passed already
LOAD R1, R13
CMPi 1, R1
BNE 3
JUC morsecode
MOVIW 0x0025, R12 #number of entries when it hits 4 check answer
LOAD R12, R13 #13 is number of entries, 12 is address array calc
but1: OR R0, R0
MOVIW 0x002A, R11
MOVIW 0xC400, R10
LOAD R1, R11 # was button1 held last time
LOAD R2, R10 #i/o read on button
CMPi 1, R2 #is the button pushed?
BEQ 5 #yes move to logic
CMPi 1, R1 #no, but was it?
BNE 2 #yes zero it out, no move along
STOR R0, R11
JUC but2
CMP R1, R2 #it is pushed
BNE 2 #it was not previously pushed
JUC but2 #previously pushed
MOVIW 0x0001, R5
STOR R5, R11 #saves that this button was pushed
ADDi 1, R13
ADD R13, R12 #address of the array of answers
MOVIW 10, R11 #what button 1 is aka what glyph it is
LOAD R3, R11
STOR R3, R12 #stores first push in i[1] second in i[2] and so forth
but2: OR R0, R0
MOVIW 0x002B, R11
MOVIW 0xC500, R10
LOAD R1, R11 # was button1 held last time
LOAD R2, R10 #i/o read on button
CMPi 1, R2 #is the button pushed?
BEQ 5 #yes move to logic
CMPi 1, R1 #no, but was it?
BNE 2 #yes zero it out, no move along
STOR R0, R11
JUC but3
CMP R1, R2 #it is pushed
BNE 2 #it was not previously pushed
JUC but3 #previously pushed
MOVIW 0x0001, R5
STOR R5, R11 #saves that this button was pushed
ADDi 1, R13
ADD R13, R12 #address of the array of answers
MOVIW 3, R11 #what button 2 is aka what glyph it is
LOAD R3, R11
STOR R3, R12 #stores first push in i[1] second in i[2] and so forth
but3: OR R0, R0
MOVIW 0x002C, R11
MOVIW 0xC600, R10
LOAD R1, R11 # was button1 held last time
LOAD R2, R10 #i/o read on button
CMPi 1, R2 #is the button pushed?
BEQ 5 #yes move to logic
CMPi 1, R1 #no, but was it?
BNE 2 #yes zero it out, no move along
STOR R0, R11
JUC but4
CMP R1, R2 #it is pushed
BNE 2 #it was not previously pushed
JUC but4 #previously pushed
MOVIW 0x0001, R5
STOR R5, R11 #saves that this button was pushed
ADDi 1, R13
ADD R13, R12 #address of the array of answers
MOVIW 12, R11 #what button 3 is aka what glyph it is
LOAD R3, R11
STOR R3, R12 #stores first push in i[1] second in i[2] and so forth
but4: OR R0, R0
MOVIW 0x002D, R11
MOVIW 0xC700, R10
LOAD R1, R11 # was button1 held last time
LOAD R2, R10 #i/o read on button
CMPi 1, R2 #is the button pushed?
BEQ 5 #yes move to logic
CMPi 1, R1 #no, but was it?
BNE 2 #yes zero it out, no move along
STOR R0, R11
JUC passcodecheck
CMP R1, R2 #it is pushed
BNE 2 #it was not previously pushed
JUC passcodecheck #previously pushed
MOVIW 0x0001, R5
STOR R5, R11 #saves that this button was pushed
ADDi 1, R13
ADD R13, R12 #address of the array of answers
MOVIW 9, R11 #what button 4 is aka what glyph it is
LOAD R3, R11
STOR R3, R12 #stores first push in i[1] second in i[2] and so forth
passcodecheck: OR R0, R0
LOAD 0x0025, R8
STOR R13, R8
CMPi 4, R13 #4 means all entries tried
JNE morsecode
STOR R0, R8 #sets input # to 0
MOVIW 0x0026, R13 #input[1]
LOAD R1, R13
MOVIW 0x0021, R12 #answer[1]
LOAD R2, R12
CMP R1, R2 #input = answer?
BEQ 8
MOVIW 0xE400, R11 #address to failures
LOAD R1, R11
ADDi 1, R1 #failed this module
STOR R1, r11
JUC morsecode
MOVIW 0x0027, R13 #input[2]
LOAD R1, R13
MOVIW 0x0022, R12 #answer[2]
LOAD R2, R12
CMP R1, R2 #input = answer?
BEQ 8
MOVIW 0xE400, R11 #address to failures
LOAD R1, R11
ADDi 1, R1 #failed this module
STOR R1, r11
JUC morsecode
MOVIW 0x0028, R13 #input[3]
LOAD R1, R13
MOVIW 0x0023, R12 #answer[3]
LOAD R2, R12
CMP R1, R2 #input = answer?
BEQ 8
MOVIW 0xE400, R11 #address to failures
LOAD R1, R11
ADDi 1, R1 #failed this module
STOR R1, r11
JUC morsecode
MOVIW 0x0029, R13 #input[4]
LOAD R1, R13
MOVIW 0x0024, R12 #answer[4]
LOAD R2, r12
CMP R1, R2 #input = answer?
BEQ 8
MOVIW 0xE400, R11 #address to failures
LOAD R1, R11
ADDi 1, R1 #failed this module
STOR R1, r11
JUC morsecode
MOVIW 0x0020, R10 #module passed
LOAD R4, R10
ADDi 1, R4
STOR R4, R10 #module passed
JUC morsecode
morsecode: OR R0, R0
MOVIW 0x0040, R13 #loads if this has passed already
LOAD R1, R13
CMPi 0x0001, R1
BNE 4
JUC mloop
up: OR R0, R0
MOVIW 0x0042, R13 #button held last time save
MOVIW 0xC200, R12 #io for up button
LOAD R2, R13 # was button held last time
LOAD R4, R12 #i/o read on button
CMP 0x0001, R4 #is the button pushed?
JLT moveup #nope move along
CMP R2, R4 #it is pushed
BNE 3 #it was not previously pushed
JUC mloop #previously pushed
MOVIW 1, R1
STOR R1, R13 #saves that this button was pushed
JUC mloop
down: OR R0, R0
MOVIW 0x0043, R13 #button held last time save
MOVIW 0xC100, R12 #io for down button
LOAD R2, R13 # was button held last time
LOAD R4, R12 #i/o read on button
CMP R4, 1 #is the button pushed?
JLT movedown #nope move along
CMP R2, R4 #it is pushed
BNE 3 #it was not previously pushed
JUC mloop #previously pushed
MOVIW 1, R1
STOR R1, R13 #saves that this button was pushed
JUC mloop
enter: OR R0, R0
MOVIW 0x0043, R13 #button held last time save
MOVIW 0xC300, R12 #io for enter button
LOAD R2, R13 # was button held last time
LOAD R4, R12 #i/o read on button
CMP R4, 1 #is the button pushed?
JLT mccheck #nope move along
CMP R2, R4 #it is pushed
BNE 3 #it was not previously pushed
JUC mloop #previously pushed
MOVIW 1, R1
STOR R1, R13 #saves that this button was pushed
JUC mloop
mccheck: OR R0, R0
CMPi 0x0001, R2 #button held last time
JNE mloop #if not go away
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
JUC mloop
moveup: OR R0, R0
CMP 1, R2 #button held last time
JNE mloop #if not go away
STOR R0, R13 #button held last time now cleared
MOVIW 0x0044, R9 #my save for freq
MOVIW 0xD000, R8 #write to 7seg
LOAD R5, R9
LOAD R6, R8
ADDi 1, R5
STOR R5, R9
STOR R5, R9
JUC mloop
movedown: OR R0, R0
CMP 1, R2 #button held last time
JNE mloop #if not go away
STOR R0, R13 #button held last time now cleared
MOVIW 0x0041, R9 #my save for freq
MOVIW 0xD000, R8 #write to 7seg
LOAD R5, R9
LOAD R6, R8
SUBi 1, R5
STOR R5, R9
STOR R5, R9
JUC mloop
ending: OR R0, R0 #the end
setup: NOPE
MOVIW 0xE000, r1
MOVIW 69, r2
STOR r2, r1
MOVIW 0xE400, r1
MOVIW 0, r2
STOR r2, r1
MOVIW 0xC000, r1
MOVIW 2, r2
STOR r2, r1
MOVIW 0xD400, r1
MOVI 1, r2
STOR r2, r1
MOVIW 0xC200, r1
MOVI 0, r2
STOR r2, r1
MOVIW 0xC400, r1
MOVI 0, r2
STOR r2, r1
MOVIW 0xcb00, r1
MOVIW 1, r2
STOR r2, r1
JUC r14

#write to freq.
MOVIW 0xD000, r1
MOVIW 0x0065, r2
STOR r2, r1
MOVIW 0xBEEF, r1
STOR r2, r1

#write to success leds
MOVIW 0xc800, r1
MOVIW 0, r2
STOR r2, r1
MOVIW 0xc900, r1
STOR r2, r1
MOVIW 0xca00, r1
STOR r2, r1
MOVIW 0xcb00, r1
STOR r2, r1

main: NOPE
jal buttondownwait
jal morsecodestart
juc main




buttondownwait: NOPE
MOVIW 0xC000, r1
LOAD r2, r1
CMP r2, r0
JNE buttonreleasewait
JUC r14

buttonreleasewait: NOPE
MOVIW 0xE000 ,r1
LOAD r8, r1

MOV r14, r7
JAL WAIT
MOV r7, r14

buttonreleaseloop: NOPE
MOVIW 0xC000, r1
LOAD r2, r1
CMP r2, r0
JEQ checktime
JUC buttonreleaseloop

checktime: NOPE

MOV r14, r7
JAL WAIT
MOV r7, r14

MOVIW 0xE000, r1
LOAD r5, r1
SUB r5, r8
MOVIW 3, r6
CMP r4, r6
JEQ modonesucc
JUC writestrike





morsecodestart: NOPE
MOVIW 0xC100, r1
LOAD r2, r1
CMP r2, r0
JNE leftbuttonreleasewait
MOVIW 0xC200, r1
LOAD r2, r1
CMP r2, r0
JNE rightbuttonreleasewait
MOVIW 0xC300, r1
LOAD r2, r1
CMP r2, r0
JNE transmitreleasewait
JUC r14

leftbuttonreleasewait: NOPE

MOV r14, r7
JAL WAIT
MOV r7, r14

MOVIW 0xC100, r1
LOAD r2, r1
CMP r2, r0
JEQ decfreq
JUC leftbuttonreleasewait

rightbuttonreleasewait: NOPE

MOV r14, r7
JAL WAIT
MOV r7, r14

MOVIW 0xC200, r1
LOAD r2, r1
CMP r2, r0
JEQ incfreq
JUC rightbuttonreleasewait

transmitreleasewait: NOPE

MOV r14, r7
JAL WAIT
MOV r7, r14

transmitreleaseloop: NOPE
MOVIW 0xC300, r1
LOAD r2, r1
CMP r2, r0
JEQ checkfreq
JUC transmitreleaseloop

decfreq: NOPE
MOVIW 0xBEEF, r1
LOAD r2, r1
SUBI 1, r2
MOVIW 0xD000, r1 #write to freq.
STOR r2, r1
MOVIW 0xBEEF, r1
STOR r2, r1
JUC r14

incfreq: NOPE
MOVIW 0xBEEF, r1
LOAD r2, r1
ADDI 1, r2
MOVIW 0xD000, r1 #write to freq.
STOR r2, r1
MOVIW 0xBEEF, r1
STOR r2, r1
JUC r14


checkfreq: NOPE

MOV r14, r7
JAL WAIT
MOV r7, r14

MOVIW 0xBEEF, r1
LOAD r2, r1
MOVIW 0x0069, r1
CMPI 0x69, r2
JNE modtwosucc
JUC writestrike





WAIT: NOPE
MOVIW 5, r12
BUSYLOOP: OR r0, r0
MOVIW 0xFFFF, r13
BUSYWAIT: OR r0, r0
SUBI 1, r13
CMP r13, r0
JNE BUSYWAIT
SUBI 1, r12
CMP r12, r0
JNE BUSYLOOP
JUC r14





stoptimer: NOPE
MOVIW 0xE000, r1
STOR r0, r1
JUC stoptimer


writestrike: NOPE
MOVIW 0xE400, r1
LOAD r2, r1
ADDI 1, r2
STOR r2, r1
JUC r14


modonesucc: NOPE
MOVIW 0xc800, r1
MOVIW 1, r2
STOR r2, r1
JUC r14

modtwosucc: NOPE
MOVIW 0xc900, r1
MOVIW 1, r2
STOR r2, r1
JUC r14

modthreesucc: NOPE
MOVIW 0xca00, r1
MOVIW 1, r2
STOR r2, r1
JUC r14

modfoursucc: NOPE
MOVIW 0xcb00, r1
MOVIW 1, r2
STOR r2, r1
JUC r14

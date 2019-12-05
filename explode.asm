main: NOPE
JAL setup

#write to strikes (in seconds)
MOVIW 0xE400, r1
MOVIW 3, r2
STOR r2, r1



setup: NOPE
#write to button
MOVIW 0xC000, r1
MOVIW 30, r2
STOR r2, r1

#write to button color
MOVIW 0xC200, r1
MOVIW 0xFFFF, r2
STOR r2, r1

#write to strip color
MOVIW 0xC400, r1
MOVIW 0x001F, r2
STOR r2, r1

#write to all keypad LED's
MOVIW 0xC800, r1
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

#write to glyph1
MOVIW 0xCC00, r1
MOVIW 2, r2
STOR r2, r1

#write to glyph3
MOVIW 0xCE00, r1
MOVIW 2, r2
STOR r2, r1

#write to morse sev-segs bits 7:4 is left number, bits 3:0 is right number
MOVIW 0xD000, r1
MOVIW 0x0025, r2
STOR r2, r1

#write to morse (not totally finished)
MOVIW 0xD400, r1
MOVIW 5, r2
STOR r2, r1

MOVIW 0xC000, r2
LOAD r9, r2
CMP r9, r0
JEQ WRITETWOMIN
JNE WRITETHREEMIN

#write to timer (in seconds)
WRITETWOMIN:  OR r0, r0
MOVIW 0xE000, r1
MOVIW 120, r2
STOR r2, r1
JUC TIMERDONE

WRITETHREEMIN:  OR r0, r0
MOVIW 0xE000, r1
MOVIW 180, r2
STOR r2, r1

TIMERDONE: OR r0, r0
#write to strikes
MOVIW 0xE400, r1
MOVIW 1, r2
STOR r2, r1

#must wait about 327,675‬ cycles between a write to glyph1 then glyph2 or glyph3 then glyph4
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




#write to glyph2
MOVIW 0xCD00, r1
MOVIW 3, r2
STOR r2, r1

#write to glyph4
MOVIW 0xCF00, r1
MOVIW 1, r2
STOR r2, r1


EXIT: OR r0, r0
JUC EXIT
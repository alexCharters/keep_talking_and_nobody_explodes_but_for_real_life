MOVI 28, r15
    MOVI 28, r14
start: nope
    MOVIW 0xE000, r1
    MOVI 120, r2
    STOR r2, r1
    MOVIW 0xc200, r1
    MOVIW 0xF800, r2
    STOR r2, r1
    MOVIW 0xc000, r1
    MOVI 28, r2
    STOR r2, r1
    MOVIW 0xD400, r1
    MOVI 1, r2
    STOR r2, r1
    MOVIW 0xC400, r1
    MOVIW 0x07C0, r2
    STOR r2, r1
    MOVIW 0xD000, r1
    MOVI 0x99, r2
    STOR r2, r1
end: nope
    MOVIW 0xC100, r1
    MOVIW 0xC200, r2
    LOAD r3, r1
    LOAD r4, r2
    CMP r3, r0
    BEQ 3
    JAL TURNBUTTONONE
    CMP r4, r0
    BEQ 3
    JAL TURNBUTTONTWO
    JUC end
TURNBUTTONONE:    nope
    MOVIW 0xc200, r6
    MOVIW 0x007C, r7
    STOR r7, r6
    JUC r14
TURNBUTTONTWO:    nope
    MOVIW 0xc400, r6
    MOVI 0x7C00, r7
    STOR r7, r6
    JUC r14
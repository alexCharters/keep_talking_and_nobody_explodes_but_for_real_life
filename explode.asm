jal success
movi 0xF6, r1
cmp r0, r0
jeq success
movi -1, r2
ori 0x35, r0
success: movi 0, r2
moviw 0xFF04, r3
jle end
add r3, r3
end: movi 0, r0
jle end2
add r3, r3
end2: movi 1, r1
BUC 10
#
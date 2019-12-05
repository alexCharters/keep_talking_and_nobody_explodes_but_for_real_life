stuff: ori r0, r0
nope
nope
juc stuff
nope
movi 199, r4
lshi -1, r4
movi -211, r5
cmp r5, r4
jeq fail
gud: nope
buc 3
fail: nope
movi -1, r15
juc fail
movi 1, r15
mov r15, r2
fancy: moviw 0xC000, r12
cmp 0, r12
jlt gud
movi -1, r15
buc -2
moviw 1995, r13
cmp r2, r3
jlt fancy
movi 0, r1
movi 1, r2
sub r1, r2
addi 1, r2
cmp 0, r1
jne fail
cmp r2, r2
jne fail
cmp r1, r2
jeq fail
mov r1, r3
movi 9, r9
movi 2, r2
multiply: cmpi r9, r0
jeq done
add r2, r2
subi 1, r9
juc multiply
done: nope
movi 1, r15
juc stuff
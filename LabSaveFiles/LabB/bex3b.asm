c1: DC "integer:"
c2: DC "memory:"
s1: DC "Enter an Integer value!"
s2: DC "Enter a memory address"
ld x28,c1(x0)
ld x29,c2(x0)
addi x30,x0,s1
addi x31,x0,s2

loop:
ecall x0, x30, 4 ;info string
ecall x5,x28, 5;integer
ecall x0, x31, 4 ;info string
ecall x7,x29,5;integer
sd x5,dst(x7)
beq x0,x0,loop
dst: DM 1

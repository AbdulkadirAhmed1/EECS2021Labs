str1: DC "sampled text\0"

// code still deletes 6 characters from the ending 'd' 
// but without the stack, in total i used 3 registers
// a4,a5,a6 instead of the stack

STACK: EQU 0x100000 ;stack
lui sp, STACK>>12
addi a2, x0, str1+6 ;chaddr
addi a3, x0, 6 ;#ch
jal x1, delch
addi x6, x0, str1 ;output
ecall x0, x6, 4
ebreak x0, x0, 0 ;finish 


delch:
add a4,zero,x1
add a5,zero,s0
add a6,zero,s1

addi s0, a2, 0
addi s1, a3, 0
bge x0, s1, end2

loop2: jal x1, delch1
addi a2, s0, 0
addi s1, s1, -1
bne s1, x0, loop2

end2:
add x1,zero,a4
add s0,zero,a5
add s1,zero,a6
jalr x0, 0(x1) ;return 


delch1: lb x5, 0(a2)
loop1: beq x5, x0, end1
lb x5, 1(a2)
sb x5, 0(a2)
addi a2, a2, 1
jal x0, loop1

end1: jalr x0, 0(x1) ;return 
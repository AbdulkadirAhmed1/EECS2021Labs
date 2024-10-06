s1: DC "Enter unsgined integer:\0"
s2: DC "Int"
s3: DC ":"
STACK: EQU 0x100000
start: lui sp, STACK>>12
addi x5, x0, s1
ecall x1, x5, 4 ;out question
ecall x5, x0, 5 ;inp Enter unsgined integer
addi x10,x0,1
addi x11,x0,2
add x9,x9,x5
add x8,x8,x5
addi x6, x0, 1 ;counter 
loop1: 
rem x8,x8,x11
srli x9,x9,1
sd x8, 0(sp) ;push
addi sp, sp, -8 ;push
add x8,x0,x9
addi x6, x6, 1 ;counter 
bge x9, x10, loop1 // check if x9 >= 1 (in either words < 1 e.g cases in 0 jump to next line)
add x7,x0,x6
addi x7,x7,-1
addi x6, x0, 1 ;counter 
loop2: 
addi sp, sp, 8 ;pop
ld x8, 0(sp) ;pop
ecall x0, x8, 0 ;out :, in # 
addi x6, x6, 1 ;counter 
bge x7, x6, loop2 
jal x0,start
str1:DC "sampled \0 "
str2:DC " new\0 "

STACK:EQU 0x100000
lui sp,STACK>>12
addi a2,x0,str1+7
addi a3,x0,str2
jal x1,subch
addi x6,x0,str1
ecall x0,x6,4
ebreak x0,x0,0

subch:sd x1,0(sp)
sd s0,-8(sp)
sd s1,-16(sp)
sd s2,-24(sp)
sd s3,-32(sp)
addi sp,sp,-40
addi s0,a2,0
addi s1,a3,0
addi s3,s0,0

find_end:lb a4,0(s3)
beq a4,x0,shift_right
addi s3,s3,1
jal x0,find_end

shift_right:addi a4,s3,0

shift_loop:lb a5,-1(a4)
sb a5,0(a4)
addi a4,a4,-1
bge a4,s0,shift_loop

loop_subch:lb a5,0(s1)
beq a5,x0,finish_subch
sb a5,0(s0)
addi s1,s1,1
addi s0,s0,1
jal x0,loop_subch

finish_subch:sb x0,0(s0)
addi sp,sp,40
ld x1,0(sp)
ld s0,-8(sp)
ld s1,-16(sp)
ld s2,-24(sp)
ld s3,-32(sp)
jalr x0,0(x1)

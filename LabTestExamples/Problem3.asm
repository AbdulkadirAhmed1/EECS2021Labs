string1: DC "Enter n:\0"
string2: DC "Result:\0"

STACK: EQU 0x1000
lui sp,STACK >> 12

addi t0,zero,5 ;our constant 5
addi a6,zero,1 ;our constant 1
addi a4,zero,4 ;our constant 4

jal x1,main

popstack:
addi sp,sp,8
ld s8,0(sp)
bge s8,t0,checkcase ;s8>=5
defaultcase:
addi s10,s10,5
addi s9,s9,-8
bge s9,a6,popstack 
jal x0,outputresult

checkcase:
beq s8,t0,defaultcase 
mul s7,s10,a4 
add s7,s7,s8 
add s10,x0,s7
addi s9,s9,-8
bge s9,a6,popstack ;as long as s9 >= 1


outputresult:
addi a0,x0,string2
ecall s10,a0,4
ecall x0,s10,0
ebreak x0,x0,0

main:
addi a0,x0,string1
ecall s0,a0,4
ecall s0,x0,5

add t1,x0,s0
rec_lin:
bge t1,t0,rec_lineprocedure 
primecondition:
sd t1,0(sp)
addi sp,sp,-8
addi s9,s9,8
jalr x0,0(x1)

rec_lineprocedure:
beq t1,t0,primecondition
sd t1,0(sp)
addi sp,sp,-8
addi s9,s9,8
addi t1,t1,-5
addi a7,a7,1
jal x0,rec_lin ;unconditonal jump




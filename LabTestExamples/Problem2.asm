s1: DC "Enter x:\0"
s2: DC "Enter y:\0"

addi a0,x0,2 // both are postive
addi a1,x0,1 // only is postive
//a3 is when both are negative

addi s0,x0,s1
ecall t0,s0,4
ecall t0,x0,5

addi s0,x0,s2
ecall t1,s0,4
ecall t1,x0,5

blt t0,x0,xnegative
//means x is postive
blt t1,x0,ynegative
//means y is postive
ecall x0,a0,0
ebreak x0,x0,0

xnegative:
//x is negative
blt t1,x0,result
//means y is postive
ecall x0,a1,0
ebreak x0,x0,0

ynegative:
//x is postive
ecall x0,a1,0
ebreak x0,x0,0


s0: DC "Find all divisors\0"
s1: DC "Enter i:\0"
s2: DC "Divisors:\0"

STACK: EQU 0x100000
lui sp, STACK>>12 

addi x5, x0, s0

ecall x0, x5, 4 ;out info

addi x5, x0, s1

ecall x1, x5, 4 ;prompt i
ecall x6, x0, 5 ;inp i

//counter
addi tp,tp,1 ;counter

loop: 

beq tp,t1,end 

rem s0,t1,tp

beq s0,x0,store

addi tp,tp, 1; counter
addi gp,gp,0 ;inverse counter

jal x0,loop

store:
sd tp, 0(sp) ;push
addi sp, sp, -8 ;push 
addi gp,gp,8 ;inverse counter
addi tp,tp, 1; counter
beq tp,t1,end 
jal x0,loop

end:
sd t1, 0(sp) ;push // push the value of itself 
// since its always a divisor 
addi gp,gp,8 ;inverse counter
addi sp, sp, -8 ;push 

add sp,sp,gp // just for iteration 1
srai t2,gp,3 // get size of stack by dividing
// inverse counter by 8

addi x5, x0, s2
ecall x0,x5,4
//ecall x1, x5, 4 
//ecall x0, x9, 0

outputstack:
beq t2,x0,finish
ld s0, 0(sp) ;pop
ecall x0,s0,0
addi sp,sp,-8 ;inverse counter
addi t2,t2,-1
jal x0,outputstack

finish:
ebreak x0,x0,0 ;finish
s0: DC "Find all divisors\0"
s1: DC "Enter i:\0"
s2: DC "Prime\0"
s3: DC "Not prime\0"

// Code description:
// The following algorithm finds all the divisors of
// a given number. With the given number we then store
// all the possible divisors in a stack
// CONDITION: to qualify as divisor ur remainder must be 0
// if not u don't qualify as divisor and will be masked
// After the program found all possible divisors we then 
// proceed to check if its a prime number or not
// Which is the easiest step. All the program checks 
// is the size of the stack. I.e if the stack size is 2
// then it is prime. WHY? well since the only possible 
// numbers in a stack size 2 is 1 and itself right. 
// since those two are always constantly there and 
// we are the minmium size of the stack (i.e 2)
// IF THE stack size exceeds 2 (Exclusive >) then
// it is indeed not a prime

jal x1,Code

finish:
ebreak x0,x0,0 ;finish

Code:

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

//ecall x1, x5, 4 
//ecall x0, x9, 0

//outputstack:
//beq t2,x0,finish
//ld s0, 0(sp) ;pop
//ecall x0,s0,0
//addi sp,sp,-8 ;inverse counter
//addi t2,t2,-1
//jal x0,outputstack

//size we are looking for
addi a0,x0,2
// if the size of the stack is 2 then
// that means its a prime
addi a1,x0,0
// denote 0 as not prime
// denote 1 as prime

findprime:
beq t2,a0,foundprime
addi a1,x0,0
addi x5, x0, s3
ecall x0,x5,4 
jalr x0, 0(x1) ;return 
foundprime:
addi a1,x0,1
addi x5, x0, s2
ecall x0,x5,4
jalr x0, 0(x1) ;return 
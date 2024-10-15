s0: DC "sum(1..n-1)\0"
s1: DC "Enter n:\0"
s2: DC "sum(1..n-1)=\0"
s3: DC "(n*(n-1))/2=\0"

addi x5, x0, s0

ecall x0, x5, 4 ;out info

addi x5, x0, s1

ecall x1, x5, 4 ;prompt n
ecall x6, x0, 5 ;inp n

//negate
xori x7,x6,-1
addi x7,x7,2 ; add 1(always) + 1(in our spefic case)

//highest value
addi x4,x6,0
//lowest value
add x8,x6,x7
//result
addi x9,x0,0

loop: 
beq x8,x4,end

add x9,x9,x8
addi x8,x8,1

beq x0,x0,loop

end:
addi x5, x0, s2
ecall x1, x5, 4 
ecall x0, x9, 0

//(n-1)
addi x8,x6,-1
//2
addi x4,x0,2

mul x9,x6,x8
div x9,x9,x4

addi x5, x0, s3
ecall x1, x5, 4 
ecall x0, x9, 0
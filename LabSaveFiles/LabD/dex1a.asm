s0: DC "n!\0"
s1: DC "Enter n:\0"
s2: DC "n!=\0"

addi x5, x0, s0

ecall x0, x5, 4 ;out info

addi x5, x0, s1

ecall x1, x5, 4 ;prompt n
ecall x6, x0, 5 ;inp n

//previous value
add x7,x0,x6
//multipler value
addi x9,x0,0

loop: 
addi x7,x7,-1

beq x7,x0,end

beq x9,x0,j1
mul x8, x9, x7
add x9,x8,x0
bne x7, x0, loop

j1:
mul x8, x6, x7
add x9,x8,x0
bne x7, x0, loop

end:
addi x5, x0, s2
ecall x1, x5, 4 
ecall x0, x8, 0
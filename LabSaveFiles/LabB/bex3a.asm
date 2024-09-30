s1: DC "What is your name?"
s3: DC "Hello"	
s4: DC "Hello John"
addi x29,x0,s1
addi x31,x0,s3
ecall x0, x29, 4 ;info string
ecall x5, x0, 8
addi x4,x0,32
ecall x0,x4,4
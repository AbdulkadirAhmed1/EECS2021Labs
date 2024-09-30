s1: DC "What is your name?"
s2: DC "John"
s3: DC "Hello John!"	
addi x29,x0,s1
addi x30,x0,s2
addi x31,x0,s3
ecall x0, x29, 4 ;info string
ecall x0, x30, 4 ;info string
ecall x0, x31, 4 ;info string 
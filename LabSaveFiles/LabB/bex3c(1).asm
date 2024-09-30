dir: DC "John"
DC "11111"
DC "Nick"
DC "22222"
DC "Sara"
DC "11111"
DC "Nick"
DC "33333"
DD 0 


s1: DC "Enter a phone or a name\nto search for:\0"

addi x30,x0,s1

loop: 
addi x15,x0,8
addi x19,x0,0
ecall x4,x30,4 ;info string
ecall x5,x0,8
beq x0,x0,findadress

findadress:
ld x3,dir(x15)
ld x6,dir(x19)
beq x3,x5,displaynames
beq x6,x5,displaynumbers
addi x15,x15,16
addi x19,x19,16
beq x3,x0,loop
beq x6,x0,loop
jal x0,findadress

displaynumbers:
addi x14,x19,8
ld x7,0(x14)
ecall x0, x19, 4
ecall x0, x14, 4
addi x19,x19,16
beq x7,x0,loop
jal x0,findadress

displaynames: 
addi x14,x15,-8
ld x7,0(x14)
ecall x0, x14, 4
ecall x0, x15, 4
addi x15,x15,16
beq x7,x0,loop
jal x0,findadress
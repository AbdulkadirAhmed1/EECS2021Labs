s1: DC "Enter a string:\0"
s2: DC "Int"
s3: DC ":"
STACK: EQU 0x100000
start: lui sp, STACK>>12
addi x5, x0, s1
ecall x1, x5, 4 ;out question
ecall x5, x0, 8 ;inp Enter a string

add x10, x0, x5   
addi x11,x0,1
            
loop1:
andi x7, x10, 0xFF          
srli x10, x10, 8                            
sd x7, 0(sp) ;push 
//ecall x0,sp,4
addi sp, sp, -8 ;push    
bge x10,x11, loop1  
  
add x10, x0, x5 
addi x6,x0,0 

loop2:
addi sp, sp, 8 ;pop
ld x8, 0(sp) ;pop
andi x7, x10, 0xFF          
srli x10, x10, 8  
beq x8,x7,stringequal
addi x6,x0,0
bge x10,x11, loop2   
jal x0,start

stringequal: add x6,x0,x11  
bge x10,x11, loop2   
jal x0,start

// in my code if x6 at the end the code is 1 then the 
// string is palindrome however if it is 0 then it 
// is not palindrome

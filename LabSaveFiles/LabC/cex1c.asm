c: DC "12+34-*\0" // (1 + 2) * (3 -4) = -3
//c: DC "54+34+*\0" // (5 + 4) * (3 + 4) = 63
//c: DC "96+69++\0" // (5 + 4) + (3 + 4) = 30
//c: DC "97+36-*\0" // (9 + 7) * (3 - 6) = -48
//c: DC "12+29-+\0" // (1 + 2) + (2 - 9) = -4
//c: DC "00+88--\0" // (0 + 0) - (8 - 8) = 0
//c: DC "02-73+*\0" // (0 - 2) * (7 + 3) = -20
//c: DC "81*69+*\0" // (8 * 1) * (6 + 9) = 120
//c: DC "12-34**\0" // (1-2) * (3 * 4) = -12

// WARNING: LONG EXPLANATION AHEAD 
// note: my desc doesn't explain all the details of the code
// it just serves to display the logic i used to code it
// DESC:
// the logic here is to loop through the string 
// get the each operand and determine 
// where it is a NUMBER or a OPERATOR 
// if is a number push to stack
// if it is a OPERATOR ignore for now (we will loop later)
// next we go to finding the OPERATOR 
// notice how the operator is to the right of the number
// e.g 2+ or 4- , we can use this to the advantage
// so what we do next is pop 2 numbers from the
// stack e.g the stack would look like 4 3 2 1 in this case
// so when we pop the stack the first group we get is 
// 4 and 3 so next in the order we poped meaning we
// have 4 then we use what i said before e.g 4- 
// since the - OPERATOR corelates with 4 then we 
// apply it to the group 4 3 so (3 - 4) were the 
// second poped number is subed from the first 
// popped number (from stack) 
// since this is an iteration we have the 1 2 case which
// is next then we apply + OPERATOR since 2+ (e.g corelates with 2)
// finally we apply the last OPERATOR * notice how 
// the stack is empty going down meaning there is 
// no more groups of numbers to apply 
// thus we just get the operator * (which is the final 
//operator this is important because we wouldn't know
// when to stop the loop 
// then we just apply the two groups we calculated before
// and the end result is -3 which we then just
// push to the top of stack

addi x11,x0,1
addi x23,x0,2
addi x25,x0,0 ;counter
addi x26,x0,-8
addi x12,x0,0x2B // "ASCII	value for +"
addi x13,x0,0x2D // "ASCII	value for -"
addi x14,x0,0x2A // "ASCII	value for *"

STACK: EQU 0x100000
lui sp, STACK>>12 

ld x10,c(x0)

loop1:
andi x7, x10, 0xFF          
srli x10, x10, 8 
addi x5,x7,-48 // current value in this case can be (1,2,3 or 4) subtract 48 because we want it in decimal and its in ASCII 
bge x5,x0,realnumber
bge x10,x11,loop1
jal x0,initalize

realnumber:
sd x5, 0(sp) ;push
addi sp, sp, -8 ;push 
addi x25,x25,1
bge x10,x11,loop1
//jal x0,loop2

initalize: 
beq x17,x11,terminatecode
ld x10,c(x0)
addi sp, sp, 8 ;pop
ld x8, 0(sp) ;pop 
beq x8,x0,endofstack
addi sp, sp, 8 ;pop
ld x9, 0(sp) ;pop

//loop2: 
//andi x7, x10, 0xFF          
//srli x10, x10, 8 
//addi x5,x7,-48

//bge x5,x8,findoperand

//jal x0,loop2

addi x30,x0,0 // previous value

findoperand:
andi x7, x10, 0xFF          
srli x10, x10, 8 
addi x5,x7,-48

bge x5,x0,return // make sure its a operand
beq x30,x8,docommand // make sure its x8 one of our popped stack numbers
jal x0,findoperand

docommand: 
beq x7,x12,addoperands
beq x7,x13,suboperands
beq x7,x14,multiplyoperands
ebreak x0,x0, 0 ;finish

return:
add x30,x0,x5
jal x0,findoperand

addi x22,x0,0

addoperands:
beq x3,x0,notoverloadedx3
add x16,x0,x3
notoverloadedx3: add x3,x9,x8
addi x22,x0,1
jal x0,initalize

suboperands:
sub x4,x9,x8
addi x22,x0,2
jal x0,initalize

multiplyoperands:
mul x6,x9,x8
addi x15,x15,1 
jal x0,initalize 

//--------------------------------------------

multiplyoperands2:
beq x15,x11,mcasea

beq x16,x0,mskipoverloadedx3
mul x18,x3,x16
jal x0,initalize 
mskipoverloadedx3:
mul x18,x3,x4
jal x0,initalize

mcasea:
beq x3,x0,mcase1
beq x4,x0,mcase2

mcase1:
mul x18,x6,x4
jal x0,initalize 

mcase2:
mul x18,x6,x3
jal x0,initalize 

//--------------------------------------------

addoperands2:
beq x16,x0,askipoverloadedx3
add x18,x3,x16
jal x0,initalize
askipoverloadedx3:
add x18,x3,x4
jal x0,initalize

suboperands2:
beq x22,x11,scase1
beq x22,x23,scase2
scase1: sub x18,x3,x4
scase2: sub x18,x4,x3
jal x0,initalize

endofstack:
theendloop: 
bge x10,x11,movestring
addi x17,x17,1
beq x7,x12,addoperands2
beq x7,x13,suboperands2
beq x7,x14,multiplyoperands2
ebreak x0,x0, 0 ;finish
        
movestring:
andi x7, x10, 0xFF  
srli x10, x10, 8
jal x0,theendloop 

terminatecode:
mul x24,x25,x26
add sp, sp, x24 ;push 
addi sp, sp, -8 ;push 
sd x18, 0(sp) ;push
ebreak x0,x0, 0 ;finish

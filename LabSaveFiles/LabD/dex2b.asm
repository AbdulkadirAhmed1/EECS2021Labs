//Algorithm goal
//estimate the value of e 
//by using the series expansion methd
// i.e e = inifnity summtion n = 0 1/n!
//i.e 1.0/0!+1.0/1!+1.0/2!+1.0/3!+...+1.0/n!.....
//goal: to find a n that produces ? 2.71828182845904523536
// logic flow:
//ask user to input n. with that n produces the series 
//expansion. store the result in memory 
//keep inputing n to find the most accruate n value

//in this example we will use a stack

//Initialize

s1: DC "Enter a value of n:\0"
s2: DC "Result e:\0"

d1: DF 1.0

STACK: EQU 0x100000

lui sp,STACK >>12

jal ra,start

//final result of e is stored in f9 so we simply output it

addi t0,t0,s2
ecall t1,t0,4
ecall t1,f9,1 

ebreak x0,x0,0

//we setup the user to input a natrual number because
//we are using a summation and we don't want them 
// entering a float

start:
addi t0,t0,s1
ecall t1,t0,4
ecall t1,x0,5 

add s2,x0,t1 ;this is saved value (input) we will need later

jal t6,series_expansion ;unconditional jump

finishedstack:
fsd f1,0(sp) ;push
addi sp,sp,-8 ;push

//now here since we have the stack full of elements
//we want to add them up and this will be our value of e

//we need a way to end loop so we will use the
//value we had in s2 to end it when it reaches 0

addi s2,s2,1 ;we add 1 because we have have n + 1 stack size

finde:
beq s2,x0,end

addi sp,sp,8 ;pop
fld f8,0(sp) ;pop
fadd.d f9,f9,f8 ;f9 stores the value of e
addi s2,s2, -1 ;counter

jal t6,finde ;unconditional jump

end:
jalr x0,0(ra)


//---------------------------------------------------

series_expansion: 

//we have two variables f1 and f2
//f1 will always be 1.0
//f2 will be n! which varies (0.0! to  n!)
//notice how we use a float for f2 instead of int
//the reason being n is always a natrual number so
// we never have to worry about decimals
//also we use fcvt because we wanna 
//have the rounding factor which fmv.d.x doesn't have

//note: we must calculate n! in our code
//n! = n * (n - 1) * (n - 2) * (n - 3) * .....
//For reference we can just use the algorithm we had in
//cex1a.asm
//also we will treat n! as float type so the formula would 
// still be the same but we just use float registers
// Note: f0 will always contain 0.0 (will use later on)

//Reference1: e = 1.0/0!+1.0/1!+1.0/2!+1.0/3!+...+1.0/n!.....
//Reference2: n! = n * (n - 1) * (n - 2) * (n - 3) * .....

fld f1,d1(x0) ;load 1.0 f1 always contains this(contains 1.0)
fcvt.d.l f2,x6 ;convert n from long to float(contains n)
//f1 always 1.0 constant
//f2 in this current context is the 
//input value converted to long

jal t6,initializefactorial ;unconditional jump

foundnfactorial:
//after we found the factorial
//we calculate 1.0/n! and store result in f7
//note our factorial (n!) result is stored in f6
fdiv.d f7,f1,f6
fsd f7,0(sp) ;push
addi sp,sp,-8 ;push
//after we store the result in the stack we now
//subtract f2 by 1 and find the factorial for this
fsub.d f2,f2,f1

//refer to Reference1
//condition to EXIT is when f2 < 0 why?
// our last term to add (or first term by reference)
// is 1/0! so we don't want to add 1/-1!

//f0<f2 can be written as f2 >= f0
//if f2 > f0
//example f2 is 1 || 1 > 0 true(1) 
//f2 is 0 || 0 >= 0 true(1) 
//f2 is -1 || -1 >= 0 false(0) failed exit

flt.d x8,f0,f2
beq s0,zero,finishedstack

//---------------------------------------------------

initializefactorial:
//NOTE: f6 STORES our final value of n!
//set f5 and f6 to zero
fadd.d f5,f0,f0
fadd.d f6,f0,f1
//current n for factorial (f3)
fadd.d f3,f0,f2
//(current n - 1) for factorial (f4)
fsub.d f4,f3,f1

findnfactorial:
//Refer to Reference1:
//condition to EXIT findnfactorial LOOP is: 
//end when current n = 0 (n here is current n)
//x7 contains (0 or 1) where 0 means exit loop
//(1) f0<=f4 could also mean (2) f4 > f0 
//where (2) 0 means exit loop. (cause if f4 was 0.0
//then 0.0 > 0.0 is false i.e 0)

flt.d x7,f0,f4
beq t2,zero,foundnfactorial

//multiply (f5) and increment (f6 final value of n!)
fmul.d f5,f3,f4
fmul.d f6,f6,f5

fsub.d f3,f4,f1
fsub.d f4,f3,f1

jal t6,findnfactorial ;unconditional jump

//---------------------------------------------------

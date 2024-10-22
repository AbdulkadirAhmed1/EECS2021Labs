//Algorithm 

///Edits: Added a check to see if we have a natrual root
///a natrual root is a number that produces a 
//natrual number i.e sqrt(4) or sqrt(9) ....

//Reference: 

//(1) 
//Ask user for input x and y

//let x be the number we want to square root i.e sqrt(x)
//let y be the tolereance 
//(range from 10^-6 to 10^-2 i.e 0.000001 to 0.01)

//(2) 
//if x < 1 then we set it as lower bound (upper bound is 1)
//if x > 1 we set it as upper bound (lower bound is 1) 

//(3) then we have loop 

//c = (upper bound + lower bound)/2 

//we find midpoint c and then do c^2 
//we compare c^2 to x 
//if c^2 < x set to lower bound to c
//if c^2 > x set to upper bound to c

//continue loop till the difference of 
//(upper bound - lower bound) <= y or 
//till the difference of (c^2 - x)  <= y 

//(4) then the final value of c is the closest estimation 
//of sqrt(x) based on the tolerence 

//tolerence is what determines the accuracy of the final
//result i.e a tolerence of 0.001 would be much less
//accurate then a tolerence of 0.000000001

//In this question a stack is not required
//since we want the latest value, previous values are
//redudant 

//----------------------------------------------------

//we will store 1.0 constant in f1
//we will store 1 constant in s1
//we will store x in f2
//we will store y in f3


//(1) Initialize

s0: DC "Program Start\0\0"
s1: DC "Enter x:\0"
s2: DC "Enter y(0.000001 to 0.01):\0"
s3: DC "sqrt(x):\0"

//Constant handling:
d1: DF 1.0

fld f1,d1(x0) ;load float 1.0
addi s1,zero,1 ;constant s1 = 1 (will be used for logic)

//get x(refer to Reference)
addi t0,zero,s1
ecall x0,x0,4
ecall f2,t0,4
ecall f2,zero,6

//check here to see if we have a natrual root
//a natrual root is any root number that produces a 
//natrual number

//this is mini algorithm to determine if we have a
//natrual number based on its root

//test inputs 3,9,10

//sqrt(3) = 1.7...
//round 1.7... = 2
//2^2 = 4
//3 != 4 > so not a natrual number
//sqrt(9) = 3
//round 3 = 3
//3^2 = 9
//9 == 9 > so a natrual number 
//sqrt(10) = 3.1....
//round 3.1.. = 3
//3^2 = 9
//10 != 9 > so not a natrual number
//.....

//note: we use fcvt because it has that rounding
//factor also fmv wouldn't be useful here since
//it copies the sheer addresses from int reg - fp reg 
//or likewise...

fsqrt.d f10,f2 
fcvt.l.d x20,f10 //round f10 to nearest so i.e
//if f10 was 1.7 = 2 or 1.2 = 1... 
mul x20,x20,x20 // x20 = x20 * x20 i.e we take the square
fcvt.l.d x21,f2 //convert f2 to integer store in x21

//now to determine if we have natrual number or not
//we compare x21 our previous value and x20
bne x20,x21,notnatrualroot

//natrualroot
addi t0,zero,s3
ecall f10,t0,4
ecall x0,f10,1
ebreak x0,x0,0

notnatrualroot:

//get y(refer to Reference)
addi t0,zero,s2
ecall f3,t0,4
ecall f3,zero,6

//(2)
//f4 is lowerbound and f5 is upperbound
//we set the default upper bound and lower bound to 1

fadd.d f4,f0,f1 ;lowerbound 1
fadd.d f5,f0,f1 ;upperbound 1

//t1 stores 1 or 0 (checks for x<1)
//t2 stores 1 or 0 (checks for x>1) 

flt.d x6,f2,f1 // x < 1 (if 1 then change lowerbound)
fle.d x7,f1,f2 // 1<=x or x > 1 (if 1 then change upperbound)

//s1 is a constant which is 1

beq x6,s1,initializechangelb
beq x7,s1,initializechangeup

initializechangelb:
fadd.d f4,f0,f2 ;lowerbound x
jal x0,bisectionloopinitialize ;unconditional jump

initializechangeup:
fadd.d f5,f0,f2 ;upperbound x
jal x0,bisectionloopinitialize ;unconditional jump


//(3)

//Variable remainder: 

//f0 and f1 are constants (f0 = 0.0, f1 = 1.0)
//f2 is x and f3 is y (refer to Reference for x and y)
//f4 is lowerbound and f5 is upperbound

bisectionloopinitialize:

//we need a new constant 2.0 but we don't need to
//define a new float we can manipluate f1 to derive 2.0.
//we will override f1 with this new constant since
//we no longer need the constant 1.0

fadd.d f1,f1,f1 ;constant 2.0 will be used in getitng c
//here f1 = f1 + f1 (which is 1 + 1 = 2)

//we will store the midpoint c in f6
//we will store the square of c in f7
//we will store (upper bound - lower bound) in f8

bisectionloop:
//c = (upper bound + lower bound)/2 (notice we need 2) 

fadd.d f6,f4,f5 ;f6 = upper bound + lower bound
fdiv.d f6,f6,f1 ;f6 = (upper bound + lower bound)/2 
fmul.d f7,f6,f6 ;f7 = c^2

//we compare c^2 to x 

//we need constant 1.0 again so we maniplute f1 again
//fdiv.d f1,f1,f1 ;constant 1.0 will be using in the logic
//statments below. here f1 = f1/f1 (which is 2/2 = 1)

//s1 is a constant which is 1
//f6 is c
//f2 is x

flt.d x6,f7,f2 // c^2 < x 
fle.d x7,f2,f7 // x<=c^2 or c^2 > x 

beq x6,s1,changelb
beq x7,s1,changeup

changelb:
fadd.d f4,f0,f6 ;lowerbound x
jal x0,checkendcondition ;unconditional jump

changeup:
fadd.d f5,f0,f6 ;upperbound x
jal x0,checkendcondition ;unconditional jump

//let f8 store (upper bound - lower bound)
//f3 is y(tolerence)

checkendcondition:

fsub.d f8,f5,f4 

fle.d x7,f8,f3

bne x7,s1,bisectionloop

//ends here (now we have our result store in f6 which is c)
//now we print the root of the FP(float number)

addi t0,zero,s3
ecall f6,t0,4
ecall x0,f6,1

ebreak x0,x0,0

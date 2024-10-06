s1: DC "Enter two postive integers\0"
s2: DC "GCD is:"
addi sp, x0, 0 ;sp initialization
jal x0, Initialize ;call Initialize

//we store in s0 e.g x8 the value of gcd(a,b)
// example gcd(48,18) = 6
// proof 
//48%18 = 12
//18%12 = 6 >> 6 is the greatest common divisor 
//12%6 = 0 
// format is from (a,b) -> (b,a%b) and stop
// when b == 0

// some test inputs: (270,192)
//270%192 = 78 
//192%78 = 36
//78%36 = 6 >> 6 is the gcd
//36%6 = 0 (we stop here since the new b -> a%b is now zero)

// (624,168)
// 624%168 = 120
// 168%120 = 48
// 120%48 = 24 >> 24 is the gcd
// 48%24 = 0 (stop)

Initialize:
addi x30,x0,s1
ld x29,s2(zero)
ecall x0,x30,4 
ecall a0, x0,5 
ecall a1, x0,5

euc:
bne a1,x0,gcd
beq a1,x0,end
end:
//addi sp,sp,8 ;pop
ecall x1,x29,3
ecall x0,s0,0
jal x0,Initialize

gcd:
div t0, a0, a1   // integer division (x / y)
mul t0, t0, a1   // Multiply quotient by y
sub t0, a0, t0   // Subtract result from x to get the remainder (x % y)
add a0,x0,a1
add a1,x0,t0
add s0,x0,a0
addi sp, sp, -16 ;push
sd a0, 0(sp) ;push
sd a1, 8(sp) ;push
jal x0,euc


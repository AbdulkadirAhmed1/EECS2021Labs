s1: DC "Enter x:\0"
s2: DC "Result:\0"
c0: DF 0.0
a: DF 3.0
b: DF 5.0
fld f0, c0(x0)
fld f1, a(x0)
fld f2, b(x0)

loop: addi x5, x0, s1
ecall x1, x5, 4 ;out info
ecall f3, x0, 6 ;inp x
flt.d x1, f3, f1
beq x1, x0, cont
fadd.d f3, f0, f2
beq x0, x0, done

// 2 <= 3(input) this will return 1
// but we wanna check 3 > 2 (1 means its greater here)
// 0 means its less 
// so reverse logic in this case is 0 means its less then


cont: fle.d x1, f2, f3 // this acts > because b<=f3 can be rewritten as f3 > b
// b: 5 so 5 <= 3(input) this is false (0) 
// or we can read it as 3 > 5 (false right so (0))
// so in this case 0 is pass case and 1 is fail case
beq x1, x0, done // if pass case print it
fadd.d f3, f0, f1 // if fail case set f3 = a (lower bound)

// How i would do it:

// knowing fle.d returns 0 and 1
// f2 (upper bound 5) f3 (input)
// goal to make sure f3 doesn't go pass f2 i.e f3 > f2 (is not true)
// fle.d x1, f3, f2 (f3 <= f2) > here 3(input) <= 5
// is true (1)
// so (1) is pass case and 0 is fail case
//beq x1, x11, done ;x11 contains 11 (note we have to use extra registers)
// fadd.d f3, f0, f1
// in my case it would inefficent due to the extra use of
// a register
// so from observation i would proceed to use the method 
// above i.e bound<=input which can be read as input > bound

done: addi x5, x0, s2
ecall x1, x5, 4 ;out x
ecall x0, f3, 1 ;out res
beq x0, x0, loop 
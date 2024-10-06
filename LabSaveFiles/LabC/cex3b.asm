//DOUBLE CHECK RESULTS WITH fib(n) table
// Side note: Fibonacci normal version and tail
// tail recursive approch both produce the same 
// output however the key difference between them is:
// the size of the stack for the normal version
// is much higher compared to the tail recursive. 
// the reason being is we have two defined variables a 
// b to assist us while in the normal version we didnt
// we used two additional calls i.e  fib (n - 1) + fib (n - 2)
// while in the tail version we use 1 call fib(n - 1, b, a + b);

s1: DC "Fibonacci number is\0"

addi sp, x0, 0 ;sp initialization
addi t0, x0, 0 ;a = 0
addi t1, x0, 1 ;b = 1
//addi a0, x0, 0 ;n=0 ; (example prdouces 0)
//addi a0, x0, 1 ;n=1 ;(example prodcues 1)
addi a0, x0, 5 ;n=5 ;(base example produces output 5)
//addi a0, x0, 14 ;n=14 ;(example produces output 377)
//addi a0, x0, 15 ;n=15 ;(example produces output 610)
//addi a0, x0, 8 ;n = 8 ;(example produces output 21)
addi x11,x0,1 ;constant

addi sp, sp, -24 ;adjust sp 
sd t0, 16(sp) ;push a
sd t1, 8(sp) ;push  b

// here a run down of how this program works
// the follwing code is for tail recursive version
// of the fibonacci prodcedure 
// E.g For n = 5, the initial call would be:
//base example: (we will use this example as reference)
//0: fib_tail_recursive(5, 0, 1)
//1: fib_tail_recursive(4, 1, 1)
//2: fib_tail_recursive(3, 1, 2)
//3: fib_tail_recursive(2, 2, 3)
//4: fib_tail_recursive(1, 3, 5) ? returns b = 5

// the following pattern is observed 
//we create a stack to keep our previous value that 
// we will use later on 
// e.g 

//The loop works as follows 
// check n (if n > 1) continue the recrusive flow
// if (n == 1) return b if (n == 0) return a
// now why do we store previous values 
// well because we set the 2nd argument in 
//fib_tail_recursive(x,y,z) as y = z
// notice from our base example n = 5
// see how each time we move into our next iteration
// y = z is inded true (look at it diagonally from 0-4
//since we our in a recursion)
// next we set b = a + b (not this is why we need the 
//previous value) b on the right side of the equation
// is our previous b. You can now notice the pattern 
// in our base example (look at 3rd paramter 
//veriatlly from 0-4) since we use previous values we
// indeed need a stack instead of wasting reg space

jal x1,fib_tail_recursive
addi x29,x0,s1
ecall x0,x29,4
ecall x0, a0, 0
ebreak x0, x0, 0

fib_tail_recursive:
beq a0,x0,returna
beq a0,x11,returnb
bge a0,x11,recurv

returna:
add a0,x0,t0
jalr x0, 0(x1) 

returnb:
add a0,x0,t1
jalr x0, 0(x1) 

recurv: 
beq a0,x11,returnb

addi sp, sp, 24 ;adjust sp 
ld s0, -16(sp) ;pop b
ld s1, -8(sp) ;pop a

add t0,x0,s0
add t1,t0,s1
addi a0,a0,-1

addi sp, sp, -24 ;adjust sp 
sd t0, 16(sp) ;push a
sd t1, 8(sp) ;push  b

jal x0,recurv


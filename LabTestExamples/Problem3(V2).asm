addi sp,x0,0
addi a0,x0,20 ;n=20
jal x1,rec_lin
ecall x0,a0,0
ebreak x0,x0,0

//BIG NOTE:

//interdependence is key in this question
//almost recurvise calls have this dependence
//and is so curcial to understand

//with pseudocode
//If n ? 5 rec_lin(n) = 5
//Else rec_lin(n) = 4×rec_lin(n-5) + n

//from reading from this we can derivie such a case

//if n = 20
 
//then

//rec_lin(20) = 4*rec_lin(15) + 20
//rec_lin(15) = 4*rec_lin(10) + 15
//rec_lin(10) = 4*rec_lin(5) + 10

//where in order to get rec_lin(20) we must get
//rec_lin(15) and rec_lin(10). and where rec_lin(5) = 5
//since there is such interdepence we must go from bottom
//to top i.e

//rec_lin(5) = 5
//rec_lin(10) = 4*rec_lin(5) + 10
//rec_lin(15) = 4*rec_lin(10) + 15
//rec_lin(20) = 4*rec_lin(15) + 20

//and what have we learned follows such behaviour
//of course a stack!

//SYSTEM WORKS AS SUCH: 

//we check if 5<n (failes when 5<5)
//if not then we add to the stack the value of n
//and its return adresss. with this information our 
//stack would look like the following:

//for case n = 20

//10
//return adress
//15
//return adress
//20
//return adress

//it's important that this code flows as such 

//start
//check if 5<n if not go to jal loop 1
//jal loop 1
//push to stack and do n-5 jump back to start

//when n< 5 then we will go to our 2nd jal loop
//jal loop 2
//pop from stack and calculate value of 
//rec_lin(n) = 4*rec_lin(n-5) + n

//minor details can be understand from running code
//with "NEXT" button

rec_lin:	addi x6,x0,5
	 blt x6,a0,recu
	 addi a0,x0,5
	 jalr x0,0(x1)
recu:	 sd x1,-8(sp)
	 sd a0,-16(sp)
	 addi sp,sp,-16
	 addi a0,a0,-5
	 jal x1,rec_lin
	 addi sp,sp,16
	 ld x1,-8(sp)
	 ld x5,-16(sp) 
	 addi x7,x0,4
	 mul x9,a0,x7
	 add x9,x9,x5
         add a0,x0,x9
	 jalr x0,0(x1)
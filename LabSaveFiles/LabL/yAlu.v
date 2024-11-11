module yAlu(z, ex, a, b, op);
  input [31:0] a, b;
  input [2:0] op;
  output [31:0] z;  // Change output reg to wire
  output ex;

  wire [31:0] and_result, or_result, add_sub_result,sub_result;
  wire [31:0] slt;  // Not used in this case, as SLT is not supported
  wire cout,subd;
  
 //Reference: Available opcodes 
 
//000 (AND)
//001 (OR)
//010 (ADD)
//110 (SUB)
//111 (SLT)

/*
we have 3 possible outputs 

0- and
1 - or bitwise
2 - add/sub
3 - slt 

when they op[2:1] equals 00 and if op[0] is 0 then thats means AND  

when they op[2:1] equals 00 and if op[0] is 1 then thats means OR 

when they op[1:0] equals 10 and if op[2] is 0 then thats means ADD 

when they op[1:0] equals 10 and if op[2] is 1 then thats means SUB s

the latter is slt which doesn't require bit wise checks

*/


/*
Implmenting yMux4to1.v 

bit 110 c[2] = 0 , c[1] = 1, c[2] = 1

c must be two bits

c[0] to get 2 results
c[1] to get 1 result

a0 = and_result
a1 = or_result
a2 = add_sub_result
a3 = slt

000
001
010
110 
111 

we extract from opcode c[0:1] why? look below

00
01
10
11 

and_result
or_result
add_sub_result
slt   

case 1: if c[0] == 0 (it will narrow it down to a0,a1)
case 2: if c[0] == 1 (it will narrow it down to a2,a3)

case 1: if c[1] == 0 (it will narrow it down from a0,a1 chooses a0 (and_result)) //and the final results is z
case 2: if c[1] == 0 (it will narrow it down from a2,a3 chooses a2 (add_sub_result)) //and the final results is z

case 1: if c[1] == 1 (it will narrow it down from a0,a1 chooses a1 (or_result)) //and the final results is z
case 2: if c[1] == 1 (it will narrow it down from a2,a3 chooses a3 (slt)) //and the final results is z


So to conclude: 

 yMux4to1  #(.SIZE(32)) myMux(z,and_result,or_result,add_sub_result,slt,c[1:0]);
*/
 
 /*
 We know want to add a "zero" flag exception. 
 
 What does this flag exception do? Well it checks whether z=0 (by bits if all 32 bits of z are 0) 
 
 there are two ways about going about implmenting this excpetion into our hardware for alu 
 
 both way use OR operator. Why? 
 
 The OR operator is the operator which will give us a "1" result bitwise if any of the case's aren't 0 OR 0 
 
 1 OR 0 = 1
 0 OR 1 = 1 
 1 OR 1 = 1 
 0 OR 0 = 0 
 
 this is key because if we wanna determine whether z= 32'b0 (i.e 32 bits of 0) then we must check bitwise (at the hardware level) 
 
 1.) OR'ing sequentially  (Merge-sort)  
 
 why choose this method? Simple we can benefit from array instantiation (what do i mean? well we shall see) 
 
 it would look something like this: 
 
or or16 [15:0] (z16, z[15:0], z[31:16]);
or or8 [7:0] (z8, z16[7:0], z16[15:8]);
or or4 [3:0] (z4, z8[3:0], z8[7:4]);
or or2 [1:0] (z2, z4[1:0], z4[3:2]);
or or1 (zero, z2[0], z2[1]);

this is quite lengthy but when i say "we benefit from array instantiation" it means we can recycle or use it later on in the code.

i.e we could use the wire z8,z2 in some places etc... 

notice how we also define the amount of bits we will be doing logic gate or with (or16 is defined as [15:0] i.e 16 bits ....)
and we start from the top bit and narrow it down imagine z = 0101 0000 0101 0000 0101 0101 0101 0000 

it would get narrow down as such: 
z = 0101 0000 0101 0000 0101 0101 0101 0000

z16 = 0101 0000 0101 0000   OR   0101 0101 0101 0000
z16 = 0101 0101 0101 0000

z8 = 0101 0101   OR   0101 0000
z8 = 0101 0101

z4 = 0101   OR   0101
z4 = 0101

z2 = 01   OR   01
z2 = 01

zero = 0   OR   1
zero = 1


2.) Unary Reduction (OR bitwise |)

this is very straightforward just like we have been doing: 

assign ex = ~|z; (where |z would return 0 or 1 then taking the not of this we can give it an exception) 

i.e if |z finds that z is zero it would return 0. (this means we want to throw an exception so we just negate this result giving us 1)

1 meaninng throw an excpetion 

 */

 // Exception signal (not supported here)
  assign cout = 0; // Default cout
  assign subd = 1; //Subtract case default

  // Generate results for individual operations
  assign and_result = a & b;  // AND operation
  assign or_result = a | b;   // OR operation

  // Instantiate the arithmetic unit for ADD/SUB
  yArith arith_unit1(a, b, op[2], add_sub_result, cout); // ADD/SUB operation, op[0] selects ADD (0) or SUB (1)
  yArith arith_unit2(a, b, subd, sub_result, cout); 
  /* 
  // Conditional expressions to determine the ALU result
			 
	assign z = (op == 3'b000) ? and_result :               // AND
			   (op == 3'b001) ? or_result :                // OR
			   (op == 3'b010) ? add_sub_result :          // ADD
			   (op == 3'b110) ? add_sub_result :          // SUB
			   32'b0;                                     // Default is 0 for unsupported operations
   
   
   //Simplfied:
   
    assign z = (op[2:1] == 2'b00) ? (op[0] == 1'b0 ? and_result : or_result) : //AND or OR
           (op == 3'b010 || op == 3'b110) ? add_sub_result :  // Combine ADD and SUB
           32'b0;  // Default is 0 for unsupported operations
  */ 
  
   xor(condition, a[31], b[31]);
   
   assign slt = (condition) ? a[31]:sub_result[31];
   
   assign ex = ~|z;   // Supported (exceptions)
	 
  yMux4to1  #(.SIZE(32)) myMux(z,and_result,or_result,add_sub_result,slt,op[1:0]);
  
  /*
Some rules: 

addition (a+b): if a and have (+ +) and we get - result this means overflow occurs  
addition (a+b): if a and have (- -) and we  get + result this means overflow occurs

subtraction (a-b): if a and have (+ +) and we  get - result means overflow occurs (a - b = -(overflow)) (+a -b here techincally they are different signs important)
subtraction (a-b): if a and b (- -) and we get + result means overflow occurs (-a - (-b) > -a + b = +(overflow)) (-a + b here techincally they are different signs important)

knowing this what can we infer to determining "<"

if we are comparing a and b (In Excat order) 

a < b 

slt: 1 (means true a is less then b)
slt: 0 (means false a is not less then b rather a > b)

if (a and b have different signs)
    //we worry about overflow 
	
    a = + b = - 
	or
	a = - b = +
	
	if a < 0 (-) then set slt 1 
	if a >= 0 (+) then set slt 0 
	
	what does this mean it means 
	
	when a is negative and (and a are different signs) 
	then a < b (so slt = 1)
	
	but when a is postive then means that b is for sure - (they are different signs) 
	then a > b (so slt = 0)
	
    slt = 1 if a < 0 else 0
else
    when a and b have the same sign 
	
	result is the subtraction (a-b)
	
	a = + b = + 
	a = - b - 
	
	a - b > case 1 +a - +b   (a - b)
	a - b > case 1 -a - -b  (-a + b)
	
	//we don't worry about overflow here (the default way of finding if a < b is just subtracting them)
	
	note: when subtracting a and b and both are negative we check which is more negative 
	a = -3 b = -5
	a - b > -3 + 5 > 0 (this means it made "a" a less negative number so a is greater then b)
	a = -3 b = -2
	a - b > -3 + 2 < 0 (this means it made "a" a more negative number so a is less then b)
	
	if result < 0 then set slt = 1
	else result >= 0 then set slt = 0
	
    slt = 1 if (a-b) < 0 else 0
	
all this can be simplfied too: 

if (a[31] != b[31])
 slt = a[31]
else
 slt = (a-b)[31]  
 
where we just simplfy assign the sign bit of a to slt if they are different signs (logic still apllies) 
and assign the subtraction of (a-b) sign bit to slt when the signs are the same (base logic)

+ = 0 (sign bit MSB)
- = 1 (sign bit MSB)

a = + b = - 

a[31] = +  , b[31] = -

a < b is indeed false because b is negative 

so slt = + (which is 0) why because a is postive thats why 

a = - b = +  

a[31] = -  , b[31] = +

a < b is indeed true because b is postive 

so slt = - (which is 1) why because a is negative thats why 

but how do we check a[31] != b[31]. we just use the xor logic

**xor(condition, a[31], b[31]);   

this will perform a xor b and store it in condtion. 

now notice if a[31] and b[31] are both 1 (-) or 0 (+) 

then condition will be ..... (recall) 

exlucisve or 

1 xor 1 = 0  
1 xor 0 = 1
0 xor 1 = 1
0 xor 0 = 0 

this is the behaivour we want so "condition" will store 0 or 1 which we can just read as 

meanining if conditon = 1 then both signs are different and if condition = 0 then they are the same 

so the skelton looks as  such: 

xor(condition, a[31], b[31]);

if (condition)
 slt = a[31]
else
 slt = (a-b)[31]   
 
 next we need (a-b) so we will do such: 
 
 wire [31:0] sub_result; 
 wire subd;
 
 assign subd = 1;
 
 yArith arith_unit2(a, b, subd, sub_result, cout); 
 
 xor(condition, a[31], b[31]);
 
 assign slt = (condition) ? a[31]:sub_result[31]

*/
endmodule
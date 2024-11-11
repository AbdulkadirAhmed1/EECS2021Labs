//AUTHOR: ABDULKADIR AHMED
//STUDENT NUMBER: 220526885

//-----------------------------------------------------------------------------yMux1-------------------------------------------------------------------------------

module yMux1(z, a, b, c);

output z;
input a, b, c;

wire notC, upper, lower;
not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);

endmodule

//-----------------------------------------------------------------------------yMux-------------------------------------------------------------------------------

module yMux(z, a, b, c);

parameter SIZE = 2;

output [SIZE-1:0] z;
input [SIZE-1:0] a,b;
input c;

yMux1 general [SIZE-1:0] (z,a,b,c); 

endmodule

//-----------------------------------------------------------------------------yMux4to1-----------------------------------------------------------------------------

module yMux4to1 (z,a0,a1,a2,a3,c);
parameter SIZE = 2;

//logic flow

/*
now that are 4 inputs and  we need to select 1 output that means we have 4 possible outputs

we must break down the inputs 

meaning imagine the possible inputs or (a0, a1, a2, a3) 

we want to narrow this down to 2 possible outputs rather then 4  


so lets say after a proccess below we know have narrowed it down to (a0 , a4)  *by using c[0] (look at side notes)

now that we have 2 possible outputs we can just apply what we have been doing. i.e find z by choosing either a0 or a4 *by using c[1] (look at side notes)
*/

/*

Side Notes: 

c here is the logic core which is know 2 bits which is quite different then before. Note: whenever trying to understand these mux always look at c since c
is the control unit here.

c looks as such c = xx (2 bits)
now notice how c has 4 possible outcomes (10 01 11 00) 2^2 = 4

so now we will break c down to 2 parts c[0] and c[1] 

c[0] the LSB
c[1] the MSB

LSB: this will represent a0 a1 or a2 a3 

zLo: if LSB == 0 we choose a0 a1 (lets name this a wire zLo)
zHi: if LSB == 1 we choose a2 a3 (lets name this a wire zHi)

next 

RSB: this will represent which of the LSB results (possibly two wires to choose from) we choose

if RSB == 0 we choose zLo 
if RSB == 1 we choose zHi


Now note this aren't done by actual if statments rather we just use logic gates

Example:

yMux #(SIZE) lo(zLo, a0, a1, c[0]); 

we enter yMux and have zLo (act as z) a0 (acts as a) and a1 (acts as b) are selelcted inputs LSB is selected as c (can be 0 or 1)

example a0 = 1 a2 = 0 c[0] = 1   
zLo = (1 & !1) | (0 & 1) 
zLo = 0 (so zLo now returns 0) 

we repeat the same for zHi 

now both zHi and zLo either return 0 or 1 

and the final value z 

yMux #(SIZE) final(z, zLo, zHi, c[1]); 

retruns z and zLo (acts a), zHi (acts as b) and c[1] (act as c)

*/

input [SIZE-1:0] a0,a1,a2,a3;
input [1:0] c;

output [SIZE-1:0] z;
wire [SIZE-1:0] zLo, zHi; 

yMux #(SIZE) lo(zLo, a0, a1, c[0]);
yMux #(SIZE) hi(zHi, a2, a3, c[0]);
yMux #(SIZE) final(z, zLo, zHi, c[1]); 

endmodule

//-----------------------------------------------------------------------------yAdder1-----------------------------------------------------------------------------

module yAdder1(a,b,cin,z,cout) ;

//1 bit full adder adder 

input a,b,cin;

output z,cout;

wire result1,result2,result3,z,cout;

//logic gates
 
xor m_xor1(result1,b,a);
and m_and1(result2,b,a);

and m_and2(result3,result1,cin);

xor m_xor2(z,cin,result1);
or m_or1(cout,result3,result2);

endmodule

//-----------------------------------------------------------------------------yAdder-----------------------------------------------------------------------------

module yAdder (a,b,cin,z,cout);
//Hardware module 

output [31:0] z;      // 32-bit output sum
output cout;          // carry-out
input [31:0] a, b;   // 32-bit inputs
input cin;            // initial carry-in
wire [31:0] in, out;  // internal carry-in and carry-out wires

/*
Logic flow:

IMPORTANT: know that all this runs in parallel (so think of the logic as running in parallel) 

yAdder is full  32 bit adder meanining we will carry out the full addition by going bit by bit 32 times 
however we will have to propgate why? because we have paramaters cin and cout which have dependence  
at the start cin is not dependent of cout because it is input paramater however as we continue to do our bit by bit addition
cin will now actually need to be propgated to cout. In simple terms our cin will be the cout from the previous result  

This is what we call the carry chain. So the question is now how do we keep track of the changes of cin because after we 
compute our first result the cin for the second result would be the cout of the first result. The answer is we can use wires along 
with the assign. what assign does is it actually keeps track of changes happens and stores it in the wire. Its simple way of connecting 
cin and cout to wires lets say called in and out. 

Now notice when we Instantiate the 32 1 bit full adder we actually send in the wire in and out as the paramaters instead of cin and cout. 

Why do we did this. Because after it gets result from yAdder1 we immediatly assign it to cin or cout. i.e assign in[...] = cin 

Anoher thing to note is that the first and last in and outs are something we know. we know for sure that the first in would just be the
input cin (the first input). thus we write assign in[0] = cin. We also know that the final carry out is just the final index of out because thats 
the last thing carry out we calculated thus assign cout = out[31]. We make use of those two facts we know  
*/

/*
Notes:

-We know all these run in parallel so instead of being very inefficent and writing all the instantions like i did 
you can use something called a generate block which acts similar to inital (which we used in test benches i.e look LabL files)
in this generate block i can simply define a for loop which will iterate 32 times as i want and it will instantiate it each times.

-just like how we did integer i to define an integer instead we do genvar i to define integer  

-a generate block as something unique about it and that is it will atually store an array of elements that lets say u for loop in 
labeled begin block. i.e adder_chain stores all the elements of the for loop. so i could simplfy reference it as yAdder.adder_chain[0].z 
and it would give me z as i requested from the iteration 0

synthesizable: Can be converted to actual hardware 
non-synthesizable: Can't be converted to actual hardware

-the generate block is specifically for creating synthesizable, parallel hardware structures, unlike initial blocks which are non-synthesizable.  

-the hierarchical access (like yAdder.adder_chain[0].z) is useful both in simulation and in understanding how components are arranged, 
as each generated instance has a unique address.
*/


// Instantiate 32 1-bit full adders using a generate block
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : adder_chain
        yAdder1 mine (
            .a(a[i]),
            .b(b[i]),
            .cin(in[i]),
            .z(z[i]),
            .cout(out[i])
        );
    end
endgenerate


/*
//Instantiate 32 1-bit full adders goofy way bruh );
yAdder1 mine0 (a[0], b[0], in[0], z[0], out[0]);
yAdder1 mine1 (a[1], b[1], in[1], z[1], out[1]);
yAdder1 mine2 (a[2], b[2], in[2], z[2], out[2]);
yAdder1 mine3 (a[3], b[3], in[3], z[3], out[3]);
yAdder1 mine4 (a[4], b[4], in[4], z[4], out[4]);
yAdder1 mine5 (a[5], b[5], in[5], z[5], out[5]);
yAdder1 mine6 (a[6], b[6], in[6], z[6], out[6]);
yAdder1 mine7 (a[7], b[7], in[7], z[7], out[7]);
yAdder1 mine8 (a[8], b[8], in[8], z[8], out[8]);
yAdder1 mine9 (a[9], b[9], in[9], z[9], out[9]);
yAdder1 mine10 (a[10], b[10], in[10], z[10], out[10]);
yAdder1 mine11 (a[11], b[11], in[11], z[11], out[11]);
yAdder1 mine12 (a[12], b[12], in[12], z[12], out[12]);
yAdder1 mine13 (a[13], b[13], in[13], z[13], out[13]);
yAdder1 mine14 (a[14], b[14], in[14], z[14], out[14]);
yAdder1 mine15 (a[15], b[15], in[15], z[15], out[15]);
yAdder1 mine16 (a[16], b[16], in[16], z[16], out[16]);
yAdder1 mine17 (a[17], b[17], in[17], z[17], out[17]);
yAdder1 mine18 (a[18], b[18], in[18], z[18], out[18]);
yAdder1 mine19 (a[19], b[19], in[19], z[19], out[19]);
yAdder1 mine20 (a[20], b[20], in[20], z[20], out[20]);
yAdder1 mine21 (a[21], b[21], in[21], z[21], out[21]);
yAdder1 mine22 (a[22], b[22], in[22], z[22], out[22]);
yAdder1 mine23 (a[23], b[23], in[23], z[23], out[23]);
yAdder1 mine24 (a[24], b[24], in[24], z[24], out[24]);
yAdder1 mine25 (a[25], b[25], in[25], z[25], out[25]);
yAdder1 mine26 (a[26], b[26], in[26], z[26], out[26]);
yAdder1 mine27 (a[27], b[27], in[27], z[27], out[27]);
yAdder1 mine28 (a[28], b[28], in[28], z[28], out[28]);
yAdder1 mine29 (a[29], b[29], in[29], z[29], out[29]);
yAdder1 mine30 (a[30], b[30], in[30], z[30], out[30]);
yAdder1 mine31 (a[31], b[31], in[31], z[31], out[31]);

*/

// First adder's carry-in is cin
assign in[0] = cin;


// Propagate carry between adders (carry-out of one adder is carry-in for the next)
generate
    for (i = 1; i < 32; i = i + 1) begin : carry_chain
        assign in[i] = out[i-1];
    end
endgenerate

/*
//the next carry in is the carry out from the result  
//the old fashinoned way 
assign in[1] = out[0];
assign in[2] = out[1];
assign in[3] = out[2];
assign in[4] = out[3];
assign in[5] = out[4];
assign in[6] = out[5];
assign in[7] = out[6];
assign in[8] = out[7];
assign in[9] = out[8];
assign in[10] = out[9];
assign in[11] = out[10];
assign in[12] = out[11];
assign in[13] = out[12];
assign in[14] = out[13];
assign in[15] = out[14];
assign in[16] = out[15];
assign in[17] = out[16];
assign in[18] = out[17];
assign in[19] = out[18];
assign in[20] = out[19];
assign in[21] = out[20];
assign in[22] = out[21];
assign in[23] = out[22];
assign in[24] = out[23];
assign in[25] = out[24];
assign in[26] = out[25];
assign in[27] = out[26];
assign in[28] = out[27];
assign in[29] = out[28];
assign in[30] = out[29];
assign in[31] = out[30];
*/

// The final carry-out is the carry-out from the last (MSB) adder
assign cout = out[31];

endmodule

//-----------------------------------------------------------------------------yArith-----------------------------------------------------------------------------

module yArith(a,b,ctrl,z,cout);
// add if ctrl=0, subtract if ctrl=1
output [31:0] z;
output cout;
input [31:0] a, b;
input ctrl;
wire[31:0] notB,tmp;
wire cin;

/*
Using negation logic we can easiley find subtraction when using the full adder 
how? Well a + b can also be written as a + (-b) no we can just negate -b. however 
when we take then negation of b we must also 1 this is the rule (recall 2's complmenet) 
Adding this 1 is quite straightforward. Since cin was default of 0 all we do is assign this to our 
'ctrl' value. ctrl can give input of 0 or 1 and if 0 then we do addtion else we do subtraction 
*/

//USING TURNARY:
//assign notB = (ctrl) ? ~b:b; // (when checking (ctrl) it checks if its 1. if i did (~ctrl) it would check if its 0. because ctrl is 1 bit 

//USING MUX:
assign tmp = ~b;
yMux #(.SIZE(32)) myMux(notB,b,tmp,ctrl);
 
assign cin = ctrl;

yAdder myAdder(a, notB, cin, z, cout);

endmodule

//-----------------------------------------------------------------------------yAlu-----------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------N/A-----------------------------------------------------------------------------
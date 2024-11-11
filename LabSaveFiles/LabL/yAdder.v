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

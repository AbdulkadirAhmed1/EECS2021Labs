module LabL;

//AUTHOR: ABDULKADIR AHMED
//STUDENT NUMBER: 220526885

//Terimanl run as such: 

//iverilog -o LabL4.out LabL4.v cpu.v
//iverilog -o LabL4.out LabL4.v yMux4to1.v yMux.v yMux1.v
//vvp LabL4.out

reg[31:0] a0,a1,a2,a3,expect,zLo,zHi;
reg [1:0] c;

wire [31:0] z;
integer i,j,k,counter;

// Here i Instantiate yMux1

yMux4to1 #(.SIZE(32)) myMux(z,a0,a1,a2,a3,c);

initial 

begin


repeat (10) 

begin 

a0 = $random;
a1 = $random;
a2 = $random;
a3 = $random;

c = $random % 4;

#1

//1 = (a0 & ~c[0]) | (a1 & c[0])
//2 = (a2 & ~c[0]) | (a3 & c[0])

// z = (1 & ~c[1]) | (2 & c[1])

/*
//Choice 1:

zLo = (c[0] == 1'b0) ? a0 : a1;
zHi = (c[0] == 1'b0) ? a2 : a3;

expect = (c[1] == 1'b0) ? zLo : zHi;
*/

///*

//Choice 2:

zLo = (a0 & ~{32{c[0]}}) | (a1 & {32{c[0]}});
zHi = (a2 & ~{32{c[0]}}) | (a3 & {32{c[0]}});

expect = (zLo & ~{32{c[1]}}) | (zHi & {32{c[1]}});

//*/

if ((expect == z))
	$display("PASS: a0=%b a1=%b a2=%b a3=%b c=%b z=%b", a0, a1, a2, a3, c, z);
else
	$display("FAIL: a0=%b a1=%b a2=%b a3=%b c=%b z=%b", a0, a1, a2, a3, c, z);

end

$finish;

end


endmodule

module LabL;

//Terimanl run as such: 

//iverilog -o LabL3.out LabL3.v yMux.v yMux1.v
//vvp LabL3.out

reg[31:0] a,b,expect;
reg c;

wire [31:0] z;
integer i,j,k,counter;

// Here i Instantiate yMux1

yMux #(.SIZE(32)) myMux(z,a,b,c);

initial 

begin


repeat (10) 

begin 

a = $random;
b = $random;
c = $random % 2; //why do we do this well %random returns a 32 bit value so if we want to get 1 bit (we find remainder of 32 which gives 0 or 1 (bit))

#1

//z = (a & ~c) | (b & c)
//we must propgate c over 32 bits because its initally just gives us 1 bit and the other 31 or (x: uknown)

expect = (a & ~{32{c}}) | (b & {32{c}});

if ((expect == z))
	$display("PASS: a=%b b=%b c=%b z=%b", a, b, c, z);
else
	$display("FAIL: a=%b b=%b c=%b z=%b", a, b, c, z);

end

$finish;

end


endmodule

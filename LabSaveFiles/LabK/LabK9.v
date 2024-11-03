module labk;

//Name: Abdulkadir Ahmed
//ID: 220526885

reg a,b,cin,flag;
reg[1:0] expect;
integer i,j,k;

wire result1,result2,result3,z,cout;

/*
Logic flow for gates:

result1 comes from b xor a
result2 comes from b and a

**result1 is 2nd input for z

z comes from cin xor result1

**result1 is 1st input for result3

result3 comes from result1 and cin 
 
**result3 is 1st input for cout
**result2 is the 2nd input for cout

cout comes from result3 or result2 
 */
 
//logic gates
 
xor m_xor1(result1,b,a);
and m_and1(result2,b,a);

and m_and2(result3,result1,cin);

xor m_xor2(z,cin,result1);
or m_or1(cout,result3,result2);

initial

begin 
/*
flag = $value$plusargs("a=%b",a);
flag = $value$plusargs("b=%b",b);
flag = $value$plusargs("cin=%b",cin);

if (a === 1'bx || b === 1'bx || cin === 1'bx) 
$display("Not known: a=%b b=%b cin=%b", a, b, cin);
else 
#1

expect[0] = cin ^ (b ^ a);
expect[1] = ((b ^ a) & cin) | (b & a);

if ((expect[0] == z) && (expect[1] == cout))
$display("PASS: a=%b b=%b cin=%b z=%b cout =%b", a, b, cin, z, cout);
else
$display("FAIL: a=%b b=%b cin=%b z=%b cout =%b", a, b, cin, z, cout);

*/

//i is for a 
//j is for b 
//k is for cin 

for (i = 0; i < 2; i = i + 1) 
begin 
	for(j = 0; j < 2; j = j + 1)
	begin
		for (k = 0; k < 2; k = k + 1)
		begin
			a = i;
			b = j;
			cin = k;
			
			#1
			
			expect[0] = cin ^ (b ^ a);
			expect[1] = ((b ^ a) & cin) | (b & a);
			
			if ((expect[0] == z) && (expect[1] == cout))
				$display("PASS: a=%b b=%b cin=%b z=%b cout =%b", a, b, cin, z, cout);
			else
				$display("FAIL: a=%b b=%b cin=%b z=%b cout =%b", a, b, cin, z, cout);
		end
	end
end

$finish;

end 

endmodule
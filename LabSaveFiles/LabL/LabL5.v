module labK;

//Terimanl run as such: 

//iverilog -o LabL5.out LabL5.v yAdder1.v
//vvp LabL5.out

reg a,b,cin,flag;
reg[1:0] expect;
integer i,j,k;

yAdder1 myAdder(a,b,cin,z,cout);

initial 

begin

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
			
			// Check if MSB (expect[1]) differs from cout or LSB (expect[0]) differs from z
			//expect[1] MSB = cout (oracle) 
			//expect[0] LSB = z (oracle) 
			
			if ((expect[0] != z) || (expect[1] != cout))
				$display("FAIL: a=%b b=%b cin=%b z=%b cout =%b", a, b, cin, z, cout);
			else
				$display("PASS: a=%b b=%b cin=%b z=%b cout =%b", a, b, cin, z, cout);
		end
	end
end

$finish;

end

endmodule
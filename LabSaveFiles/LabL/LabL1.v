module LabL;

//Terimanl run as such: 

//iverilog -o LabL1.out LabL1.v
//vvp LabL1.out

reg a,b,c;
wire z;
integer i,j,k;

// Here i Instantiate yMux1

yMux1 myMux(z,a,b,c);splay("a b c | z");
$display("---------");
		
for (i = 0; i < 2; i = i + 1) 
begin 
	for(j = 0; j < 2; j = j + 1)
	begin
		for (k = 0; k < 2; k = k + 1)
		begin
			a = i;
			b = j;
			c = k;
			
			#1
			
			$display("%b %b %b | %b", a, b, c, z);
			
			/*expect[0] = cin ^ (b ^ a);
			expect[1] = ((b ^ a) & cin) | (b & a);
			
			if ((expect[0] == z) && (expect[1] == cout))
				$display("PASS: a=%b b=%b c=%b z=%b cout =%b", a, b, c, z, cout);
			else
				$display("FAIL: a=%b b=%b c=%b z=%b cout =%b", a, b, c, z, cout); 
			*/				
		end
	end
end

$finish;

end


endmodule

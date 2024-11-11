module LabL;

//Terimanl run as such: 

//iverilog -o LabL2.out LabL2.v yMux2.v yMux1.v
//vvp LabL2.out

reg[1:0] a,b;
reg c;

wire [1:0] z;
integer i,j,k,counter;

// Here i Instantiate yMux1

yMux2 myMux(z,a,b,c);

initial 

begin

$display("count | a b c | z");
$display("------------------------");

counter = 0;
		
for (i = 0; i < 4; i = i + 1) 
begin 
	for(j = 0; j < 4; j = j + 1)
	begin
		for (k = 0; k < 2; k = k + 1)
		begin
			a = i[1:0]; //extract the lowest 2 bits
			b = j[1:0]; //extract the lowest 2 bits
			c = k;
			#1
			
			$display("%5d | %b %b %b | %b", counter , a, b, c, z);
			counter = counter + 1;
						
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

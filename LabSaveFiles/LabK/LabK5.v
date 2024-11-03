module labK;

reg a,b, expect;
wire tmp,z;
integer i,j;

not not1(tmp,b);
and and1(z,a,tmp);

initial 
begin
		for (i = 0; i < 2; i = i + 1) 
		begin 
			for (j = 0; j < 2; j = j + 1)
			begin
				a = i; 
				b = j;
				
				#1; // wait for z
				
				expect = i & ~b;
				
				if (expect === z)
					$display("PASS: a=%b b=%b z=%b", a, b, z);
				else
					$display("FAIL: a=%b b=%b z=%b", a, b, z);
			end
		end
		$finish;
end

endmodule
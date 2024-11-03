module labK;

reg a,b;
wire tmp,z;

//logic gates

not not1(tmp,b);
and and1(z,a,tmp);

initial 
begin
	a=1; 
	b=0; 
	
	// not b = 0 (so 1 and 0 = 0) expected result is 0
	//logic gates change whenever the values they store change 
	//i.e we change a = 1 and b = 1 so logic gates will run
	
	//if we delay 1 unit to give time for display to catch up. we would see that z would not be x
	
	$display("a=%b b=%b z=%b",a,b,z);
	//#1 $display("a=%b b=%b z=%b",a,b,z);
	$finish;
end

endmodule


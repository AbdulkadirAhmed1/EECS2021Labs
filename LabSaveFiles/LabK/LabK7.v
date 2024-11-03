module labK;

//Name: Abdulkadir Ahmed
//ID: 220526885

reg a,b,c,flag;
wire tmp,result1,result2,z;

//logic gates

not my_not(tmp,c);
and my_and1(result1,a,tmp);
and my_and2(result2,c,b);

or my_or(z,result1,result2);

initial

begin
flag = $value$plusargs("a=%b",a);
flag = $value$plusargs("b=%b",b);
flag = $value$plusargs("c=%b",c);
	
if (a === 1'bx || b === 1'bx || c === 1'bx) 
$display("Not known: a=%b b=%b c=%b", a, b, c);
else
#1
$display("a=%d b=%d c=%d z=%d",a,b,c,z);

$finish;

end

endmodule
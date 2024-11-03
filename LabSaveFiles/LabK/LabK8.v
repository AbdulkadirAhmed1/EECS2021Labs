module labk;

reg a,b,c,flag,expect;
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
//expect = (a & ~c) | (c & b);

/*logic explained:

if c == 0 we then know only one condtion can pass and  that is the 
(a & ~c) (meaning if a == 0 then it fails) 

if c== 1 we then know only one condtion can pass and  that is the  
(c & b) (meaning if b == 0 then it fails). 

This circut is called a 2-to-1 multiplexor (mux)

*/

if ((c == 1'b1 && b == 1'b1) || (c == 0'b0 && a == 1'b1))
$display("PASS: a=%b b=%b c=%b z=%b", a, b, c, z);
else
$display("FAIL: a=%b b=%b c=%b z=%b", a, b, c, z);

$finish;
					
end 

endmodule
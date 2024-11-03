module labK;

reg a,b,c;
wire tmp,result1,result2,z;

//logic gates

not my_not(tmp,c);
and my_and1(result1,a,tmp);
and my_and2(result2,c,b);

or my_or(z,result1,result2);

initial

begin
a = 1; 
b = 0;
c = 0;

//result1 = a and ~c (1 and 1 = 1)
//result2 = c and b (0 and 0 = 0)
//z = result1 or result2 (1 or 0 = 1)
//z = 1

#1

$display("a=%d b=%d c=%d z=%d",a,b,c,z);
$finish;

end

endmodule
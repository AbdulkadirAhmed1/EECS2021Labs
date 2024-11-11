module yAdder1(a,b,cin,z,cout) ;

//1 bit full adder adder 

input a,b,cin;

output z,cout;

wire result1,result2,result3,z,cout;

//logic gates
 
xor m_xor1(result1,b,a);
and m_and1(result2,b,a);

and m_and2(result3,result1,cin);

xor m_xor2(z,cin,result1);
or m_or1(cout,result3,result2);

endmodule
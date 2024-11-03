module labK;
reg [31:0] x; // a 32-bit register
reg one;
reg [2:0] two;
reg [3:0] three;

initial 

begin
	$display($time, " %h", x); 
	x = 32'hffff0000;
	$display($time, " %h", x); 
	x = x + 2;
	$display($time, " %h", x); 

	one = &x; // and reduction
	two = x[1:0]; // part-select
	three = {one, two}; // concatenate

	$display($time, " %b", one); 
	$display($time, " %b", two); 
	$display($time, " %b", three); 

	$finish;
end

endmodule 
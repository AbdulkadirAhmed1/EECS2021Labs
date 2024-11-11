module labL;
//Testbench

//Terimanl run as such: 

//iverilog -o LabL9.out LabL9.v yAlu.v yArith.v yAdder.v yAdder1.v 
//iverilog -o LabL9.out LabL9.v yAlu.v yMux4to1.v yArith.v yAdder.v yAdder1.v yMux.v yMux1.v
//vvp LabL9.out

reg [31:0] a, b;
reg [31:0] expect;
reg [2:0] op;
wire ex;
wire [31:0] z;
reg ok, flag;
integer identify;
parameter TEST_ITER = 10;

yAlu myAlu(z, ex, a, b, op);

initial begin

repeat (TEST_ITER) begin
  a = $random;
  b = $random;
  flag = $value$plusargs("op=%b", op);  // Get the value of 'op' from command line

  identify = 0;
  
  // ORACLE:
  if (op[2:1] == 2'b00) begin
	// AND or OR operation
	if (op[0] == 1'b0) begin
	  expect = a & b;   // AND operation
	  identify = 1;
	end else  begin
	  expect = a | b;   // OR operation
	  identify = 2;
	end
  end
  else if (op[1:0] == 2'b10) begin
	// ADD or SUB operation
	if (op[2] == 1'b0) begin
	  expect = a + b;   // ADD operation
	  identify = 3;
	end else begin
	  expect = a - b;   // SUB operation
	  identify = 4;
	end
  end
  else if (op == 3'b111) begin
	// SLT is not supported
	expect = 32'b0;
	identify = 5;
  end else begin 
    expect = 32'b0; //All other cases (unsupported opcodes)
	identify = 6;
  end


  #5;

  // Compare the ALU output with the expected output 
  if (op === 3'bxxx) begin 
		ok = 0;   // Fail if opcode is undefined
  end else begin
	 if (z == expect) 
		ok = 1;   // Pass if the output matches
	  else 
		ok = 0;   // Fail if the output does not match
  end

  // Display the result of the comparison and other signals
  if (identify == 1) 
    $display("TYPE: AND, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   $time, a, b, op, expect, z, ok);
  else if (identify == 2)
    $display("TYPE: OR, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   $time, a, b, op, expect, z, ok);
  else if (identify == 3)
    $display("TYPE: ADD, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   $time, a, b, op, expect, z, ok);
  else if (identify == 4)
    $display("TYPE: SUB, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   $time, a, b, op, expect, z, ok);
  else if (identify == 5)
    $display("TYPE: SLT, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   $time, a, b, op, expect, z, ok);
  else 
	$display("TYPE: UKNOWN, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   $time, a, b, op, expect, z, ok);
end

// Finish the simulation
$finish;
end

endmodule

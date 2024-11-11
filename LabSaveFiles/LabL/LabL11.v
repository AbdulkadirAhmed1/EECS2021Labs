module labL;

//AUTHOR: ABDULKADIR AHMED
//STUDENT NUMBER: 220526885

//Testbench

//Terimanl run as such: 

//iverilog -o LabL11.out LabL11.v cpu.v
//iverilog -o LabL11.out LabL11.v yAlu.v yArith.v yAdder.v yAdder1.v 
//iverilog -o LabL11.out LabL11.v yAlu.v yMux4to1.v yArith.v yAdder.v yAdder1.v yMux.v yMux1.v
//vvp LabL11.out

 //Reference: Available opcodes 
 
//000 (AND)
//001 (OR)
//010 (ADD)
//110 (SUB)
//111 (SLT)

reg signed [31:0] a, b;
reg [31:0] expect;
reg [2:0] op;
wire ex;
wire [31:0] z;
reg ok, flag, zero, EXCEPTION; //zero is our test EXCEPTION
integer identify,tmp;
parameter TEST_ITER = 10;

yAlu myAlu(z, ex, a, b, op);

initial begin

repeat (TEST_ITER) begin
  a = $random;
  b = $random;
  flag = $value$plusargs("op=%b", op);  // Get the value of 'op' from command line
  
  tmp = $random % 2;  //Random value to triger excpetion when its 0
  if (tmp == 0) b = a; //Doing this if we subtract (a-b) we should get an exception 
  
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
	// SLT is now supported
	expect = (a < b) ? 1 : 0;
	identify = 5;
  end else begin 
    expect = 32'b0; //All other cases (unsupported opcodes)
	identify = 6;
  end
  
  #5;

  //Oracle check: EXCEPTION output check (in hardware ex = ~|z) which can be written as such
  // however we don't need to use bitwise | we can just say if z == 0 then exception = 1 else set to 0
  
  zero = (expect == 0) ? 1 : 0;
  
  // Compare the ALU output with the expected output 
  if (op === 3'bxxx) begin 
		ok = 0;   // Fail if opcode is undefined
  end else begin
	 if (z == expect) 
		ok = 1;   // Pass if the output matches
	  else 
		ok = 0;   // Fail if the output does not match
  end 
  
  if (zero == ex) EXCEPTION = zero; 

  // Display the result of the comparison and other signals
  if (identify == 1) 
    $display("EXCEPTION:%d ---- TYPE: AND, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   ex,$time, a, b, op, expect, z, ok);
  else if (identify == 2)
    $display("EXCEPTION:%d ---- TYPE: OR, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   ex,$time, a, b, op, expect, z, ok);
  else if (identify == 3)
    $display("EXCEPTION:%d ---- TYPE: ADD, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   ex,$time, a, b, op, expect, z, ok);
  else if (identify == 4)
    $display("EXCEPTION:%d ---- TYPE: SUB, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   ex,$time, a, b, op, expect, z, ok);
  else if (identify == 5)
    $display("EXCEPTION:%d ---- TYPE: SLT, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   ex,$time, a, b, op, expect, z, ok);
  else 
	$display("EXCEPTION:%d ---- TYPE: UKNOWN, Test %0d: a = %d, b = %d, op = %b, expect = %d, z = %d, ok = %b (ok = 1 Success and ok = 0 Failure)", 
		   ex,$time, a, b, op, expect, z, ok);
end

// Finish the simulation
$finish;
end

endmodule

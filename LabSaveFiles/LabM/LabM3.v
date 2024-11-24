module labM;

reg [4:0] rs1,rs2,wn;
reg [31:0] wd;
wire [31:0] rd1,rd2;

//Test Bench:
//iverilog -o LabM3.out LabM3.v SM.v 
//vvp LabM3.out 

reg clk,w,flag;
integer i;

rf myRF(rd1, rd2, rs1, rs2, wn, wd, clk, w);

initial 

begin

flag = $value$plusargs("w=%b", w);

//rs1 and rs2 specify registers to read from (we read values from these registers and output them into rd1 or rd2 for usage) 
//I.e addi x7,x4,x5 (we read from x4 and x5 and put in rd1 and rd2 from usage in this case we will store in x7) 
//wn specifies the register to write to (can write only when wd(32 bits) when w is 1 and rising edge of clock)

//This code be read as the following: 
//Each register from (x0-x31) stores the value of the square of its number i.e x3 stores 3^2 = 9)
//Next we can accesses these by using rs1 and rs2. (The result we can use later on is in rd1 and rd2) 

for (i = 0; i < 32; i = i + 1)
begin
	clk = 0;
	wd = i * i;
	wn = i;
	clk = 1;
	#1;
end

for (i = 0; i < 10; i = i + 1) begin
	rs1 = $random % 32;   
	rs2 = $random % 32;   
	#1;                   
	$display("rs1=%d, rd1=%d | rs2=%d, rd2=%d", rs1, rd1, rs2, rd2);
end

$finish;

end

endmodule
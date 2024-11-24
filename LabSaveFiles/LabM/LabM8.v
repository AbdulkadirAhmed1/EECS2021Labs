module labM;
reg [31:0] PCin;
reg RegWrite, clk, ALUSrc; 
reg[2:0] op,funct3;

wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z;
wire [31:0] jTarget,branch;
wire zero;

//Test Bench:
//iverilog -o LabM8.out LabM8.v cpu.v SM.v
//vvp LabM8.out 

yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);

// Connect write data (output from ALU) to register file
assign wd = z;

initial
begin
//------------------------------------Entry point
PCin = 16'h28;
clk = 0;         // Initialize clock signal
//------------------------------------Run program
repeat (11)
begin
//---------------------------------Fetch an ins
clk = 1; 
#1;
//---------------------------------Detect instruction and set control signals
if (ins[6:0] == 7'h33) begin       // R-Type
	$display("Instruction Type: R-Type (e.g add, or, and)");
	
	funct3 = ins[14:12]; 
	RegWrite = 1; 
	ALUSrc = 0; 
	
	if (funct3 == 3'b110) begin  // OR
        op = 3'b001;  // ALU operation for OR
    end else if(funct3 == 3'b000) begin 
		op = 3'b010; // ADD operation
	end 
end 
else if (ins[6:0] == 7'h3 || ins[6:0] == 7'h13) begin   // I-Type (e.g., LW, addi)
	$display("Instruction Type: I-Type (e.g LW, addi)");
	RegWrite = 1; 
	ALUSrc = 1; 
	op = 3'b010; // ADD for load address calculation
end 
else if (ins[6:0] == 7'h63) begin  // SB-Type (e.g., BEQ)
	$display("Instruction Type: SB-Type (e.g BEQ)");
	RegWrite = 0; 
	ALUSrc = 0; 
	op = 3'b110; // SUB operation for comparison
end 
else if (ins[6:0] == 7'h6f) begin  // UJ-Type (e.g., JAL)
	$display("Instruction Type: UJ-Type (e.g JAL)");
	RegWrite = 1; 
	ALUSrc = 1; 
	op = 3'b010; // ADD for jump target
end
else if (ins[6:0] == 7'h23) begin  // S-Type (e.g., SW)
	$display("Instruction Type: S-Type (e.g SW)");
	RegWrite = 0; 
	ALUSrc = 1; 
	op = 3'b010; // ADD for store address calculation
end
//---------------------------------Execute the ins
clk = 0; 
#1;
//---------------------------------View results
$display("Instruction: %h", ins);
$display("rd1 = %h, rd2 = %h, imm = %h, jTarget = %h", rd1, rd2, imm, jTarget);
$display("z = %h, zero = %b", z, zero);
$display("-------------------------------------------------");

//---------------------------------Prepare for the next instruction
PCin = PCp4;  // Update PC for the next instruction
end

$finish; // End simulation

end
	
endmodule
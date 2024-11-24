module labM;
reg [31:0] PCin;
reg RegWrite, clk, ALUSrc, MemRead, MemWrite , Mem2Reg; 
reg[2:0] op,funct3;
reg [31:0] IC;

wire [31:0] wd, wb, rd1, rd2, imm, ins, PCp4, z, memOut;
wire [31:0] jTarget,branch;
wire zero;

//Test Bench:
//iverilog -o LabM9.out LabM9.v cpu.v SM.v
//vvp LabM9.out 

yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite);
yWB myWB(wb, z, memOut, Mem2Reg);


// Connect write data (output from ALU) to register file
assign wd = wb;

initial
begin
//------------------------------------Entry point
PCin = 16'h28;
clk = 0;         // Initialize clock signal
IC = 0;
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
		
	RegWrite = 1; //Reg Write alllowed
	ALUSrc = 0; // Send rd2 to ALU
	
	if (funct3 == 3'b110) begin  // OR
        op = 3'b001;  // ALU operation for OR
    end else if(funct3 == 3'b000) begin 
		op = 3'b010; // ADD operation
	end 
	
	MemRead = 0; // Tunnel doesnt do anything
	MemWrite = 0; // Tunnel doesnt do anything
	Mem2Reg = 0; // Send ALU result to reg write
end 
else if (ins[6:0] == 7'h3 || ins[6:0] == 7'h13) begin   // I-Type (e.g., LW, addi)
	$display("Instruction Type: I-Type (e.g LW, addi)");
	RegWrite = 1; //Reg Write alllowed
	ALUSrc = 1; // Send immediate to ALU  
	op = 3'b010; // ADD for load address calculation
	
	if (ins[6:0] == 7'h3) begin //LW
		$display("Sub-Type: Load Word");
	    MemRead = 1; //Allow to read from memory 
		MemWrite = 0; //Not allowed to write
		Mem2Reg = 1; // Send memory result to reg write
	end 
	else if (ins[6:0] == 7'h13) begin  //addi
		$display("Sub-Type: Add Immediate");
		MemRead = 0; // Tunnel doesnt do anything
		MemWrite = 0; // Tunnel doesnt do anything
		Mem2Reg = 0; // Send ALU result to reg write
	end
end 
else if (ins[6:0] == 7'h63) begin  // SB-Type (e.g., BEQ)
	$display("Instruction Type: SB-Type (e.g BEQ)");
	RegWrite = 0; //Reg Write not allowed
	ALUSrc = 0; //Send rd2 to ALU
	op = 3'b110; // SUB operation for comparison
	MemRead = 0; // Tunnel doesnt do anything
	MemWrite = 0; // Tunnel doesnt do anything
	Mem2Reg = 0; // Tunnel doesnt do anything
end 
else if (ins[6:0] == 7'h6f) begin  // UJ-Type (e.g., JAL)
	$display("Instruction Type: UJ-Type (e.g JAL)");
	RegWrite = 1; //Reg write allowed
	ALUSrc = 1; //Send immediate to ALU
	op = 3'b010; // ADD for jump target
	MemRead = 0; // Tunnel doesnt do anything
	MemWrite = 0; // Tunnel doesnt do anything
	Mem2Reg = 0; // Send ALU result to reg write
end
else if (ins[6:0] == 7'h23) begin  // S-Type (e.g., SW)
	$display("Instruction Type: S-Type (e.g SW)");
	RegWrite = 0; 
	ALUSrc = 1; 
	op = 3'b010; // ADD for store address calculation
	
	MemRead = 0; //Not allowed to read from memory 
	MemWrite = 1; //Allow to write
	Mem2Reg = 0; // Tunnel doesnt do anything
end
//---------------------------------Execute the ins
clk = 0; 
#1;
//---------------------------------View results
IC = IC + 1;
$display("Current PC: %d, Next PC: %d", PCin, PCp4);
$display("Instruction %d: %h", IC, ins);
$display("rd1 = %h, rd2 = %h, imm = %h, jTarget = %h", rd1, rd2, imm, jTarget);
$display("z = %h, zero = %b wb=%2d", z, zero, wb);
$display("-------------------------------------------------");

//---------------------------------Prepare for the next instruction
PCin = PCp4;  // Update PC for the next instruction
end

$finish; // End simulation

end
	
endmodule
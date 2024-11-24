module labM;
reg [31:0] PCin,addr;
reg RegWrite, clk, ALUSrc, MemRead, MemWrite , Mem2Reg; 
reg[2:0] op,funct3;
reg [31:0] IC;
reg [31:0] finalResults1,finalResults2;

wire [31:0] wd, wb, rd1, rd2, imm, ins, PCp4, z, memOut, memOut_verify;
wire [31:0] jTarget,branch;
wire zero;

//Test Bench:
//iverilog -o LabM10.out LabM10.v cpu.v SM.v
//vvp LabM10.out 

yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite);
yWB myWB(wb, z, memOut, Mem2Reg);

yDM myDM_verify(memOut_verify, addr, rd2, clk, 1, 0);  // Verification instance

// Connect write data (output from ALU) to register file
assign wd = wb;

initial
begin
//------------------------------------Entry point
PCin = 16'h28;
clk = 0;         // Initialize clock signal
IC = 0;
finalResults1 = 0;
finalResults2 = 0;

//------------------------------------Run program
repeat (43)
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
        $display("Sub-Type: or (OR)");
        op = 3'b001;  // ALU operation for OR
    end else if(funct3 == 3'b000) begin 
	    $display("Sub-Type: add (ADD)");
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
		$display("Sub-Type: lw (LOAD WORD)");
	    MemRead = 1; //Allow to read from memory 
		MemWrite = 0; //Not allowed to write
		Mem2Reg = 1; // Send memory result to reg write
	end 
	else if (ins[6:0] == 7'h13) begin  //addi
		$display("Sub-Type: addi (ADDI)");
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
$display("Instruction %d: %h", IC, ins);
$display("rd1 = %h, rd2 = %h, imm = %h, jTarget = %h", rd1, rd2, imm, jTarget);
$display("z = %h, zero = %b wb=%2d MemWrite=%d", z, zero, wb, MemWrite);
$display("-------------------------------------------------");

if (ins[6:0] == 7'h23) begin
    if (finalResults1 == 0) begin 
	    finalResults1 = rd2;
	end 
	else begin 
	     finalResults2 = rd2;
	end
end

//---------------------------------Prepare for the next instructiona

$display("Current PC: %d", PCin);

if (ins[6:0] == 7'h63 && zero == 1) begin //BEG
	PCin = PCin + (branch << 2); // Branch target
end else if (ins[6:0] == 7'h6f) begin //JAL
	PCin = PCin + (jTarget << 2); // Jump target
end else begin
	PCin = PCp4; // Default: Increment PC
end

$display("Current PC: %d", PCin);

end

//------------------------------------End of program

//$display("Final result: SUM: %h, OR reduction: %h", finalResults1,finalResults2);

// Verify the stored values by reading them back from memory
$display("Verifying stored values...");

// First value verification
addr = 16'h20;      // Address where the first value was stored (z = 0x20 from the store instruction)
clk = 1; #1; clk = 0;  // Perform read operation
$display("Read Back Value from Address %h: %h", addr, finalResults1);

// Second value verification (if applicable)
addr = 16'h24;      // Address where the second value was stored (example: if another store used this address)
clk = 1; #1; clk = 0;  // Perform read operation
$display("Read Back Value from Address %h: %h", addr, finalResults2);

$finish; // End simulation

end
	
endmodule
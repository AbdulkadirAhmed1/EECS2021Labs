module labM;
reg clk, read, write;
reg [31:0] address, memIn;
reg [6:0] opcode;
reg [2:0] funct3;
wire [31:0] memOut;

//Test Bench:
//iverilog -o LabM6.out LabM6.v SM.v 
//vvp LabM6.out 

mem data(memOut, address, memIn, clk, read, write);

initial clk = 0;

always begin
#5 clk = ~clk;  
end

initial begin 
	address = 32'h28; 
	write = 0;       
	read = 1;   
    opcode = 0;	

	$display("Fetching instructions from memory...");
	$display("Address     Instruction");
	
	/*
	 The instructions are categorized as:
	  - R-Type
	  - I-Type
	  - S-Type
	  - SB-Type
	  - UJ-Type
	Unrecognized opcodes result in an error message.

	KEY FEATURES:
	1. **Clock Generation**:
	   - A clock signal (`clk`) is toggled every 5 time units using an `always` block.
	   - This drives the synchronous components like memory access.

	2. **Memory Access**:
	   - The `mem` module is instantiated to fetch instructions from memory.
	   - Memory is accessed via the `address` signal, and the output (`memOut`) holds the fetched instruction.
	   - Only read operations (`read=1`) are enabled in this simulation, with write operations (`write=0`) disabled.

	3. **Instruction Fetching**:
	   - The `address` signal is initialized to `0x28`, simulating the starting address of the Program Counter (PC).
	   - Instructions are fetched sequentially from memory by incrementing the `address` by 4 bytes in each iteration.

	4. **Instruction Decoding**:
	   - The `opcode` field (bits [6:0]) of the fetched instruction is used to determine the instruction format.
	   - Decoding logic extracts fields specific to the instruction type:
		 - **R-Type**: Uses `funct3`, `funct7`, and register fields (`rd`, `rs1`, `rs2`).
		 - **I-Type**: Uses `funct3`, register fields (`rd`, `rs1`), and immediate (`imm`).
		 - **S-Type**: Uses `funct3`, register fields (`rs1`, `rs2`), and immediate (`imm`).
		 - **SB-Type**: Uses `funct3`, register fields (`rs1`, `rs2`), and branch offset (`imm`).
		 - **UJ-Type**: Uses `rd` and jump offset (`imm`).
	   - Decoded instructions are displayed in a human-readable format.

	5. **Error Handling**:
	   - If the `opcode` does not match any known format, an error message is displayed with the `opcode`, `address`, and the raw instruction.

	6. **Simulation Control**:
	   - The simulation fetches and decodes 11 instructions in a loop.
	   - After processing all instructions, the simulation ends with `$finish`. 
	   
	   NOTES:
		- The `address` acts as the Program Counter (PC), incrementing sequentially to fetch instructions in order.
		- This testbench focuses on decoding instructions; branching and other control flow mechanisms are not implemented.
		- The `mem` module is assumed to simulate the instruction memory, and its contents must be preloaded.

		EXAMPLE (not output):
		Address     Instruction
		0x00000028  R-Type: rd=t5, rs1=x0, rs2=x0, funct3=000, funct7=0000000, opcode=0110011
		0x0000002C  R-Type: rd=s0, rs1=x0, rs2=x0, funct3=000, funct7=0000000, opcode=0110011
	*/

	repeat (11) begin
		#10; // Wait for one clock cycle
		//$display("%h      %h", address, memOut); 
		
		opcode = memOut[6:0];
		
		if (opcode == 7'b1101111) begin
		    //opcode is 6f means its UJ type 
			//UJ format doesn't have funct3
			
			$display("%h      UJ-Type: rd=%h, imm=%h, opcode=%h", address, memOut[11:7], 
                         {memOut[31], memOut[19:12], memOut[20], memOut[30:21]},opcode);
		end 
		else begin 
		    funct3 = memOut[14:12]; 
			
			if (opcode == 7'b0110011) begin
				//opcode is 33 means its R type
				
				 $display("%h      R-Type: rd=%h, rs1=%h, rs2=%h, funct3=%h, funct7=%h, opcode=%h", 
                             address, memOut[11:7], memOut[19:15], memOut[24:20], funct3, memOut[31:25],opcode);
			end 
			else if(opcode == 7'b0000011 || opcode == 7'b0010011) begin 
				//opcode is 03 or 13 means its I type (addi or lw)
				
				$display("%h      I-Type: rd=%h, rs1=%h, funct3=%h, imm=%h, opcode=%h", 
                             address, memOut[11:7], memOut[19:15], funct3, memOut[31:20],opcode);
			end
			else if(opcode == 7'b1100011) begin 
				//opcode is 63 means its SB type
				
				 $display("%h      SB-Type: rd=%h, rs1=%h, rs2=%h, funct3=%h, imm=%h, opcode=%h", 
                             address, 2'h0, memOut[19:15], memOut[24:20], funct3, 
                             {memOut[31], memOut[7], memOut[30:25], memOut[11:8]},opcode);
			end
			else if(opcode == 7'b0100011) begin 
				//opcode is 23 means its S type
				
				$display("%h      S-Type: rd=%h, rs1=%h, rs2=%h, funct3=%h, imm=%h", 
                             address, 2'h0, memOut[19:15], memOut[24:20], funct3, {memOut[31:25], memOut[11:7]});
			end
			else begin
				$display("Error: Unrecognized opcode %b at address %h with instruction %b", opcode, address,memOut);
			end
		end
		
		address = address + 4;  //Acts as PC > The next line is PC += 4 (without branching) 
	end

$finish;
end

endmodule
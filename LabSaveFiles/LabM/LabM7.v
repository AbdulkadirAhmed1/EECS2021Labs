module labM;
reg [31:0] PCin;          // Input: Initial value of PC
reg clk;                  // Clock signal
wire [31:0] ins, PCp4;    // Outputs: Fetched instruction and PC + 4

//Test Bench:
//iverilog -o LabM7.out LabM7.v cpu.v SM.v
//vvp LabM7.out 

// Instantiate yIF module
yIF myIF(ins, PCp4, PCin, clk);

// Generate a clock signal
always begin
	#5 clk = ~clk;  // Toggle clock every 5 time units (10 time unit period)
end

initial begin
     /*
		We are tasked to fetch instructions from instuction memory using a provided `yIF` module and simulate the sequential 
		execution of instructions by incrementing the Program Counter (PC) after each fetch.

		KEY FEATURES:
		1. **Clock Signal Generation**:
		- A clock signal (`clk`) is toggled every 5 time units using an `always` block, simulating a clock period of 10 time units.
		- The `clk` signal drives the `yIF` module, ensuring synchronous operation.

		2. **Instruction Fetch (`yIF` Module)**:
		- The `yIF` module simulates the Instruction Fetch stage by:
		- Fetching the instruction (`ins`) stored in memory at the address specified by `PCin`.
		- Computing `PCp4` (the address of the next instruction) as `PCin + 4`.

		3. **Program Counter (PC)**:
		- The Program Counter (`PCin`) is initialized to `0x28` (hexadecimal).
		- After fetching each instruction, `PCin` is updated to `PCp4` to simulate sequential instruction execution.

		4. **Simulation Flow**:
		- The simulation fetches and prints 11 instructions sequentially.
		- After fetching each instruction, the `PCin` is updated, and the next instruction is fetched in the following clock cycle.
		- The simulation terminates after processing 11 instructions. 
		
		NOTES:
		- The `yIF` module must correctly implement instruction fetch functionality, including memory access and PC increment logic.
		- The instructions fetched depend on the contents of the simulated instruction memory. 
		
		EXAMPLE OUTPUT:
		Assuming the instruction memory contains the following values:
		- At address `0x28`: `00000F33` (add t5, x0, x0)
		- At address `0x2C`: `00000433` (add s0, x0, x0)

		The output would look like this:
		PCin = 00000028, instruction = 00000F33
		PCin = 0000002C, instruction = 00000433
		PCin = 00000030, instruction = 00000533
	*/
	//------------------------------------Entry point
	PCin = 16'h28;       // Initialize PC to 0x28 (starting address)
	clk = 0;             // Initialize clock signal

	//------------------------------------Run program
	repeat (11) begin    // Simulate fetching 11 instructions
		#10  // Wait for the rising edge of the clock
		//---------------------------------View results
		$display("PCin = %h, instruction = %h", PCin, ins);
		PCin = PCp4;     // Update PCin to the next sequential address
	end

	$finish;             // End the simulation
end
endmodule
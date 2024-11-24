module labM;
reg clk, read, write;
reg [31:0] address, memIn;
wire [31:0] memOut;

//Test Bench:
//iverilog -o LabM5.out LabM5.v SM.v 
//vvp LabM5.out 

mem data(memOut, address, memIn, clk, read, write);

initial clk = 0;

//Here we setup are clock simply. We use the same technique we saw in LabM4 
always begin
#5 clk = ~clk;  
end

initial begin 
    /*In this test bench we actually will be immiating the behaviour of IF (Instruction Fetch) datapath. 
	 What Instrution Fetch does is it fetches the instruction from the instruction memory (ram.data in our case) 
	 Using the PC counter... (in which this case address really immiates this behaviour)  
	 In ram.dat we find that at the very top we store our more required memory i.e (DW 1, 3, 5, 7, 9, 11, 0) 
	 In which it selfs actually stores two elements at once if you notice in RISK V 
	 After that we have to actually decode our instructions and put it in ram.dat with hexadecimal (which represents a 32 bit value) 
	 Later on we can use this in the ID (instruction decode phase... We will talk about this later) 
	 
	 in ram.dat our memory would look like this: 
	 
		@00 00000001 // array[0]
		@04 00000003 // array[1]
		@08 00000005 // array[2]
		@0C 00000007 // array[3]
		@10 00000009 // array[4]
		@14 0000000B // array[5]
		@18 00000000 // null terminator
		@20 00000000 // the sum
		@24 00000000 // the or reduction
		@28 00000F33 // add t5, x0, x0 # index
		@2C 00000433 // add s0, x0, x0 # sum
		@30 00000533 // add a0, x0, x0 # or reduction
		@34 000F2283 // lw t0, 0(t5) # loop: t0 = array[t5]
		@38 00028563 // beq t0, x0, DONE # if (t0 == 0) done
		@3C 00540433 // add s0, s0, t0 # sum += t0
		@40 00556533 // or a0, a0, t0 # a0 |= t0
		@44 004F0F13 // addi t5, t5, 4 # t5++
		@48 FF7FF06F // jal x0, LOOP # jump back to LOOP
		@4C 02802023 // sw s0, 0x20(x0) # store sum
		@50 02A02223 // sw a0, 0x24(x0) # store OR reduction
		
		First key element to not is our memory goes from 0x0 to 0x50 which is clear in the listing window in risk v. Next is the actual value
		stored in the addresses. 
		
		In this case we would have to decode the format, find the binary for each attribute (i.e opcode, rd, rs1, funct7, ....) 
		by encoding it. and assemble them to final 32 binary which is how its given in the listing table. 
		
		lets try an example:
		
		Example:  sw a0,36(x0) which can be wirtten as sw x10 x0 0x024 
		
		Decoding format: The sw (store word) instruction uses the S-type format, which has the following fields: 
		
		imm[11:5]	rs2	  rs1	funct3	 imm[4:0] opcode
		7 bits	5 bits	5 bits	3 bits	5 bits	7 bits
		
		Encoding fields: 
		
		a0 (data to store) → rs2 = x10 → Binary: 01010 
		x0 (base register) → rs1 = x0 → Binary: 00000 
		Immediate value 0x24 (offset) → Binary: 000000000100100 
		   Split into:
				imm[11:5] (upper 7 bits) = 0000000
				imm[4:0] (lower 5 bits) = 10010
		funct3 = 010 
		opcode = 0100011 
		
		Assembling fields:
		
		Our final binary in the S format is such: 
		
		0000001 01010 00000 010 10010 0100011 
		
		Convert it to hexadecimal it is: 0x2A02223 which we can just sign extend to 0x02A02223 because we need it contain 8 hexadeicmals (32 bits) for ram.dat
		
	    IMPORTANT: NOTICE in risk V how you see the excat same binary. This means that you wouldn't need to do this for every instruction but this is good
		way of understanding the decoding and encoding proccess of insturction. 
	*/
	address = 32'h28; 
	write = 0;       
	read = 1;        

	$display("Fetching instructions from memory...");
	$display("Address     Instruction");

	repeat (11) begin
		#10; // Wait for one clock cycle
		$display("%h      %h", address, memOut); 
		address = address + 4;  //Acts as PC > The next line is PC += 4 (without branching) 
	end

	$finish;
end
endmodule

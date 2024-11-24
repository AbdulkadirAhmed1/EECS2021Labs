module labM;

reg clk, read, write;
reg [31:0] address, memIn;
wire [31:0] memOut;

//Test Bench:
//iverilog -o LabM4.out LabM4.v SM.v 
//vvp LabM4.out 

// Instantiate memory module
mem data(memOut, address, memIn, clk, read, write);

// Clock generation
always begin
#5 clk = ~clk;  
//Here the half clock period that we use is 5. so clock period would be 5*2 = 10.
//This means that to go from 0 to 1 then 1 to 0 would take as 10 units
//This will be important to know later on..
end

initial begin
// Initialize signals (always initialize. why? because we don't want unknown values)
clk = 0;
read = 0;
write = 0;
address = 0;
memIn = 0;

// We know want to start writting into our memory thus we set "write" to 1
write = 1;

// Write value 32'h12345678 at address 16
address = 16;
memIn = 32'h12345678;
#10;  //What i meant before is being applied here. we know that a full clock period i.e to reach the rising edge is 10 units 
//So knowing this we will wait till we reach the rising edge again to write data into memory 

//Know we are in the next rising edge so we are allowed in write data:

// Write value 32'h89abcdef at address 24
address = 24;
memIn = 32'h89abcdef;
#10;  // Another full clock cycle for this write to complete (repeat from before)

//Unallighed write address test: 

address = 17; // Unaligned address (not divisible by 4)
memIn = 32'hdeadbeef; 
//This will cause Unaligned Store Address msg 
#10 

// Disable write signal before reading because now we wanna read our data 
write = 0;

// Enable read and start reading from address 16
read = 1; 
address = 16;
#5; // Wait half a clock period to align with the falling edge of the clock.
// Reading on the falling edge is not strictly required but is a neat way to keep "read" operations consistent.
// This approach has advantages, such as avoiding potential conflicts with "write" operations on the rising edge.
// Additionally, aligning reads with the falling edge can help with prediction and timing consistency.

// Read the three consecutive memory addresses
repeat(3) begin
  #10;  // Delay between each memory read (since we are originally at the falling edge. to go from falling edge to falling edge we 
  //wait the clock period which is 10 units)
  $display("Address %d contains %h", address, memOut);
  address = address + 4;  // Move to the next word address
end

#10 

//Unallighed read address test: 

address = 18; 
//$display("Address %d contains %h", address, memOut);
//This will cause Unaligned Load Address msg 

#10 

read = 0; //Set read to 0

$finish;  // End simulation

end

endmodule

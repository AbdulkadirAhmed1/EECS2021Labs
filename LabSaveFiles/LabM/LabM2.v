module labM;
reg [31:0] d;
reg clk, enable, flag;
wire [31:0] z;
reg [31:0] e;

//Test Bench:
//iverilog -o LabM2.out LabM2.v SM.v 
//vvp LabM2.out 

register #(32) mine(z, d, clk, enable);

initial 

begin 

clk = 0;
flag = $value$plusargs("enable=%b", enable);

$display("enable = %b", enable);

//Note there is a difference between 
/*
if () 
.....A 
....B

and

if () begin 
...A
....B
end
...C

In the first one A runs as if the condtion runs however B runs regardless. 
While in the 2nd case A and B run if condtion is met. And C runs regardless 
*/

if (!flag) 
        enable = 0; // Default to 0 if no command-line argument is passed
		
    $display("enable = %b", enable);  // Debugging line to print the value of enable
end 

initial 
repeat (20)
begin
#2 d = $random;
end

always
begin
#5 clk = ~clk;
end

//e = (clk) ? (enable ? d : e) : e; INCORRECT: Why? This will cause lots of unexpeted behaviour altougth the logic is right this isn't the way to apply it
//We have to be able to define whether we are at rising or decending edge of the clock i.e (posedge clk or negedge clk).  
//Thus:

// Update e based on clk and enable:

/*
posedge clk: Executes on the rising edge of the clock (when clk changes from 0 to 1).
negedge clk: Executes on the falling edge of the clock (when clk changes from 1 to 0).
*/
always @ (posedge clk) begin
if (enable) begin
  e <= d;  // If enable is 1, the expected output is the value of d (non-blocking updates)
  //e = d; // If enable is 1, the expected output is the value of d (blocking updates)
  /*
  <= does not mean "less then or equal" this is an non-blocking assigment operator
  What does non-blocking assigmnent operator mean? Well this means "<=" only updates after 
  the defined clock cycle (in our case rising edge) while "="  updates almost immediatly.
  **To see what i mean uncomment e = d and check output.** HOWEVER NOTE: 
  In this always block. it only runs once as soon as 0 change to 1 (RISING EDGE) so it doesn't account 
  when 1 is just 1 or 0 is 0 or 1 changes to 0 (falling edge). THUS even if you uncomment e = d; it wouldn't change anything
  <= is non-blocking assignment (used for sequential logic and in clocked always blocks).
  = is blocking assignment (used for combinational logic and simple immediate assignments).
  */
  /*
  Summary:
    Non-blocking assignment (<=) schedules the update of e at the end of the current simulation time step (after the clock edge).
    his means it will take effect in the next clock cycle, allowing for sequential behavior (like flip-flops).
    Blocking assignment (=) updates e immediately during the current simulation time step.
    This can cause problems if used in sequential logic, as it can lead to unintended results during the same clock cycle.
  */
end
// If enable is 0, e should remain the same (register doesn't change)
end

initial
$monitor("%5d: clk=%b,d=%d,z=%d,expect=%d", $time,clk,d,z, e);

initial begin
    #20; 
    $finish;  
  end

endmodule
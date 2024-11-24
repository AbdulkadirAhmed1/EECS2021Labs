module labM;
reg [31:0] d;
reg clk, enable, flag;
wire [31:0] z;

//Test Bench:
//iverilog -o LabM1.out LabM1.v SM.v 
//vvp LabM1.out 

register #(32) mine(z, d, clk, enable);

initial
begin
flag = $value$plusargs("enable=%b", enable);
d = 15; clk = 0; #1;
$display("clk=%b d=%d, z=%d", clk, d, z);
d = 20; clk = 1; #1;
$display("clk=%b d=%d, z=%d", clk, d, z);
d = 25; clk = 0; #1;
$display("clk=%b d=%d, z=%d", clk, d, z);
d = 30; clk = 1; #1;
$display("clk=%b d=%d, z=%d", clk, d, z);

$finish;
end

endmodule
module yArith(a,b,ctrl,z,cout);
// add if ctrl=0, subtract if ctrl=1
output [31:0] z;
output cout;
input [31:0] a, b;
input ctrl;
wire[31:0] notB;
wire cin;

assign notB = (ctrl) ? ~b:b; // (when checking (ctrl) it checks if its 1. if i did (~ctrl) it would check if its 0. because ctrl is 1 bit 
assign cin = ctrl;

yAdder myAdder(a, notB, cin, z, cout);

endmodule
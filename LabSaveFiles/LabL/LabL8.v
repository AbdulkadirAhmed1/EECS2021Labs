module LabL;
//Testbench

//Terimanl run as such: 

//iverilog -o LabL8.out LabL8.v yArith.v yAdder.v yAdder1.v
//vvp LabL8.out

reg signed [31:0] a, b;    
reg ctrl;             
wire signed [31:0] z;       
wire cout;         

reg signed [31:0] expect;   
reg ok;             

yArith myArith(a, b, ctrl, z, cout);

initial begin
    repeat(10) begin  
		ctrl = $random % 2;  // Set carry-in to 0
	
        a = $random;
        b = $random;
		
        expect = (ctrl) ? a - b : a + b;
        
        #10; // Wait for the result to propagate (10 units of delay because we are dealing with larger calculations)

        // Check if the obtained sum matches the expected sum
        ok = (expect === z);

        if (ok) begin
            $display("Test Passed: ctrl = %d a = %d, b = %d, z = %d",ctrl, a, b, z);
        end else begin
            $display("Test Failed: ctrl = %d a = %d, b = %d, z = %d (Expected: %d)",ctrl, a, b, z, expect);
        end
    end
end

endmodule

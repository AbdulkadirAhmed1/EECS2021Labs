module LabL;
// Testbench

// Terminal run as such: 
// iverilog -o LabL6.out LabL6.v yAdder.v yAdder1.v
// vvp LabL6.out

reg [31:0] a, b;    
reg cin;             
wire [31:0] z;       
wire cout;           

reg [31:0] expect;  
reg ok;              

// Instantiate the yAdder module
yAdder myAdder(a, b, cin, z, cout);

initial begin
    cin = 0;  // Set carry-in to 0

    repeat(10) begin  
        a = $random;
        b = $random;
        expect = a + b + cin;
        
        #10; // Wait for the result to propagate (10 units of delay because we are dealing with larger calculations)

        // Check if the obtained sum matches the expected sum
        ok = (expect === z);

        if (ok) begin
            $display("Test Passed: a = %d, b = %d, z = %d", a, b, z);
        end else begin
            $display("Test Failed: a = %d, b = %d, z = %d (Expected: %d)", a, b, z, expect);
        end
    end
end


endmodule

module LabL;
//Testbench

//Terimanl run as such: 

//iverilog -o LabL7.out LabL7.v yAdder.v yAdder1.v
//vvp LabL7.out

/*
Side comments: Now that we are dealing with signed bits. We must consider overflow and how it works. i.e 

Addition: Overflow occurs when the sum exceeds the range of a signed 32-bit integer (-2^31 to 2^31 - 1), which is between -2147483648 and 2147483647.

Subtraction: Overflow occurs when the result exceeds the range of a signed 32-bit integer, either going below -2147483648 or above 2147483647.

How how we handle overflow: (its simple) 

If the result is too large (positive overflow):   

(1) Addition: When the result of addition is greater than 2147483647, it wraps around and becomes negative. You subtract 2^32 to adjust it back within the range.
(2) Subtraction: If the result of subtraction is greater than 2147483647, it wraps around and becomes negative. You subtract 2^32 to adjust it back within the range. 

If the result is too small (negative overflow): 

(3) Addition: When the result of addition is less than -2147483648, it wraps around and becomes positive. You add 2^32 to adjust it back within the range.
(4) Subtraction: If the result of subtraction is less than -2147483648, it wraps around and becomes positive. You add 2^32 to adjust it.

Example: 

a+b= −1064739199 + (−2071669239) = −3136408438

The result -3136408438 is below the lower bound of a signed 32-bit integer (-2147483648), indicating overflow (negative).

Thus we do overflow adjustment (apply (3)): 

−3136408438 + 2^32 = −3136408438 + 4294967296 = 1158558858

expected result = 1158558858

*/

reg signed [31:0] a, b;    
reg cin;             
wire signed [31:0] z;       
wire cout;         

reg signed [31:0] expect;   
reg ok;             

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

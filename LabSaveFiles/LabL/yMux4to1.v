module yMux4to1 (z,a0,a1,a2,a3,c);
parameter SIZE = 2;

//logic flow

/*
now that are 4 inputs and  we need to select 1 output that means we have 4 possible outputs

we must break down the inputs 

meaning imagine the possible inputs or (a0, a1, a2, a3) 

we want to narrow this down to 2 possible outputs rather then 4  


so lets say after a proccess below we know have narrowed it down to (a0 , a4)  *by using c[0] (look at side notes)

now that we have 2 possible outputs we can just apply what we have been doing. i.e find z by choosing either a0 or a4 *by using c[1] (look at side notes)
*/

/*

Side Notes: 

c here is the logic core which is know 2 bits which is quite different then before. Note: whenever trying to understand these mux always look at c since c
is the control unit here.

c looks as such c = xx (2 bits)
now notice how c has 4 possible outcomes (10 01 11 00) 2^2 = 4

so now we will break c down to 2 parts c[0] and c[1] 

c[0] the LSB
c[1] the MSB

LSB: this will represent a0 a1 or a2 a3 

zLo: if LSB == 0 we choose a0 a1 (lets name this a wire zLo)
zHi: if LSB == 1 we choose a2 a3 (lets name this a wire zHi)

next 

RSB: this will represent which of the LSB results (possibly two wires to choose from) we choose

if RSB == 0 we choose zLo 
if RSB == 1 we choose zHi


Now note this aren't done by actual if statments rather we just use logic gates

Example:

yMux #(SIZE) lo(zLo, a0, a1, c[0]); 

we enter yMux and have zLo (act as z) a0 (acts as a) and a1 (acts as b) are selelcted inputs LSB is selected as c (can be 0 or 1)

example a0 = 1 a2 = 0 c[0] = 1   
zLo = (1 & !1) | (0 & 1) 
zLo = 0 (so zLo now returns 0) 

we repeat the same for zHi 

now both zHi and zLo either return 0 or 1 

and the final value z 

yMux #(SIZE) final(z, zLo, zHi, c[1]); 

retruns z and zLo (acts a), zHi (acts as b) and c[1] (act as c)

*/

input [SIZE-1:0] a0,a1,a2,a3;
input [1:0] c;

output [SIZE-1:0] z;
wire [SIZE-1:0] zLo, zHi; 

yMux #(SIZE) lo(zLo, a0, a1, c[0]);
yMux #(SIZE) hi(zHi, a2, a3, c[0]);
yMux #(SIZE) final(z, zLo, zHi, c[1]); 

endmodule
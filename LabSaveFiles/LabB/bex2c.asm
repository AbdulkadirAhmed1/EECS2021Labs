vec1:   DD 1, 5, -7, 23, -5, 0        
vec2:   DD 3, -2, 4, 11, -7, 0        
add  x6, x0, x0             
loop:
ld x4, vec1(x6)              
beq x4, x0, end               
ld x5, vec2(x6)             
beq x5, x0, end                
add x7, x4, x5                
sd x7, result(x6)         
addi x6, x6, 8                
jal x0, loop           
end:
ebreak  x0, x0, 0                
result: DD 0, 0, 0, 0, 0, 0           

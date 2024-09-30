src: DD 121, 33, -5, 242, -45, -12, 0
add x6, x0, x0
loop: ld x4, src(x6)
beq x4, x0, end
bge x4, x7, greater
add x7,x0,x4
add x9,x0,x6
addi x6, x6, 8
add x5,x0,x4
jal x0, loop 
greater: 
add x7,x0,x4
addi x6, x6, 8
beq x0, x0, loop
end: 
ld x10,0(x0) // x0 + 0 offset we are given this because "integer in the beginning of the sequence"
sd x5,0(x0) // x0 + 0 offset we are given this because "integer in the beginning of the sequence"
sd x10,0(x9)
ebreak x0, x0, 0
dst: DM 1 
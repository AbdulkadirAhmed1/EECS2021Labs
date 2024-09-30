src: DD -1, 55, -3, 7, 0
add x6, x0, x0
loop: ld x4, src(x6)
beq x4, x0, end
bge x4, x5, greater
sd x4, dst(x6)
add x7,x0,x4
addi x6, x6, 8
jal x0, loop 
greater: sd x4, dst(x6)
add x7,x0,x4
addi x6, x6, 8
add x5,x0,x4
beq x0, x0, loop
end: ebreak x0, x0, 0
dst: DM 1 
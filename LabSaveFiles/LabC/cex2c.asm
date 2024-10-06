str1: DC "Hello"
str2: DC " World"

// to create an appended string 
// we must fill the LMB zeros with the 
// appended string RMB bits 
//e.g 0x0000000000000000 <- 0x0000006f6c6c6548
// 0x0000000000000008 <- 0x0000646c726f5720
// from address 0x8 we take 0x6f5720 and use that to fill 
// the 0x000000 in address 0x0
// e.g producing 0x0000000000000000 <- 0x6f57206f6c6c6548
// 0x0000000000000008 <- 0x0000646c00646c72
// notice for 0x8 we shifted the bits to the right 
// we do this because we want to move the word since we
//added new stuff
// note: the space inbetween e.g "00"
//  between 0x646c and 0x64672c is the space we find
// in " World" 


STACK: EQU 0x100000 ;stack
lui sp, STACK>>12
addi a2, x0, str1+5 ;chaddr
addi a3, x0, str2 ;chaddr
jal x1, insch
addi x6, x0, str1 ;output
ecall x0, x6, 4
ebreak x0, x0, 0 ;finish 

appch: lb x5, 0(a2)
sb a3, 0(a2)
addi a3, x5, 0
addi a2, a2, 1
bne a3, x0, appch
sb a3, 0(a2)
jalr x0, 0(x1)

insch: sd x1, 0(sp) ;push
sd s0, -8(sp) ;push 
sd s1, -16(sp) ;push
addi sp, sp, -24 ;push
addi s0, a2, 0
addi s1, a3, 0

loop3: lb a3, 0(s1)
beq a3, x0, end3
jal x1, appch
addi s0, s0, 1
addi a2, s0, 0
addi s1, s1, 1
beq x0, x0, loop3

end3: addi sp, sp, 24 ;pop
ld x1, 0(sp) ;pop
ld s0, -8(sp) ;pop
ld s1, -16(sp) ;pop
jalr x0, 0(x1) ;return 
a2:DD 0xAAAABBBBCCCCDDDD
b2:DD 0x4444333322221111

DM 8

ld x4,a2(x0)
ld x5,b2(x0)

add x6,x4,x5
sub x7,x4,x5
sub x12,x5,x4
and x8,x4,x5
or x9,x4,x5
xor x10,x4,x5
xori x2,x4,-1
xori x3,x5,-1

sd x6,16(x0)
sd x7,24(x0)
sd x12,32(x0)
sd x8,40(x0)
sd x9,48(x0)
sd x10,56(x0)
sd x2,64(x0)
sd x3,72(x0)
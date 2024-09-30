a: DD 0x400
b: DD 0x800
c: DD 0x1000
d: DD 0x2000 
e: DD 0x0

ld x4,a(x0)
ld x5,b(x0)
ld x6,c(x0)
ld x7,d(x0)

or x8,x5,x4
or x9,x6,x7
or x3,x8,x9

srai x2,x3,2
sd x2,e(x0)




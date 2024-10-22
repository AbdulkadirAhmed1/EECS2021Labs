d: DF 2.0
fld f0, d(x0)
fmv.x.d x30, f0
addi x31, x0, -1
fmv.d.x f1, x31 

// read it backwards to remember 
// x.d (d to x)
// d.x (x to d)
// x is int reg
// d is flp reg
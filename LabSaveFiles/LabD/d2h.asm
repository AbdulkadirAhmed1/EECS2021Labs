fc1: DF -2.0
fc2: DF 3.0
fld f1, fc1(x0)
fld f2, fc2(x0)
fsgnj.d f3, f1, f2 
fsgnjn.d f4, f1, f2 
fsgnjx.d f5, f1, f2 

//fsgnj.d fd,fs1,fs2
//sets fd sign to fs1 and magnitude to fs2

//fsgnjn.d fd,fs1,fs2
//sets fd sign opposite to fs1 and magnitude to fs2

//fsgnjx.d fd,fs1,fs2
//sets sign to xor fs1 and fs2 and magnitude to fs2

// e.g in our case -2 and 3 
// sign bit is 1 and 0 
// 1 XOR 0 = 1 (negative) > likeiswe for 0 XOR 1
// 1 XOR 1 = 0 (postive)
// 0 XOR 0 = 0 (postive)
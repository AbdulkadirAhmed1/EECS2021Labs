cv1: DF 1.21, 5.85, -7.3, 23.1, -5.55, 0
cv2: DF 3.14, -2.1, 44.2, 11.0, -7.77, 0
result: DD 0

//Setup
//f1 to contain first nth element (vector a)
//f2 to constain second nth element (vector b)
//multiply f1 and f2 and store result in f3
//increment f4 each time by adding f3 to it
// f4 will be the final result

addi tp,tp,0 ;counter

loop:
fld f1,cv1(tp)
fld f2,cv2(tp)

fmul.d f3,f1,f2
fadd.d f4,f4,f3

addi tp,tp,8

ld x1,0(tp)

bne x1,x0,loop

fsd f4,result(x0)



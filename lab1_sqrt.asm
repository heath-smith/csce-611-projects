.data 
Pointone: .word 1368
Ten: .word 10
Mask: .word 0x3FFF

Li  a7,5
Ecall

Lw t0,pointone
Mul t0,t0,a0
Lw t1,mask
Andi t0,t0,t1

Lw t1,ten

Mul t0,t0,t1
Andi t1,t0,1
Stli t0,t0,14
Add t0,t0,t1

Li a7,1
Mv a0,t0

ecall

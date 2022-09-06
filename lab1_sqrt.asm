
li a7,5
ecall  # place input value into register a0

li t0,256  # initial guess in t0
li t1,128  # initial step size in t1

loop:	mul t2,t0,t0  # square initial guess
	mulhu t3,t0,t0
	srli  t2,t2,14  # shift hi/low 14 bits to right
	slli t3,t3,18
	beq t2,t0,exit
	blt t2,a0,addStep
	bgt t2,a0,subStep
	
loop2:	srli t1,t1,1
	bne t1,zero,loop
	b exit
	
addStep:add t0,t0,t1
	b loop2
	
subStep:sub t0,t0,t1
	b loop2
	
exit:

#.data 
#Pointone: .word 1368
#Ten: .word 10
#Mask: .word 0x3FFF

#Li  a7,5
#Ecall

#Lw t0,pointone
#Mul t0,t0,a0
#Lw t1,mask
#Andi t0,t0,t1

#Lw t1,ten

#Mul t0,t0,t1
#Andi t1,t0,1
#Stli t0,t0,14
#Add t0,t0,t1

#Li a7,1
#Mv a0,t0

#ecall

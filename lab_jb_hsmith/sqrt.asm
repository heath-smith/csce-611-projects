# Heath Smith
# Lab 4 -- CSCE 611
# Square Root Binary Search

	.text
	#li	a7,5		# load sys call 5
	#ecall			# execute sys call 5
	#mv	t6,a0
	
	#li t0,61440		# test value, already scaled by 2^14
	#li t0,17		# load test value 17 into t0
	#slli t0,t0,14		# shift left 214 bits

	csrrw   t0, 0xf00, zero
	slli	t0,t0,14

	addi	t1,zero,0	# load initial guess into t1
	slli	t1,t1,14	# shift left 14 bits
	
	addi	t2,zero,256	# load step into t2
	slli	t2,t2,14	# shift step left by 14 bits
	
loop:	mul	t3,t1,t1	# square initial guess (low bits)
	mulhu	t4,t1,t1	# square initial guess (high bits)
	
	srli	t3,t3,14	# shift low bits right 14 bits
	slli	t4,t4,18	# shift high 18 bits to left
	or	t5,t3,t4	# shifts (high, low) 14 bits to right
	
	beq	t0,t5,exit	# exit if input == guess^2
	blt	t0,t5,else	# branch if t0 < t5
	add	t1,t1,t2	# add step if t0 > t5
	jal 	half		# jump to half

else:	sub	t1,t1,t2	# jump here if a0 < t5
	jal 	half
	
half:	srli	t2,t2,1		# shift step right by 1 bit

	beq	t2,zero,exit	# stop if step == 0
	
	jal 	loop
	
	jal 	exit

exit:	#li 	a7,1		# load sys call 1
	#mv	a0,t1		# display raw result from t1
	#ecall
	
	# multiply by 100000
	li 	t2,100000	# load 100,000 --> t2
	mulhu 	t3,t1,t2	# upper bits t1 * t2 --> t3
	mul 	t4,t1,t2	# lower bits t1 * t2 --> t4 18
	slli	t3,t3,18	# shift upper bits left by 18
	srli	t4,t4,14	# shift low bits right by 14
	or	s0,t3,t4	# OR t3 with t4
	
	# simple rounding
	li	t5,1		# load 1 in t5
	srli	t4,t4,12	# shift low bits right 17 to get precision bit
	and	t4,t4,t5

	#li 	a7,1
	#mv	a0,t4
	#ecall
	
	blt	t4,t5,jump	# branch if decimal bits <1

	
	add	s0,s0,t5	# add 1 to s0

	# print value #
	#li 	a7,1
	#mv	a0,s0
	#ecall
	################

	#srli s0,t3,14		# shift 14 bits to the right into s0
	
	# print value #
	#li 	a7,1
	#mv	a0,t3
	#ecall
	################		

	# load constant 0.1 into s1
jump:	li	s1,429496730
	addi	s2,zero,10

	# set output register to zero
	add 	t0,zero,zero

	# 1
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,s0,s1	# fractional bits (lower bits)
	mulh	t1,s0,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10

	or 	t0,t0,t2	# or with register t0 --> t0		

	# print value #
	#li 	a7,1
	#mv	a0,t0
	#ecall
	################	

	# 2
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10

	or 	t0,t0,t2	# or with register t0 --> t0
	
	# print value #
	#li 	a7,1
	#mv	a0,t2
	#ecall
	################
	
	# 3
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	#li 	a7,1
	#mv	a0,t0
	#ecall
	################
	
	# 4
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10

	or 	t0,t0,t2	# or with register t0 --> t0			

	# print value #
	#li 	a7,1
	#mv	a0,t0
	#ecall
	################				
	
		
	# 5
	slli	t0,t0,4		# shift left 4-bits
	
	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	#li 	a7,1
	#mv	a0,t0
	#ecall
	################

	# 6
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	#li 	a7,1
	#mv	a0,t0
	#ecall
	################

	# 7
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	#li 	a7,1
	#mv	a0,t2
	#ecall
	################

	# 8
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0
	
	# print value
	#li	a7,1
	#mv	a0,t0
	#ecall
	################
		
	# write destination register to switches
	csrrw zero, 0xf02, t0

	
	


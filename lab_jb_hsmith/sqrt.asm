# Heath Smith
# Lab 4 -- CSCE 611
# Square Root Binary Search

	.text
	#li	a7,5		# load sys call 5
	#ecall			# execute sys call 5
	#mv	t6,a0
	
	li a0,  17
	#addi a0, a0, 0
	#csrrw   a0, 0xf00, t6

	addi	t1, zero, 256	# load initial guess into t1
	slli	t1,t1,14	# shift left 14 bits
	
	addi	t2, zero, 128		# load step into t2
	slli	t2,t2,14	# shift step left by 14 bits
	
loop:	mul	t3,t1,t1	# square initial guess (low bits)
	mulhu	t4,t1,t1	# square initial guess (high bits)
	
	srli	t3,t3,14	# shift right 14 bits
	slli	t4,t4,18	# shift 18 bits to left
	or	t5,t3,t4	# shifts (high, low) 14 bits to right
	
	beq	a0,t5,exit	# exit if input == guess^2
	blt	a0,t5,else	# branch if a0 < t5
	add	t1,t1,t2	# add step if a0 > t5
	jal 	half		# jump to half

else:	sub	t1,t1,t2	# jump here if a0 < t5
	jal 	half
	
half:	srli	t2,t2,1		# shift step right by 1 bit

	beq	t2,zero,exit	# stop if step == 0
	
	jal 	loop
	
	jal 	exit

exit:	li 	a7,1		# load sys call 1
	mv	a0,t1		# display raw result
	ecall		
	
	# shift 14 bits to the right
	srli t1,t1,14
	
	li t2,100000
	
	mul t3,t1,t2
	mulhu t4,t1,t2
	
	# value for testing
	#addi	s0,zero,234
	
	# load constant 0.1 into s1
	li	s1,429496730
	addi	s2,zero, 10
	
	add 	t0,t0,zero	# set output register to zero
	
	# 1
	slli	t0,t0,4		# shift left 4-bits
	
	mul	t2,t4,s1	# fractional bits (lower bits)
	mulh	t1,t4,s1	# whole number (upper bits) / 10
	
	mulhu	t2,t2,s2	# multiply fractional bits by 10

	or 	t0,t0,t2	# or with register t0 --> t0
	
	# 2
	slli	t0,t0,4		# shift left 4-bits
	
	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0


	# 3
	slli	t0,t0,4		# shift left 4-bits
	
	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10
	
	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0


	# 4
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

	# 5
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
	
	# 6
	slli	t0,t0,4		# shift left 4-bits
	
	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10
	
	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	#li 	a7,1
	#mv	a0,t2
	##ecall
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

	# print value #
	li 	a7,1
	mv	a0,t0
	ecall
	################	
	
	
	# write destination register to switches
	#csrrw t6, 0xf02, t0

	
	
	#csrrw t6, 0xf02, t1
	
	#li 	a7,1		# load sys call 1
	#mv	a0,t2		# display raw result
	#ecall			# execute sys call (result should equal previous ecall)
	


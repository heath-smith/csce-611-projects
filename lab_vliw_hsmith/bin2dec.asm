# Heath Smith & John Barnes
# Lab 2 -- CSCE 611
# bin2dec FPGA program

	.text
	# load switches into cpu
	#csrrw   s0, 0xf00, zero

	# value for testing
	addi	s0,zero,234

	# load constant 0.1 into s1
	li	s1,429496730
	addi	s2,zero, 10

	add 	t0,t0,zero	# set output register to zero

	# 1
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,s0,s1	# fractional bits (lower bits)
	mulh	t1,s0,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
	################

	# 2
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
	################

	# 3
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
	################

	# 4
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
	################

	# 5
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
	################

	# 6
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
	################

	# 7
	slli	t0,t0,4		# shift left 4-bits

	mul	t2,t1,s1	# fractional bits (lower bits)
	mulh	t1,t1,s1	# whole number (upper bits) / 10

	mulhu	t2,t2,s2	# multiply fractional bits by 10
	#addi	t2,t2,1

	or 	t0,t0,t2	# or with register t0 --> t0

	# print value #
	li 	a7,1
	mv	a0,t2
	ecall
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

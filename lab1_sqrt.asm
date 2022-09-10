	.data
guess:	.word	256		# initial guess value
step:	.word	128		# initial step value

	.text
	li	a7,5		# load sys call 5
	ecall			# execute sys call 5
	
	#li	a0,61440
	#slli	a0,a0,14	# shift input 14 bits left (32, 14) precision
	
	mv	t6,a0

	lw	t1,guess	# load initial guess into t1
	slli	t1,t1,14	# shift left 14 bits
	
	lw	t2,step		# load step into t2
	slli	t2,t2,14	# shift step left by 14 bits
	
loop:	mul	t3,t1,t1	# square initial guess (low bits)
	mulhu	t4,t1,t1	# square initial guess (high bits)
	
	srli	t3,t3,14	# shift right 14 bits
	slli	t4,t4,18	# shift 18 bits to left
	or	t5,t3,t4	# shifts (high, low) 14 bits to right
	
	beq	a0,t5,exit	# exit if input == guess^2
	blt	a0,t5,else	# branch if a0 < t5
	add	t1,t1,t2	# add step if a0 > t5
	b 	half		# jump to half

else:	sub	t1,t1,t2	# jump here if a0 < t5
	b 	half
	
half:	srli	t2,t2,1		# shift step right by 1 bit

	beq	t2,zero,exit	# stop if step == 0
	
	b 	loop
	
	b 	exit

exit:	li 	a7,1		# load sys call 1
	mv	a0,t1		# display raw result
	ecall			# execute sys call (result should equal previous ecall)

	.data
guess:	.word	256		# initial guess value
step:	.word	128		# initial step value
test0:	.word	65536		# test value for initial guess squared
res:	.word	22		# store expected end result

	.text
	#li	a7,5		# load sys call 5
	#ecall			# execute sys call 5
	li	a0,512
	slli	a0,a0,14	# shift input left 14 bits
	
	slli	t0,a0,14	# shift input 14 bits left (32, 14) precision
	
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

else:	sub	t1,t1,t2	# jump here if a0 < t5

	srli	t2,t2,1		# shift step right by 1 bit
	beq	t2,zero,exit		# stop if step == 0
	
	b loop
	
	##### checkpoint - output expected result of multiplication #####
	# li	a7,1		# load sys call 1 --> print integer
	# lw	a0,test0	# load test value into a0
	# slli	a0,a0,14	# shift left 14 bits
	# ecall			# print value from a0 to console
	# b exit
	
	##### checkpoint to see result of multiplication #####
	# li	a7,1		# load sys call 1 --> print integer
	# mv	a0,t5		# move value from t5 into a0
	# ecall			# print value from a0 to console
	
	
	b exit

exit:	#li 	a7,1		# load sys call 1
	#lw	t6,res
	#slli	t6,t6,14
	#ecall
	
	li 	a7,1		# load sys call 1
	mv	a0,t5		# display raw result
	#srli 	t5,t5,14	# shift t5 right 14 bits (equivalent to integer rounding)
	ecall			# execute sys call (result should equal previous ecall)
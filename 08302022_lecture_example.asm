# Example from Lecture 8/30/2022
	.data
pointone:	.word	1638	# store the value .1
ten:		.word	10	# store value 10
mask:		.word	0x3FFF

	.text
	li	a7,5		# load sys call 5
	ecall			# execute system call
	
	lw	t0,pointone	# load .1
	mul	t0,t0,a0	# multiply input value by .1
	
	lw	t1,mask
	
	and	t0,t0,t1	# mask the fractional bits (0x3FF == 14 1's in hex)
	lw	t1,ten
	mul	t0,t0,t1
	
	srli	t0,t0,13	# shift 13 bits
	andi	t1,t0,1
	srli	t0,t0,1
	add	t0,t0,t1
	
	li	a7,1		# load sys call 1 --> print integer
	mv	a0,t0		# move t0 to a0
	ecall
	
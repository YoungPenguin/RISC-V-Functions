	# This assembly routine myMult takes 2 arguments, a and b in registers a0 and a1 
	# and returne their product in register a0 without using the dedicated RISC-V 
	# multiplication instruction


# The code uses 4 temporary registers t1-4; t1 and t2 are used to make sure the product has the
# correct sign, t2 is used to check if the result has the correct sign, t3 holds the value of LS
# B(a1)
# and t4 holds the product.

# The assembly routine myMult is a leaf procedure

# The procedure myMult will overflow if the product of the two numbers is too large to be 
# represented in a 32 bit signed number


	.data
aa:	.word 2     	# a
bb:	.word 3     	# b

	.text
	.globl main
main:
	lw a0, aa	# a0 = a
	lw a1, bb	# a1 = b
    
	jal myMult	# Multiply a and b
    
	nop
	j end		# Jump to end of program
	nop

myMult:
	li t1,1				# Initialize t1 to 1
	li t2,0				# Initialize t2 to 0 
	li t4,0				# Initialize product to 0
    
	bge a0,zero,a0POS	# Branches if a is positive
    sub a0,zero,a0		# Makes a positive
	addi t2,t2,1		# t2=1    
	a0POS:
    
	bge a1,zero,a1POS	# Branches if b is positive
	sub  a1,zero,a1		# Makes b positive
	addi t2,t2,1		# t2=t2+1  
	a1POS:
    
	beq a0,zero,EXIT		# Branch if a == 0
	FORLOOP:			
	beq a1,zero,LOOPEXIT	# Branch if b == 0
	andi t3,a1,1			# t3 = LSB(b)
	beq t3,zero,EXIT2		# Branch if LSB(b) == 0
	add t4,t4,a0			# Product=Product+a

	EXIT2:
	slli a0,a0,1		# shift left: a
	srli a1,a1,1		# shift right: b
	j FORLOOP			# Jump to FORLOOP

	LOOPEXIT:			
	mv a0,t4			# Copy product into a0
	bne t2,t1,EXIT		# Branch if result has correct sign
	sub a0,zero,a0		# Makes a0 negative

	EXIT:
	jalr x0,0(x1)		# returns

end:
	nop
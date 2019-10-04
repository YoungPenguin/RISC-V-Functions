# The procedure complexMul uses saved registers s2-11:
# Registers s2-5 hold the values originally placed in registers a0-3 (the arguments of the 
# complex numbers), s6-9 hold products of the 4 multiplications needed and s10-11 hold the real 
# and imaginary parts of the result.

# The assembly routine complexMul is a non-leaf procedure

# The procedure complexMul will overflow, if the product of any two is too large to be represented
in 32-bits


	.data
aa:	.word 2     	# Re(z)
bb:	.word 3     	# Im(z)
cc: .word -4		# Re(w)
dd: .word -1		# Im(w)

	.text
	.globl main
main:
	lw a0, aa	# a0 = Re(z)
	lw a1, bb	# a1 = Im(z)
	lw a2, cc	# a2 = Re(w)
	lw a3, dd	# a3 = Im(w)	
    
	jal complexMul	# Multiply z and w
	nop
	j end			# Jump to end of program
	nop

complexMul:
	addi sp,sp,-4	# Ajust stack for 1 item
	sw x1,0(sp)		# save the return adress
	mv s2,a0		# Copies Re(z) into s2
	mv s3,a1		# Copies Im(z) into s3
	mv s4,a2		# Copies Re(w) into s4
	mv s5,a3		# Copies Im(w) into s5
	
	mv a1,s4		# Copies Re(w) into a1
	jal ra,myMult	# Jumps to myMylt
	mv s6,a0		# Copies Re(z)*Re(w) into s6
	
	mv a0,s3		# Copies Im(z) into a0
	mv a1,s5		# Copies Im(w) into a1
	jal ra,myMult	# Jumps to myMylt
	mv s7,a0		# Copies Im(z)*Im(w) into s7
	
	sub s10,s6,s7	# s10 = Re(z)*Re(w)-Im(z)*Im(w)
	
	mv a0,s2		# Copies Re(z) into a0
	mv a1,s5		# Copies Im(w) into a1
	jal ra,myMult	# Jumps to myMylt
	mv s8,a0		# Copies Re(z)*Im(w) into s8
	
	mv a0,s3		# Copies Im(z) into a0
	mv a1,s4		# Copies Re(w) into a1
	jal ra,myMult	# Jumps to myMylt
	mv s9,a0		# Copies Im(z)*Im(w) into s9
	
	add s11,s8,s9	# s11 = Re(z)*Im(w)+Im(z)*Im(w)
	
	mv a0,s10		# Copies Re(z)*Re(w)-Im(z)*Im(w) into a0
	mv a1,s11		# Copies Re(z)*Re(w)-Im(z)*Im(w) into a1

	lw x1,0(sp)		# Loads return adress from stack
	addi,sp,sp,4	# Clears stack
	jalr x0,0(x1)	# Returns	
	
	
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

.include "./cs47_proj_macro.asm"
.text
#-----------------------------------------------
# C style signature 'printf(<format string>,<arg1>,
#			 <arg2>, ... , <argn>)'
#
# This routine supports %s and %d only
#
# Argument: $a0, address to the format string
#	    All other addresses / values goes into stack
#-----------------------------------------------
printf:
	#store RTE - 5 *4 = 20 bytes
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$s0, 12($sp)
	sw	$s1,  8($sp)
	addi	$fp, $sp, 24
	# body
	move 	$s0, $a0 #save the argument
	add     $s1, $zero, $zero # store argument index
printf_loop:
	lbu	$a0, 0($s0)
	beqz	$a0, printf_ret
	beq     $a0, '%', printf_format
	# print the character
	li	$v0, 11
	syscall
	j 	printf_last
printf_format:
	addi	$s1, $s1, 1 # increase argument index
	mul	$t0, $s1, 4
	add	$t0, $t0, $fp # all print type assumes 
			      # the latest argument pointer at $t0
	addi	$s0, $s0, 1
	lbu	$a0, 0($s0)
	beq 	$a0, 'd', printf_int
	beq	$a0, 's', printf_str
	beq	$a0, 'c', printf_char
printf_int: 
	lw	$a0, 0($t0) # printf_int
	li	$v0, 1
	syscall
	j 	printf_last
printf_str:
	lw	$a0, 0($t0) # printf_str
	li	$v0, 4
	syscall
	j 	printf_last
printf_char:
	lbu	$a0, 0($t0)
	li	$v0, 11
	syscall
	j 	printf_last
printf_last:
	addi	$s0, $s0, 1 # move to next character
	j	printf_loop
printf_ret:
	#restore RTE
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$s0, 12($sp)
	lw	$s1,  8($sp)
	addi	$sp, $sp, 24
	jr $ra

# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
	addi	$sp, $sp, -52
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	sw	$fp, 16($sp)
	sw	$s0, 20($sp)	# Store result
	sw	$s1, 24($sp)	# Carry values
	sw	$ra, 28($sp)
	sw	$s2, 32($sp)
	sw	$s3, 36($sp)
	sw	$s4, 40($sp)
	sw	$s5, 44($sp)
	addi	$fp, $sp, 52
	li	$t0, 0		# Loop counter
	li	$s0, 0
	li	$v0, 0		# Initilaize result to 0
	li	$v1, 0		# Initialize result to 0
	beq 	$a2, 0x2D, sub_logical 		# 2D = -
	beq	$a2, 0x2B, add_logical		# 2B = +
	beq	$a2, 0x2A, mult_logical		# 2A = *
	beq	$a2, 0x2F, div_logical
	j	restore_return_logical
sub_logical:
	nor	$a1, $a1, $zero
	li	$s1, 1
	j	add_logical_loop
add_logical:
	li	$s1, 0
	j	add_logical_loop
add_logical_loop:
	slti	$t4, $t0, 32
	beqz	$t4, end_logical_loop
	get_bit($a0, $t1, $t0)	# t1 = A
	get_bit($a1, $t2, $t0)	# t2 = B
				# s1 = C
	xor	$t3, $t1, $t2	# t6 = middle of 1
	and	$t6, $t3, $s1
	xor	$t3, $s1, $t3	# t7 = second middle
	and	$t7, $t1, $t2
	or	$s1, $t6, $t7
	sllv	$t3, $t3, $t0
	or	$s0, $t3, $s0
	addi	$t0, $t0, 1
	j	add_logical_loop
	
end_logical_loop:
	or	$v0, $s0, $zero
	j	restore_return_logical
	
mult_logical:
	li	$s4, 0
	li	$s1, 0
	li	$s5, 0
	
	li	$t1, 31
	get_bit($a0, $t0, $t1)
	or	$s2, $zero, $a0
	beqz	$t0, dont_invert_a0
	jal	invert_number
	or	$s2, $zero, $v0
	
dont_invert_a0:	
	li	$t1, 31
	get_bit($a1, $t0, $t1)
	or	$s3, $a1, $zero
	beqz	$t0, dont_invert_a1
	move	$a0, $a1
	jal	invert_number
	or	$s3, $v0, $zero
	
dont_invert_a1:
	j	mult_logical_loop
	
mult_logical_loop:
	beqz	$s3, mult_logical_end
	slti	$t0, $s4, 16
	beqz	$t0, mult_logical_hi
	get_bit($s3, $t0, $zero)	# $s0 is product lo
	beqz	$t0, mult_is_not_1	# $s1 carry over if necessary					
mult_is_1:				# $s2 multiplier
	or	$a0, $s2, $zero		# $s3 multiplicand the right -> shifter
	or	$a1, $s0, $zero	
	ori	$a2, $zero, 0x2B 
	jal	au_logical
	or 	$s0, $v0, $zero		
					
mult_is_not_1:
	sll	$s2, $s2, 1
	srl	$s3, $s3, 1
	addi	$s4, $s4, 1
	j	mult_logical_loop
	
mult_logical_hi:
	li	$s4, 0
	
mult_logical_loop_hi:
	beqz	$s3,multiplier_zero
	get_bit($s3, $t0, $zero)	# $s5 is product hi
	beqz	$t0, mult_is_not_1_hi	# $s1 carry over if necessary					
mult_is_1_hi:				# $s2 multiplier
	or	$a0, $s2, $zero		# $s3 multiplicand the right -> shifter
	or	$a1, $s5, $zero	
	ori	$a2, $zero, 0x2B 
	jal	au_logical
	or 	$s5, $v0, $zero	
						
mult_is_not_1_hi:
	sll	$s2, $s2, 1
	srl	$s3, $s3, 1
	j	mult_logical_loop_hi
	
mult_logical_end:
	or	$v0, $s0, $zero
	or	$v1, $s5, $zero
	j	restore_return_logical
	
div_logical:
	li	$s0, 0	# Quotient
	li	$s1, 0 	# Remainder but probably not
	
	li	$t1, 31
	get_bit($a0, $t0, $t1)
	or	$s2, $zero, $a0
	beqz	$t0, dont_invert_a0_div
	jal	invert_number
	or	$s2, $zero, $v0
	
dont_invert_a0_div:	
	li	$t1, 31
	get_bit($a1, $t0, $t1)
	or	$s3, $a1, $zero
	beqz	$t0, dont_invert_a1_div
	move	$a0, $a1
	jal	invert_number
	or	$s3, $v0, $zero
dont_invert_a1_div:
	move	$a1, $s3
	li	$a2, 0x2D
	li	$s4, 0 	# Counter
	
div_logical_loop:			# Check both arguments are positive upon entering the loop - DEBUG
	slti	$t0, $s4, 31 
	beqz	$t0, end_division_logical
	slt	$t0, $s2, $s3		# Change to s3?
	bnez	$t0, end_division_logical
	move	$a0, $s2
	jal	au_logical
	move	$s2, $v0
	addi	$s4, $s4, 1
	j	div_logical_loop
	
end_division_logical:
	move	$v1, $s2	#Remainder
	li	$v0, 0
	
restore_return_logical:
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	lw	$fp, 16($sp)
	lw	$s0, 20($sp)
	lw	$s1, 24($sp)
	lw	$ra, 28($sp)
	lw	$s2, 32($sp)
	lw	$s3, 36($sp)
	lw	$s4, 40($sp)
	lw	$s5, 44($sp)
	addi	$sp, $sp, 52
	jr 	$ra

multiplier_zero:
	li	$t0, 31
	get_bit($a0, $t1, $t0)
	get_bit($a1, $t2, $t0)
	xor	$t3, $t2, $t1
	beqz	$t3, mult_logical_end
	nor	$s5, $zero, $zero
	j	mult_logical_end

# Inverts a0 and stores it into v0
invert_number:
	addi	$sp, $sp, -24
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$fp, 12($sp)
	sw	$ra, 16($sp)
	addi	$fp, $sp, 24
	li	$a1, 1
	nor	$a0, $zero, $a0
	li	$a2, 0x2B
	jal	au_logical
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	jr	$ra
	

#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
# TBD: Complete it
	beq 	$a2, 0x2D, sub_normal 		# 2D = -
	beq	$a2, 0x2B, add_normal 		# 2B = +
	beq	$a2, 0x2F, div_normal 		# 2F = /
	beq	$a2, 0x2A, mult_normal  	# 2A = *
mult_normal:
	mult	$a0, $a1
	mfhi	$v1
	mflo	$v0
	j	return_normal
add_normal:
	add	$v0, $a0, $a1
	j	return_normal
sub_normal:
	sub	$v0, $a0, $a1
	j	return_normal
div_normal:
	div	$a0, $a1
	mflo	$v0
	mfhi	$v1
	j	return_normal
return_normal:
	jr	$ra

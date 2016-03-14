.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
# Write body of the iterative
FACTORIAL:				#Takes factorial of $a0
	slti	$t0, $a0, 2		# If $a0 is less than 2, set $t0 to 0 - else to 1
	bne	$t0, $zero, RETURN
	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	addi	$a0, $a0, -1
	jal	FACTORIAL
	lw	$v0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 8
<<<<<<< HEAD
RETURN: add	$v0, $a0, $v0		#Adjust so it is multiplying its current value, use $v0 to store the value lower stack value
	mfhi	$t2
	mtlo	$t3
	or	$t1, $t3, $t2
	add	$s0, $t1, $s0
	jr	$ra			# Return to previous program
=======
	mult	$v0, $s0
	mfhi	$t1
	mflo	$t2
	or	$t1, $t1, $t2
	move	$s0, $t1
RETURN: jr	$ra			# Return to previous program
>>>>>>> b9084eef4fc6b22bfebd3e02c0b7df2a1780c4eb
# factorial program here
# Store the factorial result into 
# register $s0
main:	print_str(msg1)
	read_int($t0)
	move	$a0, $t0
	addi	$s0, $s0, 1
	jal	FACTORIAL
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
	

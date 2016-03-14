.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

# Breaks when the least common multiple is one of the arguments

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:	# Contains the 1 time test that triggers if any of the arguments is 2x therefore the LCM
	sll	$t1, $a2, 1
	move	$v0, $a3
	beq	$t1, $a3, lcm_is_argument
	sll	$t1, $a3, 1
	move	$v0, $a2
	beq	$t1, $a2, lcm_is_argument
lcm_main:
	# Store frame
	beq	$a2, $a3, return	#If numbers are equal return
	addi	$sp, $sp, -40
	
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$ra, 12($sp)
	
	addi	$fp, $sp, 40
	 
	# Body
	sgt	$t0, $a2, $a3	# if lcm_m is greater than lcm_n $t0 is 1 add lcm_n + n
	beqz	$t0, add_lcmm_m
add_lcmn_n:
	add	$a3, $a3, $a1
	j	skip_addition
add_lcmm_m:
	add	$a2, $a2, $a0
skip_addition:	
	jal	lcm_main
	
	# Restore frame
	addi	$sp, $sp, 40	# Setting stack pointer to earlier point
	addi	$fp, $sp, 40	# Setting frame pointer to 40 bytes above the stack pointer
	lw	$ra, 12($sp)	
	

return:	move	$v0, $a2
	jr 	$ra
	
lcm_is_argument:
	jr	$ra
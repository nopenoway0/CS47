.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------
insertion_sort:
	# Caller RTE store (TBD)
	addi	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	sw	$s2, 20($sp)
	addi	$fp, $sp, 24
	# Implement insertion sort (TBD)
	# while $s0, or index is >=0 continue to swap as necessary	
	move	$s2, $a1
insertion_loop:
	add	$t5, $zero, $zero
	sll	$t0, $s2, 2
	add	$t1, $a0, $t0 
	lw	$s0, 0($t1)	# Grabbed the value at the according index
insertion_loop_element:
	slt 	$t0, $t5, $s2
	beqz	$t0, is_over
	sll	$t0, $t5, 2
	add	$t1, $t0, $a0
	lw	$s1, 0($t1)
	slt	$t2, $s0, $s1
	addi	$t5, $t5, 1
	beqz	$t2, insertion_loop_element
	# swap $s1 and $s0
	sw	$s1, 0($t1)
	j insertion_loop_element
	
is_over:
	addi	$s2, $s2, -1
	bnez	$s2, insertion_loop
	
	
insertion_sort_end:
	# Caller RTE restore (TBD)
	# sll	$t0, $a1, 2
	# add	$t1, $a0, $t0
	sw	$s1, 0($a0)
	lw	$fp, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	addi	$sp, $sp, 24
	# Return to Caller
	jr	$ra

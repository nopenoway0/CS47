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
	li	$s0, 1
		
insertion_loop:
	sll	$t0, $s0, 2	# Turn index into navigatable number within the array
	add	$t1, $t0, $a0
	lw	$t2, -4($t1)	# Grab the previous word
	lw	$t3, 0($t1)	# Grab next element in array
	# Compare the value with the previous element
	slt	$t4, $t2, $t3
	beqz	$t4, swap
	j	insertion_sort_end
swap:
	sw	$t3, -4($t1)
	sw	$t2, 0($t1)
	
	
insertion_sort_end:
	# Caller RTE restore (TBD)
	lw	$fp, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	addi	$sp, $sp, 24
	# Return to Caller
	jr	$ra

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
	addi	$sp, $sp, -20
	sw	$fp, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$s0, 12($sp)
	addi	$fp, $sp, 20
	# Implement insertion sort (TBD)
	
insertion_sort_end:
	# Caller RTE restore (TBD)
	lw	$fp, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$s0, 12($sp)
	addi	$sp, $sp, 20
	# Return to Caller
	jr	$ra

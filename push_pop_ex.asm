addi	$s0, $s0, 2
addi	$s1, $s1, 3
addi	$s2, $s2, 4

# Push and pop example
sw	$s0, 0($sp)
addi	$sp, $sp, -4
sw	$s1, 0($sp)
addi	$sp, $sp, -4
sw 	$s2, 0($sp)
addi	$sp, $sp, -4

# To store from this specific model - because the more space is created on the stack, even though nothing is being place,
# just to make sure sw can be used without another push; pop must increment the $sp first

addi	$sp, $sp, 4
lw	$t0, 0($sp)
addi	$sp, $sp, 4
lw	$t1, 0($sp)
addi	$sp, $sp, 4
lw	$t2, 0($sp)
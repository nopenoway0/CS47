#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : read_int
	# Usage: read_int(<stdio input>)
	.macro read_int($reg)
	li	$v0, 5	# System call code for reading integer
	syscall
	add	$reg, $v0, $zero # Using add zero to move the int from v0 to the argument register
	.end_macro
	
	# Macro : print_reg_int
	# Usage: print_reg_int(<register containing int>)
	.macro print_reg_int($reg)
	li	$v0, 1	# System call code for print integer, in $a0
	add	$a0, $reg, $zero # Moving the int in the $reg to $a0 becauset that's the register used for printing
	syscall
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
	# Macro : push($reg)
	# Usage: push(<register pushed to stack>)
	.macro push($reg)
	addi	$sp, $sp, -4	# Moves stack pointer so it can store 4 bytes
	sw	$reg, 0($sp)	# Stores register
	.end_macro
	
	# Macro : pop($reg)
	# Usage: pop(<register to hold popped data>)
	.macro pop($reg)
	lw	$reg, 0($sp) 	# Loads 4 bytes, or a word, from stack
	addi	$sp, $sp, 4	# Shifts stack pointer 4 bytes to erase loaded word from stack
	.end_macro

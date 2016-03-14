#<------------------------FIRST MACRO--------------------------->#
# Macro : print_str
# Usage: print_str(<address of the string>)
.macro print_str($arg)
	li $v0, 4 #System call code for print_str
	la $a0, $arg
	syscall
	.end_macro
	
# Macro : print_int
# Usage: print_int(<val>)
.macro print_int($arg)
	li $v0, 1
	la $a0, $arg
	syscall
	.end_macro

# Macro : exit
# Usage: exit
.macro exit
	li $v0, 10
	syscall
	.end_macro
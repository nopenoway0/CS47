.include "./cs47_first_macro.asm" #Including a macro defined in cs47_first_macro.asm

#<---------------------ACTUAL APPLICATION BEGINS HERE--------------->#
#<--------------------------CREATION OF DATA------------------------>#
.data
str: .asciiz "the answer is ="
#<-------------------------------CODE------------------------------->#
.text
.globl main
	add $t0, $zero, $zero
	sub $t1, $zero, $zero
main: 	print_str(str) 	# Call to print str from the macro
	print_int(5) 	# Call to print in from the macro
	exit		# Call to the exit macro
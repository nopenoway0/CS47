# Program exp11.asm
.include "./assignments/cs47_macro.asm"

.data
.align 0
var_b:	.half	0x3210
var_a:	.byte	0x10
var_c:	.byte	0x20
var_d:	.word	0x76543210

.text
.globl main
main:
	lb	$s0, var_a
	lh	$s1, var_b
	lb	$s2, var_c
	lw	$s3, var_d
	
	exit

.macro read_str
	li a1, 256
	li a7, 8
	ecall
.end_macro

.macro print_str (%string)
	.data
entrada: .asciz %string
	.text
	li a7, 4
	la a0, entrada
	ecall
.end_macro	

.macro print_char (%reg)
	li a7, 11
    mv a0, %reg
	ecall
.end_macro	

.macro exit
	li a7, 10
	ecall
.end_macro

# llamada generica
.macro llamada(%valor)
    li a7, %valor
    ecall
.end_macro 

# programa_final.asm – Manejo de múltiples excepciones simulando modo vectorizado


.eqv DISPLAY 0xFFFF0
.eqv I 0x011
.eqv D 0x010
.eqv PUNTO 0x080
.eqv CERO 0x03F
.eqv UNO 0x006
.eqv DOS 0x05B
.eqv CUATRO 0x066
.eqv CINCO 0x06D
.eqv SEIS 0x07D
.eqv SIETE 0x007
.eqv OCHO 0x07F

.macro display
	li t0, PUNTO
	lui t1, DISPLAY
	ori t1, t1, I
	sb t0, 0(t1)
	mv t0, s0
	lui t2, DISPLAY
	ori t2, t2, D
	sb t0, 0(t2)
.end_macro

.data
  .space 2
  .align 0
data6:
  .word 0

.text
setup:
	la t0, manejador
    csrrw zero, utvec, t0         # utvec = manejador
    csrrsi zero, ustatus, 1       # habilitar interrupciones

loop:
    li s0, 8 # ucause 2
    csrrs zero, cycle, s0
    
    li s0, 0xDEADBEEF # ucause 4
    addi s0, s0, 2
    lw t1, 0(s0)
    
    la s0, loop # ucause 5
    lw t1, 0(s0)
    
	la s0, data6 # ucause 6
	li t1, 0xDEADBEEF
	sw t1, 0(s0)
  
	la s0, loop # ucause 7
	li t1, 0xDEADBEEF
	sw t1, 0(s0)
    
    li a7, 100 # ucause 8
    ecall
    j loop

fin:
    nop

# Manejador de excepciones con tabla de saltos (simula utvec en modo vectorizado)
# rars no funciona el modo vectorizado
manejador:
    csrr t1, ucause	# causa
    li t2, 4
    mul t1, t1, t2 # ucause * 4
    la t0, tabla # tabla supone ser la base
    add t1, t0, t1 # base + cause*4
    jr t1

tabla:
    j ucause_0
    j ucause_1
    j ucause_2
    j ret_from_exception
    j ucause_4
    j ucause_5
    j ucause_6
    j ucause_7
    j ucause_8

ucause_0:
    li s0, CERO
    display
    la s0, end0
    j ret_from_exception

ucause_1:
    li s0, UNO
    display
    j ret_from_exception
    
ucause_2:
    li s0, DOS
    display
    j ret_from_exception

ucause_4:
    li s0, CUATRO
    display
    j ret_from_exception

ucause_5:
    li s0, CINCO
    display
    j ret_from_exception

ucause_6:
    li s0, SEIS
    display
    j ret_from_exception

ucause_7:
    li s0, SIETE
    display
    j ret_from_exception

ucause_8:
    li s0, OCHO
    display
    j ret_from_exception

ret_from_exception:
    csrrw t0, uepc, zero
    addi t0, t0, 4
    csrrw zero, uepc, t0
    uret

end0:
    li a7, 10
    ecall
# modificar valor de semilla si quiere otra adivinanza

.include "syscalls.asm"
.include "display7s.asm"
.include "mmio.asm"
.include "handler.asm"
.include "datos.asm"
    
.text
.globl main

main:
	configurar_interrupciones manejador

	seed 1000	# Semilla
    rand_int	# Obtener número aleatorio entre 0 y 2
	li t1, 3
	remu t0, a0, t1	# t0 = a0 % 3

    # Cargar puntero a contraseña seleccionada
    la t1, claves
    slli t0, t0, 2	# offset para contraseña
    add t1, t1, t0
    lw t5, 0(t1)	# t5 = puntero a la contraseña

    la t1, pistas
    slli t0, t0, 2        # offset para pista
    add t1, t1, t0
    lw s7, 0(t1)          # t7 = puntero a la pista

    # Mostrar la pista
    print_mmio s7
    li t6, LEN_CLAVE      # t6 = longitud de la contraseña

jugar:
    leer_y_comparar(t5, fallo)

    displayDer D_k
    displayIzq D_O

    addi t5, t5, 1
    addi t6, t6, -1
    beqz t6, ganaste
    j jugar

fallo:
    llamada NO_ACIERTO
    j fin

ganaste:
    displayIzq D_w
    displayDer D_n
    j fin

manejador:
    displayDer D_r
    displayIzq D_E
    retorno

fin:
    print_str "\nFin del juego\n"
    exit

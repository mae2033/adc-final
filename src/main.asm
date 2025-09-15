	.include "display7s.asm" # incluye "funciones" para display de 7 segmentos
	.include "mmio.asm" # incluye "funciones" de lectura y display mmio
	.include "datos.asm" # incluye las claves y pistas
	.include "syscalls.asm"

	.eqv INICIO 0 # valores posibles para probar del 0(a) al 25(z)
	.eqv INTENTOS 5 # intentos por palabra, cant.errores aceptados de 0 a 9

	.text
.globl main



main: 
    # paso la rutina a la configuracion
    configurar_interrupt_teclado isr_teclado

    li s0, INICIO # arranca desde 0 | a

siguiente_letra:
    li s1, long_juego  
    beq s0, s1, fin   # si s0==26 terminar juego

    # Cargar puntero a la pista y clave
    la t2, pistas
    slli s3, s0, 2
    add t2, t2, s3
    lw s7, 0(t2)       # s7 = puntero a pista

    la t2, claves
    add t2, t2, s3
    lw s5, 0(t2)       # s5 = puntero a clave

    # Mostrar letra en D7S
    la s6, letras		# asignar letras
    add s6, s6, s0      # desplazar a la letra actual
    lb s6, 0(s6)		# contenido (letra) en la direccion simbolica
    displayIzq_reg s6

    # Mostrar pista en MMIO
    print_mmio s7

#    # Leer palabra letra por letra (4 letras)
#    li s6, LEN_CLAVE	# viejo

    # s5 = puntero a la clave
    # Calcular longitud de la clave
	mv t0, s5         # t0 recorre la clave
	li s6, 0          # s6 ser� la longitud
contar_long:
    lb t1, 0(t0)
    beqz t1, fin_contar
    addi s6, s6, 1
    addi t0, t0, 1
    j contar_long
fin_contar:
    li s8, INTENTOS
    mostrar_intentos(s8)     # mostrar intentos iniciales

leer_palabra:
    beqz s6, comprobar          # ya completé la palabra
    leer_tecla_i(s4)             # obtiene -1 si no hay tecla
    li t0, -1
    beq s4, t0, leer_palabra     # si no hay tecla, esperar sin descontar intento

    lb s7, 0(s5)
    bne s4, s7, fallo_letra      # si no coincide -> fallo en letra
    addi s5, s5, 1
    addi s6, s6, -1
    j leer_palabra

# ---
fallo_letra:
    addi s8, s8, -1         # descontar intento
    mostrar_intentos(s8)     # actualizar display derecho
    blez s8, fallo    # si s8 == 0, perdi�
    j leer_palabra          # si todav�a tiene intentos, vuelve a leer
# ---

comprobar:
    addi s0, s0, 1
    j siguiente_letra

fallo:
	la s7 clear_code
	print_mmio s7
	la s7, mensaje_p
    j salir

fin:
	la s7 clear_code
	print_mmio s7
	la s7, mensaje_g
    j salir

#   termina e imprime resultado
salir: print_mmio s7
	print_str "paso algo"
	exit

# 
isr_teclado:
    # Leer el dato del teclado
    li t0, 0xFFFF0004     # KEY_DATA
    lw t1, 0(t0)          # leer ASCII de la tecla

    # Guardar en buffer
    la t2, tecla_actual
    sw t1, 0(t2)

    # Setear flag (tecla lista)
    li t3, 1
    la t2, tecla_lista
    sw t3, 0(t2)

    # Volver de interrupción
    uret


# s0 indice del juego
# s1 limite del juego
# t2 referencia simbolica de clave y pista 
# s3 desplazamiento
# s4 puntero a la respuesta
# s5 puntero a la clave
# s6 letra clave | longitud clave
# s7 puntero a la pista | mensaje G/P
# s8 cantidad de intentos por palabra

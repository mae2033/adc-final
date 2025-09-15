	.include "display7s.asm" # incluye "funciones" para display de 7 segmentos
	.include "mmio.asm" # incluye "funciones" de lectura y display mmio
	.include "syscalls.asm"
	 .include "timer.asm"
	.include "datos.asm" # incluye las claves y pistas

	.eqv INICIO 0 # valores posibles para probar del 0(a) al 25(z)
	.eqv INTENTOS 5 # intentos por palabra, cant.errores aceptados de 0 a 9

	.text
.globl main

main: li s0, INICIO # arranca desde 0 | a

siguiente_letra:
    li s1, long_juego  
    beq s0, s1, fin         # si s0==26 terminar juego

    # Cargar puntero a la pista y clave
    la t2, pistas
    slli s3, s0, 2
    add t2, t2, s3
    lw s7, 0(t2)       

    la t2, claves
    add t2, t2, s3
    lw s5, 0(t2)       

    # Mostrar letra en D7S
    la s6, letras		    # asignar letras
    add s6, s6, s0          # desplazar a la letra actual
    lb s6, 0(s6)		    # contenido (letra) en la direccion simbolica
    displayIzq_reg s6

    # Mostrar pista en MMIO
    print_mmio s7

    # Calcular longitud de la clave
	mv t0, s5         # t0 recorre la clave
	li s6, 0          # s6 sera la longitud
contar_long:
    lb t1, 0(t0)
    beqz t1, fin_contar
    addi s6, s6, 1
    addi t0, t0, 1
    j contar_long
fin_contar:

    li t0, 5                # 5 ticks por palabra
    la t1, contador_tiempo  # <- esta en datos.asm
    sw t0, 0(t1)

    configurar_interrupciones(handler_timer)
    reiniciar_timer(TIMER_INTERVAL)	
    
    li s8, INTENTOS
    mostrar_intentos(s8)    # mostrar intentos iniciales

leer_palabra:
    beqz s6, comprobar      # mientras sea 0 | no se presiona tecla
    leer_tecla(s4)
    lb s7, 0(s5)
    #bne s4, s7, fallo
    bne s4, s7, fallo_letra # si no coincide -> fallo en letra
    addi s5, s5, 1
    addi s6, s6, -1
    j leer_palabra

fallo_letra:
    addi s8, s8, -1         # descontar intento
    mostrar_intentos(s8)    # actualizar display derecho
    blez s8, fallo          # si s8 == 0, perdio
    j leer_palabra          # si todavia tiene intentos, vuelve a leer

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

salir: print_mmio s7        # termina e imprime resultado

# -------------------------------
# Label real que apunta utvec
handler_timer:
    manejador_timer

# s0 indice del juego
# s1 limite del juego
# t2 referencia simbolica de clave y pista 
# s3 desplazamiento
# s4 puntero a la respuesta
# s5 puntero a la clave
# s6 letra clave | longitud clave
# s7 puntero a la pista | mensaje G/P
# s8 cantidad de intentos por palabra

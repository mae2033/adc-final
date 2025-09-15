# Modulo Keyboard and Display MMIO simulator
.eqv KEY_READY  0xFFFF0000
.eqv KEY_DATA   0xFFFF0004
.eqv DISPLAY_READY 0xFFFF0008
.eqv DISPLAY_REG   0xFFFF000C

# imprimir contenido de un registro
.macro print_mmio(%str_ptr)
    mv t0, %str_ptr
print_mmio_loop:
    lb t1, 0(t0)
    beqz t1, print_mmio_done
mmio_wait:
    li t2, DISPLAY_READY
    lw t3, 0(t2)
    beqz t3, mmio_wait
    li t2, DISPLAY_REG
    sw t1, 0(t2)
    addi t0, t0, 1
    j print_mmio_loop
print_mmio_done:
.end_macro

.macro leer_tecla_i(%dest)
    la t0, tecla_lista
    lw t1, 0(t0)
    beqz t1, no_tecla      # si no hay tecla lista, devolver -1

    la t0, tecla_actual
    lw %dest, 0(t0)        # leer tecla
    la t0, tecla_lista
    sw zero, 0(t0)         # limpiar flag
    j fin_lectura

no_tecla:
    li %dest, -1

fin_lectura:
.end_macro




.macro leer_tecla_p(%dest)
leer_tecla_loop:
    li t1, KEY_READY
wait_key:
    lw t2, 0(t1)
    beqz t2, wait_key

    li t1, KEY_DATA
    lw %dest, 0(t1)

    # Filtrar: Enter, Backspace
    li t3, 10         # '\n'
    beq %dest, t3, leer_tecla_loop
    li t3, 13         # '\r'
    beq %dest, t3, leer_tecla_loop
    li t3, 8          # '\b'
    beq %dest, t3, leer_tecla_loop
    # Limitar a solo a letras 'a'..'z'
    li t3, 'a'
    blt %dest, t3, leer_tecla_loop
    li t3, 'z'
    bgt %dest, t3, leer_tecla_loop
.end_macro

.macro leer_y_comparar(%clave_ptr, %error_etiqueta)
    leer_tecla_p(t3)
    lb t4, 0(%clave_ptr)
    bne t3, t4, %error_etiqueta
.end_macro


# ------------------------------------------------------
# Macro: configurar interrupciones del teclado
# Uso: configurar_interrupt_teclado isr_label
# Recibe: etiqueta de la rutina ISR
# Configura: utvec, habilita interrupciones globales y externas
#            habilita interrupciones en teclado (bit 1)
# ------------------------------------------------------
.macro configurar_interrupt_teclado %isr
    # Guardar dirección del handler en utvec
    la t0, %isr
    csrrw zero, utvec, t0       # utvec ← dirección del handler

    # Habilitar interrupciones globales
    csrrsi zero, ustatus, 1

    # Habilitar interrupciones externas en uie
    csrrsi zero, uie, 2

    # Habilitar interrupción en teclado (bit 1 en Receiver Control)
    li t1, KEY_READY
    lw t2, 0(t1)
    ori t2, t2, 0x2             # poner bit 1 = Interrupt Enable
    sw t2, 0(t1)
.end_macro


.macro habilitar_interrupt_teclado
    lui t0, 0xFFFF0
    ori t0, t0, 0x0000   # KEY_READY
    lw t1, 0(t0)
    ori t1, t1, 0x2      # poner bit 1 = Interrupt Enable
    sw t1, 0(t0)
.end_macro

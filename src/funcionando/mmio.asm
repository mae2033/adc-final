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

.macro leer_tecla(%dest)
leer_tecla_loop:
    # Esperar a que haya tecla lista
    li t1, KEY_READY
wait_key:
    lw t2, 0(t1)
    beqz t2, wait_key

    # Leer la tecla
    li t1, KEY_DATA
    lw %dest, 0(t1)

    # Filtrar: Enter (\n=0x0A, \r=0x0D), Backspace (\b=0x08)
    li t3, 10         # '\n'
    beq %dest, t3, leer_tecla_loop
    li t3, 13         # '\r'
    beq %dest, t3, leer_tecla_loop
    li t3, 8          # '\b'
    beq %dest, t3, leer_tecla_loop

    # (opcional) Si querés limitar solo a letras 'a'..'z'
    li t3, 'a'
    blt %dest, t3, leer_tecla_loop
    li t3, 'z'
    bgt %dest, t3, leer_tecla_loop
.end_macro


.macro leer_y_comparar(%clave_ptr, %error_etiqueta)
    leer_tecla(t3)
    lb t4, 0(%clave_ptr)
    bne t3, t4, %error_etiqueta
.end_macro

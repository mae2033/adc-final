# Modulo de macros para manejo de timer e interrupciones

# Direcciones MMIO del Timer en RARS
.eqv TIMER_REG       0xFFFF0020    # Lower 32 bits de timecmp
.eqv TIMER_REG_HI    0xFFFF0024    # Upper 32 bits de timecmp
.eqv TIMER_INTERVAL  2000        # Intervalo de ejemplo en ms

# -------------------------------
# Macro con la logica del handler
.macro manejador_timer
    # Decrementar contador_tiempo
    la t0, contador_tiempo
    lw t1, 0(t0)
    addi t1, t1, -1
    sw t1, 0(t0)
    print_str "tiempo \n\n"
    # Reprogramar timer
    li t2, TIMER_INTERVAL
    li t3, TIMER_REG
    sw t2, 0(t3)

    retorno
.end_macro

# -------------------------------
# Macro para configurar interrupciones
# %handler_label: label del handler real
.macro configurar_interrupciones(%handler_label)
    la t0, %handler_label
    csrrw zero, utvec, t0      # utvec <- dirección del handler
    csrrsi zero, ustatus, 0x1  # habilitar interrupciones globales
    csrrsi zero, uie, 0x10     # habilitar interrupción de timer
.end_macro



# Macro para configurar interrupciones
# %handler: label del manejador de timer definido en handler.asm
.macro configurar_interrupcionesTimer(%handler)
    la t0, %handler           # t0 <- dirección del manejador
    csrrw zero, utvec, t0     # utvec <- t0 | vector de manejadores
    csrrsi zero, ustatus, 0x1 # habilitar interrupciones globales (bit 0)
    csrrsi zero, uie, 0x10    # habilitar interrupción de timer (bit 4)
.end_macro

# Macro para reiniciar timer (timer de una sola vez)
# %interval: valor en milisegundos a partir del tiempo actual
.macro reiniciar_timer(%interval)
    li t0, %interval          # intervalo
    li t1, TIMER_REG          # dirección lower 32 bits
    li t2, TIMER_REG_HI       # dirección upper 32 bits
    sw t0, 0(t1)              # escribir lower 32 bits
    li t3, 0                  # upper = 0 para intervalos pequeños
    sw t3, 0(t2)
.end_macro

.macro retorno
	csrrw t0, uepc, zero
    addi t0, t0, 4
    csrrw zero, uepc, t0
    uret
.end_macro 

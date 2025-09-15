.macro configurar_interrupciones(%handler)
	la t0, %handler # t0 <- dirección del manejador de interrupciones
	csrrw zero, utvec, t0 # utvec <- t0 | vector de manejadores
	csrrsi zero, ustatus, 0x1 # ustatus <- 1 | habilitar interrupciones
.end_macro

.macro retorno
	csrrw t0, uepc, zero
    addi t0, t0, 4
    csrrw zero, uepc, t0
    uret
.end_macro 
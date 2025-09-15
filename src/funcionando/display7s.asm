
.eqv DISPLAY 0xFFFF0
.eqv IZQ 0x011
.eqv DER 0x010
.eqv PUNTO 0x080
.eqv CERO 0x03F
.eqv UNO 0x006
.eqv DOS 0x05B
.eqv TRES 0x04F
.eqv CUATRO 0x066
.eqv CINCO 0x06D
.eqv SEIS 0x07D
.eqv SIETE 0x007
.eqv OCHO 0x07F


.eqv D_0 0x3F  # 0
.eqv D_1 0x06  # 1
.eqv D_2 0x5B  # 2
.eqv D_3 0x4F  # 3
.eqv D_4 0x66  # 4
.eqv D_5 0x6D  # 5
.eqv D_6 0x7D  # 6
.eqv D_7 0x07  # 7
.eqv D_8 0x7F  # 8
.eqv D_9 0x6F  # 9
.eqv D_E 0x79  # E
.eqv D_r 0x50  # r
.eqv D_O 0x3F  # O
.eqv D_k 0x75  # k
.eqv D_t 0x78  # k
.eqv D_w 0x2A  # w
.eqv D_n 0x37  # n

.data
digitos: .byte D_0, D_1, D_2, D_3, D_4, D_5, D_6, D_7, D_8, D_9
letras:
	.byte 0x77, 0x7C, 0x39, 0x5E	# a b c d
	.byte 0x79, 0x71, 0x3D, 0x76	# e f g h
	.byte 0x06, 0x1E, 0x75, 0x38	# i j k l
	.byte 0x37, 0x54, 0x3F, 0x73	# m n o p
	.byte 0x67, 0x50, 0x6D, 0x78	# q r s t
	.byte 0x3E, 0x1C, 0x2A, 0x76	# u v w x
	.byte 0x6E, 0x5B	# y z
	
# s1 puntero al display
# s0 contenido a mostrar

.macro displayIzq (%content)
	li t0, %content
	lui t1, DISPLAY
	ori t1, t1, IZQ
	sb t0, 0(t1)
.end_macro

.macro displayIzq_reg(%reg)   # para variables en registros
	mv t0, %reg
	lui t1, DISPLAY
	ori t1, t1, IZQ
	sb t0, 0(t1)
.end_macro

.macro displayDer (%content)
	li t0, %content
	lui t1, DISPLAY
	ori t1, t1, DER
	sb t0, 0(t1)
.end_macro

.macro displayDer_reg(%reg)   # para variables en registros
	mv t0, %reg
	lui t1, DISPLAY
	ori t1, t1, DER
	sb t0, 0(t1)
.end_macro

.macro mostrar_intentos(%reg_intentos)
    # %reg_intentos: valor entre 0 y 3
    la t0, digitos          # direcci�n base de la tabla de d�gitos
    add t0, t0, %reg_intentos
    lb t1, 0(t0)            # patr�n 7 segmentos del n�mero
    displayDer_reg t1       # mostrar en display derecho
.end_macro

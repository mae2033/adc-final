# Modulo informacion juego
.eqv long_juego 26

.data
mensaje_g: .asciz "Ganaste!"
mensaje_p: .asciz "Perdiste!"

# Pistas de la A a la Z
pista_a: .asciz "Estructura de datos indexada\n"
pista_b: .asciz "Zona de memoria para datos temporales\n"
pista_c: .asciz "Memoria rapida entre CPU y RAM\n"
pista_d: .asciz "Proceso de encontrar y corregir errores\n"
pista_e: .asciz "Tecnologia de red cableada\n"
pista_f: .asciz "Software integrado en hardware\n"
pista_g: .asciz "Dispositivo que conecta redes\n"
pista_h: .asciz "Funcion que transforma datos en un valor unico\n"
pista_i: .asciz "Estructura que describe un archivo en Unix\n"
pista_j: .asciz "Formato de intercambio de datos en texto\n"
pista_k: .asciz "Nucleo de un sistema operativo\n"
pista_l: .asciz "Proceso de autenticacion en un sistema\n"
pista_m: .asciz "Funcion para reservar memoria en C\n"
pista_n: .asciz "Elemento en una estructura enlazada o red\n"
pista_o: .asciz "Codigo binario que ejecuta la CPU\n"
pista_p: .asciz "Lenguaje de programacion de alto nivel\n"
pista_q: .asciz "Consulta a una base de datos\n"
pista_r: .asciz "Arquitectura de CPU de instrucciones reducidas\n"
pista_s: .asciz "Interfaz de comunicacion en red\n"
pista_t: .asciz "Elemento usado para autenticacion o control de acceso\n"
pista_u: .asciz "Distribucion popular de Linux\n"
pista_v: .asciz "Maquina o entorno simulado por software\n"
pista_w: .asciz "Sistema de documentos interconectados en Internet\n"
pista_x: .asciz "Sistema de ventanas en entornos Unix\n"
pista_y: .asciz "Formato de texto legible por humanos para datos\n"
pista_z: .asciz "Formato de compresion de archivos\n"

clear_code: .asciz "\033[2J\033[H"

pistas:
    .word pista_a, pista_b, pista_c, pista_d, pista_e, pista_f, pista_g, pista_h, pista_i, pista_j
    .word pista_k, pista_l, pista_m, pista_n, pista_o, pista_p, pista_q, pista_r, pista_s, pista_t
    .word pista_u, pista_v, pista_w, pista_x, pista_y, pista_z
    

# Claves
clave_a: .asciz "array"
clave_b: .asciz "buffer"
clave_c: .asciz "cache"
clave_d: .asciz "debug"
clave_e: .asciz "ethernet"
clave_f: .asciz "firmware"
clave_g: .asciz "gateway"
clave_h: .asciz "hash"
clave_i: .asciz "inode"
clave_j: .asciz "json"
clave_k: .asciz "kernel"
clave_l: .asciz "login"
clave_m: .asciz "malloc"
clave_n: .asciz "node"
clave_o: .asciz "opcode"
clave_p: .asciz "python"
clave_q: .asciz "query"
clave_r: .asciz "risc"
clave_s: .asciz "socket"
clave_t: .asciz "token"
clave_u: .asciz "ubuntu"
clave_v: .asciz "virtual"
clave_w: .asciz "web"
clave_x: .asciz "xorg"
clave_y: .asciz "yaml"
clave_z: .asciz "zip"

claves:
    .word clave_a, clave_b, clave_c, clave_d, clave_e, clave_f, clave_g, clave_h, clave_i, clave_j
	.word clave_k, clave_l, clave_m, clave_n, clave_o, clave_p, clave_q, clave_r, clave_s, clave_t
	.word clave_u, clave_v, clave_w, clave_x, clave_y, clave_z

contador_tiempo: .word 0   # contador global
# Juego de Palabras en Assembler – RISC-V (RARS)

## Requisitos
- **RARS** (RISC-V Assembler and Runtime Simulator)  
  [Descargar aquí](https://github.com/TheThirdOne/rars)  
- **Java** instalado en el sistema (necesario para ejecutar RARS).
- Archivos del proyecto:
  - `main.asm`: programa principal
  - `display7s.asm`: rutinas de display 7 segmentos
  - `mmio.asm`: rutinas de E/S por MMIO
  - `datos.asm`: constantes y tablas
  - `syscalls.asm`: rutinas de llamadas al sistema  

---
## Ejecución
1. Abrir **RARS**.  
2. Cargar `main.asm` (este incluye los otros archivos).  
3. Ensamblar: `Assemble` o **F3**.  
4. Conectar las herramientas:  
   - `Digital Lab Sim`  
   - `Keyboard and Display MMIO Simulator`  
5. Ejecutar: `Run` o **F5**.  
---
## Descripción
El programa es un **juego de adivinanza de palabras**:  
- Se muestran las letras del abecedario una a una en el **display izquierdo**.  
- Para cada letra aparece una **pista en el display MMIO**.
- El jugador debe escribir la **palabra correcta** letra por letra.  
- Cada palabra tiene un número limitado de intentos (configurable) visible en el **display derecho**.  
- Si se acierta, se pasa a la siguiente letra.  
- Si se agotan los intentos, se muestra el mensaje de **Perdiste**.  
- Si se completa todo el juego, aparece el mensaje de **Ganaste**.  


## Notas de uso
- `.eqv INICIO` define desde qué letra comienza el juego (por defecto `0 = a`, para pruebas cortas `25 = z`).  
- `.eqv INTENTOS` define la cantidad de intentos por palabra (máx. 9), es decir los errores tolerados por palabra.
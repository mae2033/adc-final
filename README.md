# Manejo de Excepciones en RISC-V

Este programa en ensamblador RISC-V simula el manejo vectorizado de excepciones en RARS, mostrando el código de causa (`ucause`) en un display de 7 segmentos.

## Excepciones generadas

| ucause | Excepción                  |
| ------ | -------------------------- |
| 2      | `ILLEGAL_INSTRUCTION`      |
| 4      | `LOAD_ADDRESS_MISALIGNED`  |
| 5      | `LOAD_ACCESS_FAULT`        |
| 6      | `STORE_ADDRESS_MISALIGNED` |
| 7      | `STORE_ACCESS_FAULT`       |
| 8      | `ENVIRONMENT_CALL`         |

> Ejecutar en RARS con el display conectado.

## Modo vectorizado simulado

Se salta a cada manejador con:

```asm
utvec = base + 4 * ucause
```

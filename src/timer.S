.syntax unified
@ Simple timer library
@ NOTE: This module depends on symbols.S
.global init_buttons
.global SysTick_Handler, init_systick

.type init_systick, %function
init_systick:
  @ set SYST_CSR_ENABLE - bit 0
  @ set SYST_CSR_TICKINT - bit 1
  @ set SYST_CSR_CLKSOURCE - bit 2 (default)
  ldr r0, =SYST_CSR
  ldr r1, =(1 << 0 | 1 << 1)
  str r1, [r0]

  @ SysTick to interrupt at a constant rate
  @ count down from FIFTY_MILLISECONDS (3.2M cycles) repeating 5 times
  ldr r0, =SYST_RVR
  ldr r1, =RVR_50MS
  str r1, [r0]

  @ @ set priority of SYSTICK
  @ @ SHPR3: B3.2.12 in ARMv7-M Reference Manual
  @ ldr r0, =SHPR3
  @ ldr r1, =(1 << 30) @ set the 29-31th bit priority 2 (lower priority)
  @ str r1, [r0]

  bx lr
.size init_systick, .-init_systick

.type SysTick_Handler, %function
@ Interrupts and toggle led
@ --parameters--
@ none
@ --return--
@ none
SysTick_Handler:
  nop
  push {lr}
  ldr r0, =systic_repeat
  ldr r2, [r0]
  cmp r2, 0
  IT GT
  blgt SysTick_Handler_pass
SysTick_Handler_do:
  push {r2, r3}
  push {lr}
  bl change_pet_status
  pop {lr}

  pop {r2, r3}
  ldr r0, =systic_repeat
  ldr r2, [r0, 4]
  str r2, [r0]
  b SysTick_Handler_end
SysTick_Handler_pass:
  sub r2, r2, 1
  ldr r0, =systic_repeat
  str r2, [r0]
  b SysTick_Handler_end
SysTick_Handler_end:
  pop {lr}
  bx lr
.size SysTick_Handler, .-SysTick_Handler

.data
@ 50 ms per 1 cycle
@ 1 second per 20 cycles
@ 10 seconds per 200 cycles
@ 30 seconds per 600 cycles
systic_repeat:
.word 20, 20

@ SysTick vars
.set RVR_50MS,     3200000
.set RVR_10MS,     640000
.set RVR_1MS,      64000
.set RVR_0_5MS,    32000

@ SysTick register
.set SYST_CSR, 0xE000E010
.set SYST_RVR, 0xE000E014
.set SYST_CVR, 0xE000E018
.set SYST_CALIB, 0xE000E01C
.set SHPR3, 0xE000ED20
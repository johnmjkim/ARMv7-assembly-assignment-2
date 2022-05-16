.syntax unified
.global main

.type main, %function
main:
  nop
  @ Configure LEDS for some visual output
  bl init_leds

  @ Configure buttons for input 
  bl init_buttons

  @ Configure systick
  bl setupSYSTICK

  ldr r0, =game_round
  mov r1, 3
  str r1, [r0]

  ldr r0, =correct_motion
  mov r1, 2
  str r1, [r0]

  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_telepathy_game
  pop {lr}
  b loop

@ .global SysTick_Handler
@ .type SysTick_Handler, %function
@ @ Interrupts and toggle led
@ @ --parameters--
@ @ none
@ @ --return--
@ @ none
@ SysTick_Handler:
@   nop
@   push {lr}
@   ldr r0, =systic_repeat
@   ldr r2, [r0]
@   cmp r2, 0
@   IT GT
@   blgt SysTick_Handler_pass
@ SysTick_Handler_do:
@   push {r2, r3}
@   @ toggle the center led
@   ldr r2, =led_state
@   ldr r3, [r2]
@   eor r3, r3, 0b100
@   str r3, [r0]
@   mov r0, 2
@   bl led_blink_50ms

@   pop {r2, r3}
@   ldr r0, =systic_repeat
@   ldr r2, [r0, 4]
@   str r2, [r0]
@   b SysTick_Handler_end
@ SysTick_Handler_pass:
@   sub r2, r2, 1
@   ldr r0, =systic_repeat
@   str r2, [r0]
@   b SysTick_Handler_end
@ SysTick_Handler_end:
@   pop {lr}
@   bx lr
@ .size SysTick_Handler, .-SysTick_Handler

@ .type setupSYSTICK, %function
@ setupSYSTICK:
@   @ set SYST_CSR_ENABLE - bit 0
@   @ set SYST_CSR_TICKINT - bit 1
@   @ set SYST_CSR_CLKSOURCE - bit 2 (default)
@   ldr r0, =SYST_CSR
@   ldr r1, =(1 << 0 | 1 << 1)
@   str r1, [r0]

@   @ SysTick to interrupt at a constant rate
@   @ count down from FIFTY_MILLISECONDS (3.2M cycles) repeating 5 times
@   ldr r0, =SYST_RVR
@   ldr r1, =FIFTY_MILLISECOND
@   str r1, [r0]

@   @ @ set priority of SYSTICK
@   @ @ SHPR3: B3.2.12 in ARMv7-M Reference Manual
@   @ ldr r0, =SHPR3
@   @ ldr r1, =(1 << 30) @ set the 29-31th bit priority 2 (lower priority)
@   @ str r1, [r0]

@   bx lr
@ .size setupSYSTICK, .-setupSYSTICK

@ .data
@ systic_repeat:
@ .word 5, 5
@ led_state:
@ .word 0

@ @ SysTick vars
@ .set RVR_50MS,     3200000
@ .set RVR_1MS,      64000
@ .set RVR_0_5MS,    32000

@ .data
@ .set ONE_MILLISECOND, 0xFA00 @ 64K cycles
@ .set TEN_MILLISECOND, 0x9C400 @ 0.64M cycles
@ .set FIFTY_MILLISECOND, 0xF42400 @ 3.2M cycles


@ @ SysTick register
@ .set SYST_CSR, 0xE000E010
@ .set SYST_RVR, 0xE000E014
@ .set SYST_CVR, 0xE000E018
@ .set SYST_CALIB, 0xE000E01C
@ .set SHPR3, 0xE000ED20
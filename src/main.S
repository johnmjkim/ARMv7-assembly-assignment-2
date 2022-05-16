.syntax unified
.global main

@ SysTick vars
.set RVR_50MS,     3200000
.set RVR_1MS,      64000
.set RVR_0_5MS,    32000
@ Timer vars
.set TIMER0_1MS,   1000
.set TIMER0_0_5MS, 500

.type main, %function
main:
  nop
  @ Configure LEDS for some visual output
  bl init_leds

  @ Configure buttons for input 
  bl init_buttons

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
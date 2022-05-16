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

  @ ldr r0, =game_round
  @ mov r1, 3
  @ str r1, [r0]

  @ ldr r0, =correct_motion
  @ mov r1, 2
  @ str r1, [r0]

  b loop
.size main, .-main

loop:
  nop
  @ push {lr}
  @ bl display_telepathy_game
  @ pop {lr}
  b loop
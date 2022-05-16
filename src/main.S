.syntax unified
.global main

.type main, %function
main:
  nop
  push {lr}
  bl init_leds
  pop {lr}
  ldr r0, =game_round
  mov r1, 2
  str r1, [r0]
  ldr r0, =correct_motion
  mov r1, 5
  str r1, [r0]
  push {lr}
  bl pet_position_middle
  pop {lr}
  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_telepathy_game
  pop {lr}
  b loop



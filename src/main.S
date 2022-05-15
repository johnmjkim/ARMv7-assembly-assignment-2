.syntax unified
.global main

.type main, %function
main:
  nop
  push {lr}
  bl init_leds
  pop {lr}
  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_pet_status
  pop {lr}
  b loop

.data
game_round:
.word 0, 0, 5
correct_motion:
.word 0, 0, 5

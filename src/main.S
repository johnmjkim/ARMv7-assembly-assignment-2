.syntax unified
.global main

.type main, %function
main:
  nop
  push {lr}
  bl init_leds
  pop {lr}
  ldr r0, =hp
  mov r1, 4
  str r1, [r0]
  ldr r0, =food_stock
  mov r1, 2
  str r1, [r0]
  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_feed_pet
  pop {lr}
  b loop

.data
game_round:
.word 0, 0, 5
correct_motion:
.word 0, 0, 5

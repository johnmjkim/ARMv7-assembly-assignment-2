.syntax unified
.global main

.type main, %function
main:
  nop
  push {lr}
  bl init_leds
  pop {lr}
  mov r1, 3
  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_upper_status_bar
  pop {lr}
  b loop

.data
hp:
.word 5, 0, 5
stress:
.word 0, 0, 5
food_stock:
.word 0, 0, 5
game_round:
.word 0, 0, 5
correct_motion:
.word 0, 0, 5

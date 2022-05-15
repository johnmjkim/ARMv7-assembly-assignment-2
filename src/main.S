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
  bl display_happy_face
  pop {lr}
  b loop
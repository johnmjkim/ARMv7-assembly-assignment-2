.syntax unified
.global main

.type main, %function
main:
  nop
  push {lr}
  bl init_leds
  pop {lr}
  mov r0, 0
  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_feed_pet_option
  pop {lr}
  b loop
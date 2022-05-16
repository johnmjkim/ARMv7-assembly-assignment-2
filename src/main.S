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
  bl init_systick

  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_pet_status
  pop {lr}
  b loop
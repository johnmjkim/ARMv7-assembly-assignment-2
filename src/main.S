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
  ldr r0, =current_state
  mov r1, 0
  str r1, [r0]
  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display
  pop {lr}
  b loop

.type display, %function
@ current_state:
@ 0 (see pet), 1 (pet status), 2 (telepathy game), 3 (feed pet), 4 (menu display)
display:
  push {r0}
  ldr r0, =current_state
  ldr r0, [r0]
  cmp r0, 0
  IT EQ
  beq display_state0
  cmp r0, 1
  IT EQ
  beq display_state1
  cmp r0, 2
  IT EQ
  beq display_state2
  cmp r0, 3
  IT EQ
  beq display_state3
  cmp r0, 4
  IT EQ
  beq display_state4
display_state0:
  push {lr}
  bl display_see_pet
  pop {lr}
  b display_end
display_state1:
  push {lr}
  bl display_pet_status
  pop {lr}
  b display_end
display_state2:
  push {lr}
  bl display_telepathy_game
  pop {lr}
  b display_end
display_state3:
  push {lr}
  bl display_feed_pet
  pop {lr}
  b display_end
@ current_menu_display
@ 0 (see pet), 1 (pet status), 2 (telepathy game), 3 (feed pet), 4 (exit option)
display_state4:
  ldr r0, =current_menu_display
  ldr r0, [r0]
  push {lr}
  bl display_menu
  pop {lr}
  b display_end
display_end:
  pop {r0}
  bx lr
.size display, .-display
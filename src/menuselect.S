.syntax unified
@ Simple menuselect library
@ NOTE: This module depends on led.S
.global display_see_pet_option, display_pet_status_option, display_telepathy_game_option, display_feed_pet_option, display_exit_option
.global display_menu, display_scroll
@ --------------------- Implementation --------------------
.type display_see_pet_option, %function
@ see pet
@ --parameters--
@ none
display_see_pet_option:
  push {r0, lr}
  mov r0, 0
  bl display_menu
  pop {r0, lr}
  bx lr
.size display_see_pet_option, .-display_see_pet_option

@ --------------------- Implementation --------------------
.type display_pet_status_option, %function
@ pet status
@ --parameters--
@ none
display_pet_status_option:
  push {r0, lr}
  mov r0, 1
  bl display_menu
  pop {r0, lr}
  bx lr
.size display_pet_status_option, .-display_pet_status_option

@ --------------------- Implementation --------------------
.type display_telepathy_game_option, %function
@ telepathy game
@ --parameters--
@ none
display_telepathy_game_option:
  push {r0, lr}
  mov r0, 2
  bl display_menu
  pop {r0, lr}
  bx lr
.size display_telepathy_game_option, .-display_telepathy_game_option

@ --------------------- Implementation --------------------
.type display_feed_pet_option, %function
@ feed pet
@ --parameters--
@ none
display_feed_pet_option:
  push {r0, lr}
  mov r0, 3
  bl display_menu
  pop {r0, lr}
  bx lr
.size display_feed_pet_option, .-display_feed_pet_option

@ --------------------- Implementation --------------------
.type display_exit_option, %function
@ exit option
@ --parameters--
@ none
display_exit_option:
  push {r0, lr}
  mov r0, 4
  bl display_menu
  pop {r0, lr}
  bx lr
.size display_exit_option, .-display_exit_option

@ --------------------- Implementation --------------------
.type display_menu, %function
@ r0 : menu 
@ 0 (see pet), 
@ 1 (pet status), 
@ 2 (telepathy game), 
@ 3 (feed pet), 
@ 4 (exit option)
@ --parameters--
@ none
display_menu:
  push {r1-r5}
  ldr r2, =menu_display
  mov r3, 0
  mov r5, 4
display_menu_type_loop:
  ldr r4, [r2]
  add r2, r5
  cmp r3, r0
  beq display_menu_loop_setup
  mla r2, r4, r5, r2
  add r3, 1
  b display_menu_type_loop
display_menu_loop_setup:
  mov r3, 0
  push {r0}
display_menu_loop:
  cmp r3, r4
  beq display_menu_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_menu_loop
display_menu_end:
  pop {r0}
  pop {r1-r5}
  bx lr
.size display_menu, .-display_menu

.type display_scroll, %function
display_scroll:
  push {r0-r1, lr}
  ldr r0, =current_menu_display
  ldr r1, [r0]
  add r1, 1
  ldr r0, [r0, 8]
  add r0, 1
  cmp r1, r0
  IT GE
  subge r1, r0
  ldr r0, =current_menu_display
  str r1, [r0]
  pop {r0-r1, lr}
  bx lr
.size display_scroll, .-display_scroll

.data
menu_display:
@ see pet
.word 14, 1, 1, 1, 2, 2, 1, 2, 2, 2, 3, 3, 1, 3, 2
@ pet status
.word 18, 0, 2, 1, 2, 2, 0, 2, 1, 2, 2, 2, 3, 2, 4, 3, 2, 4, 2
@ telepathy game
.word 14, 0, 2, 1, 1, 2, 1, 2, 2, 2, 3, 3, 3, 4, 2
@ feed pet
.word 18, 0, 1, 0, 3, 1, 1, 1, 3, 2, 1, 2, 2, 2, 3, 3, 2, 4, 2
@ exit option
.word 18, 0, 0, 0, 4, 1, 1, 1, 3, 2, 2, 3, 1, 3, 3, 4, 0, 4, 4

.global current_menu_display, current_state
current_menu_display:
@ 0 (see pet), 1 (pet status), 2 (telepathy game), 3 (feed pet), 4 (exit option)
.word 0, 0, 4
current_state:
@ 0 (see pet), 1 (pet status), 2 (telepathy game), 3 (feed pet), 4 (menu display)
.word 4, 0, 4



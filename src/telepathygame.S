.syntax unified
@ Simple telepathy game library
@ NOTE: This module depends on led.S
.global display_telepathy_game

@ --------------------- Implementation --------------------
.type display_telepathy_game, %function
@ 
@ telepathy game
@ --parameters--
@ none
display_telepathy_game:
  push {lr}
  bl display_telepathy_game_background
  pop {lr}
  push {r2-r3}
  mov r2, 0
  mov r3, 9
display_telepathy_game_loop:
  cmp r2, r3
  beq display_telepathy_game_end
  
  ldr r0, =game_round
  ldr r1, [r0]
  push {lr}
  bl display_upper_status_bar
  pop {lr}

  ldr r0, =correct_motion
  ldr r1, [r0]
  push {lr}
  bl display_under_status_bar
  pop {lr}
  add r2, 1
  b display_telepathy_game_loop
display_telepathy_game_end:
  pop {r2-r3}
  bx lr
.size display_telepathy_game, .-display_telepathy_game

@ --------------------- Implementation --------------------
.type display_telepathy_game_background, %function
@ none
display_telepathy_game_background:
  push {r1-r5}
  ldr r2, =telepathy_game_background
  mov r3, 0
  ldr r4, [r2]
  add r2, 4
  mov r5, 4
display_telepathy_game_background_loop:
  cmp r3, r4
  beq display_telepathy_game_background_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_telepathy_game_background_loop
display_telepathy_game_background_end:
  pop {r1-r5}
  bx lr
.size display_telepathy_game_background, .-display_telepathy_game_background

.global game_round, correct_motion
.data
telepathy_game_background:
@ pet status background
.word 6, 2, 0, 2, 2, 2, 4
game_round:
.word 0, 0, 5
correct_motion:
.word 0, 0, 5

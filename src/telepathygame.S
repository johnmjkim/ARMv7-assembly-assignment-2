.syntax unified
@ Simple telepathy game library
@ NOTE: This module depends on led.S
.global display_telepathy_game
.global pet_position_left, pet_position_middle, pet_position_right

@ --------------------- Implementation --------------------
.type display_telepathy_game, %function
@ telepathy game
@ --parameters--
@ none
display_telepathy_game:

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

  ldr r0, =pet_position
  ldr r1, [r0]
  mov r0, 2
  push {lr}
  bl led_blink
  pop {lr}

  bx lr
.size display_telepathy_game, .-display_telepathy_game

.type pet_position_left, %function
pet_position_left:
  push {r0, lr}
  mov r0, 0
  bl change_pet_position
  pop {r0, lr}
  bx lr
.size pet_position_left, .-pet_position_left

.type pet_position_middle, %function
pet_position_middle:
  push {r0, lr}
  mov r0, 1
  bl change_pet_position
  pop {r0, lr}
  bx lr
.size pet_position_middle, .-pet_position_middle

.type pet_position_right, %function
pet_position_right:
  push {r0, lr}
  mov r0, 2
  bl change_pet_position
  pop {r0, lr}
  bx lr
.size pet_position_right, .-pet_position_right

.type change_pet_position, %function
@ r0 index 0 (left), 1 (middle), 2 (right)
@ --parameters--
@ none
change_pet_position:
  push {r1}
  mov r1, 4
  mla r1, r1, r0, r1

  ldr r0, =pet_position
  ldr r1, [r0, r1]
  str r1, [r0]

  pop {r1}
  bx lr
.size change_pet_position, .-change_pet_position

.global game_round, correct_motion, pet_position
.data
game_round:
.word 0, 0, 5
correct_motion:
.word 0, 0, 5
pet_position:
.word 2, 0, 2, 4

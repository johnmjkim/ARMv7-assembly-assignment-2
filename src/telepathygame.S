.syntax unified
@ Simple telepathy game library
@ NOTE: This module depends on led.S
.global display_telepathy_game
.global pet_position_left, pet_position_middle, pet_position_right
.global increase_game_round, increase_correct_motion

@ --------------------- Implementation --------------------
.type display_telepathy_game, %function
@ telepathy game
@ --parameters--
@ none
display_telepathy_game:
  push {r0-r2}

  ldr r0, =pet_position
  ldr r1, [r0]
  mov r2, r1
  mov r0, 2
  push {r2, lr}
  bl led_blink
  pop {r2, lr}

  cmp r2, 0
  IT EQ
  beq display_telepathy_game_left
  cmp r2, 4
  IT EQ
  beq display_telepathy_game_right
  cmp r2, 2
  IT EQ
  beq display_telepathy_game_status

display_telepathy_game_left:
@   mov r0, 2
@   mov r1, r2
@   push {r2, lr}
@   bl led_blink_50ms
@   pop {r2, lr}

  mov r0, 1
  push {lr}
  bl increase_game_round
  pop {lr}

  b display_telepathy_game_status

display_telepathy_game_right:
@   mov r0, 2
@   mov r1, r2
@   push {r2, lr}
@   bl led_blink_50ms
@   pop {r2, lr}
  
  mov r0, 1
  push {lr}
  bl increase_correct_motion
  pop {lr}

  b display_telepathy_game_status

display_telepathy_game_status:
  push {lr}
  bl pet_position_middle
  pop {lr}

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
  b display_telepathy_game_end

display_telepathy_game_end:
  pop {r0-r2}
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

.type increase_game_round, %function
@ r0 : increment
increase_game_round:
  push {r1-r2}
  push {r0}
  ldr r0, =game_round
  ldr r1, [r0]
  ldr r2, [r0, 8]
  pop {r0}
  add r1, r0
  cmp r1, r2
  IT GT
  movgt r1, r2
  ldr r0, =game_round
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size increase_game_round, .-increase_game_round

.type increase_correct_motion, %function
@ r0 : increment
increase_correct_motion:
  push {r1-r2}
  push {r0}
  ldr r0, =correct_motion
  ldr r1, [r0]
  ldr r2, [r0, 8]
  pop {r0}
  add r1, r0
  cmp r1, r2
  IT GT
  movgt r1, r2
  ldr r0, =correct_motion
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size increase_correct_motion, .-increase_correct_motion

.type decrease_game_round, %function
@ r0 : decrement
decrease_game_round:
  push {r1-r2}
  push {r0}
  ldr r0, =game_round
  ldr r1, [r0]
  ldr r2, [r0, 4]
  pop {r0}
  sub r1, r0
  cmp r1, r2
  IT LT
  movlt r1, r2
  ldr r0, =game_round
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size decrease_game_round, .-decrease_game_round

.type decrease_correct_motion, %function
@ r0 : decrement
decrease_correct_motion:
  push {r1-r2}
  push {r0}
  ldr r0, =correct_motion
  ldr r1, [r0]
  ldr r2, [r0, 4]
  pop {r0}
  sub r1, r0
  cmp r1, r2
  IT LT
  movlt r1, r2
  ldr r0, =correct_motion
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size decrease_correct_motion, .-decrease_correct_motion

.global game_round, correct_motion, pet_position
.data
game_round:
.word 1, 1, 5
correct_motion:
.word 0, 0, 5
pet_position:
.word 2, 0, 2, 4

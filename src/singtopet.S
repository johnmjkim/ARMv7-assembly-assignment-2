.syntax unified
@ Simple sing to pet library
@ NOTE: This module depends on led.S
.global display_sing_to_pet
.global increase_correct_sing, decrease_correct_sing

@ --------------------- Implementation --------------------
.type display_sing_to_pet, %function
@ sing to pet
@ --parameters--
@ none
display_sing_to_pet:
  push {r0-r1}
  ldr r0, =correct_sing
  ldr r1, [r0]
  push {lr}
  bl display_under_status_bar
  pop {lr}
  pop {r0, r1}
  bx lr
.size display_sing_to_pet, .-display_sing_to_pet

.type increase_correct_sing, %function
@ r0 : increment
increase_correct_sing:
  push {r1-r2}
  push {r0}
  ldr r0, =correct_sing
  ldr r1, [r0]
  ldr r2, [r0, 8]
  pop {r0}
  add r1, r0
  cmp r1, r2
  IT GT
  movgt r1, r2
  ldr r0, =correct_sing
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size increase_correct_sing, .-increase_correct_sing

.type decrease_correct_sing, %function
@ r0 : decrement
decrease_correct_sing:
  push {r1-r2}
  push {r0}
  ldr r0, =correct_sing
  ldr r1, [r0]
  ldr r2, [r0, 4]
  pop {r0}
  sub r1, r0
  cmp r1, r2
  IT LT
  movlt r1, r2
  ldr r0, =correct_sing
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size decrease_correct_sing, .-decrease_correct_sing

.global correct_sing
.data
correct_sing:
.word 5, 0, 5


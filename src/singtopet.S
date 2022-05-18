.syntax unified
@ Simple sing to pet library
@ NOTE: This module depends on led.S
.global display_sing_to_pet, change_target_sound_amplitude, evaluate_sound_amplitude
.global increase_correct_sing, decrease_correct_sing

@ --------------------- Implementation --------------------
.type display_sing_to_pet, %function
@ sing to pet
@ --parameters--
@ none
display_sing_to_pet:
  push {r0-r1}
  ldr r0, =target_sound_amplitude
  ldr r1, [r0]
  add r1, 1
  push {lr}
  bl display_upper_status_bar
  pop {lr}

  ldr r0, =my_sound_amplitude
  ldr r1, [r0]
  push {lr}
  bl display_middle_status_bar
  pop {lr}

  ldr r0, =correct_sing
  ldr r1, [r0]
  push {lr}
  bl display_under_status_bar
  pop {lr}
  pop {r0-r1}
  bx lr
.size display_sing_to_pet, .-display_sing_to_pet

.type change_target_sound_amplitude, %function
change_target_sound_amplitude:
  push {r0-r1, lr}
  mov r0, 4
  bl generate_random
  ldr r1, =target_sound_amplitude
  str r0, [r1]
  pop {r0-r1, lr}
  bx lr
.size change_target_sound_amplitude, .-change_target_sound_amplitude

.type evaluate_sound_amplitude, %function
evaluate_sound_amplitude:
  push {r0-r2, lr}
  ldr r0, =target_sound_amplitude
  ldr r1, [r0]
  add r1, 1
  ldr r0, =my_sound_amplitude
  ldr r2, [r0]
  cmp r1, r2
  IT EQ
  beq evaluate_sound_amplitude_within
  b evaluate_sound_amplitude_end
evaluate_sound_amplitude_within:
  push {lr}
  mov r0, 1
  bl increase_correct_sing
  pop {lr}
evaluate_sound_amplitude_end:
  pop {r0-r2, lr}
  bx lr
.size evaluate_sound_amplitude, .-evaluate_sound_amplitude

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

.global target_sound_amplitude, my_sound_amplitude, correct_sing
.data
target_sound_amplitude:
.word 0, 0, 4
my_sound_amplitude:
.word 2, 0, 5
correct_sing:
.word 0, 0, 5


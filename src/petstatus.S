.syntax unified
@ Simple petstatus library
@ NOTE: This module depends on led.S
.global display_pet_status

@ --------------------- Implementation --------------------
.type display_pet_status, %function
@ pet status
@ --parameters--
@ none
display_pet_status:
  push {lr}
  bl display_pet_status_background
  pop {lr}
  push {r2-r3}
  mov r2, 0
  mov r3, 9
display_pet_status_loop:
  cmp r2, r3
  beq display_pet_status_end
  ldr r0, =hp
  ldr r1, [r0]
  push {lr}
  bl display_upper_status_bar
  pop {lr}

  ldr r0, =stress
  ldr r1, [r0]
  push {lr}
  bl display_under_status_bar
  pop {lr}
  add r2, 1
  b display_pet_status_loop
display_pet_status_end:
  pop {r2-r3}
  bx lr
.size display_pet_status, .-display_pet_status

@ --------------------- Implementation --------------------
.type display_pet_status_background, %function
@ none
display_pet_status_background:
  push {r1-r5}
  ldr r2, =pet_status_background
  mov r3, 0
  ldr r4, [r2]
  add r2, 4
  mov r5, 4
display_pet_status_background_loop:
  cmp r3, r4
  beq display_pet_status_background_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_pet_status_background_loop
display_pet_status_background_end:
  pop {r1-r5}
  bx lr
.size display_pet_status_background, .-display_pet_status_background

.global hp, stress, food_stock
.data
pet_status_background:
@ pet status background
.word 10, 1, 2, 2, 1, 2, 2, 2, 3, 3, 2
hp:
.word 5, 0, 5
stress:
.word 0, 0, 5
food_stock:
.word 0, 0, 5


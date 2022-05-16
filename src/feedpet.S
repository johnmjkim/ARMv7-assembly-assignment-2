.syntax unified
@ Simple feedpet library
@ NOTE: This module depends on led.S
.global display_feed_pet

@ --------------------- Implementation --------------------
.type display_feed_pet, %function
@ pet status
@ --parameters--
@ none
display_feed_pet:
  push {lr}
  bl display_feed_pet_background
  pop {lr}
  push {r2-r3}
  mov r2, 0
  mov r3, 9
display_feed_pet_loop:
  cmp r2, r3
  beq display_feed_pet_end
  ldr r0, =hp
  ldr r1, [r0]
  push {lr}
  bl display_upper_status_bar
  pop {lr}

  ldr r0, =food_stock
  ldr r1, [r0]
  push {lr}
  bl display_under_status_bar
  pop {lr}
  add r2, 1
  b display_feed_pet_loop
display_feed_pet_end:
  pop {r2-r3}
  bx lr
.size display_feed_pet, .-display_feed_pet

@ --------------------- Implementation --------------------
.type display_feed_pet_background, %function
@ none
display_feed_pet_background:
  push {r1-r5}
  ldr r2, =feed_pet_background
  mov r3, 0
  ldr r4, [r2]
  add r2, 4
  mov r5, 4
display_feed_pet_background_loop:
  cmp r3, r4
  beq display_feed_pet_background_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_feed_pet_background_loop
display_feed_pet_background_end:
  pop {r1-r5}
  bx lr
.size display_feed_pet_background, .-display_feed_pet_background

.global food_stock
.data
feed_pet_background:
@ pet status background
.word 12, 1, 1, 1, 3, 2, 1, 2, 2, 2, 3, 3, 2
food_stock:
.word 0, 0, 5


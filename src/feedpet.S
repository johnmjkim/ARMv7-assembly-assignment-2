.syntax unified
@ Simple feedpet library
@ NOTE: This module depends on led.S
.global display_feed_pet, feed_pet
.global increase_food_stock, decrease_food_stock

.type feed_pet, %function
feed_pet:
  push {r0, lr}
  mov r0, 1
  bl decrease_food_stock
  mov r0, 1
  bl increase_HP
  pop {r0, lr}
  bx lr
.size feed_pet, .-feed_pet

@ --------------------- Implementation --------------------
.type display_feed_pet, %function
@ feed pet
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

.type increase_food_stock, %function
@ r0 : increment
increase_food_stock:
  push {r1-r2}
  push {r0}
  ldr r0, =food_stock
  ldr r1, [r0]
  ldr r2, [r0, 8]
  pop {r0}
  add r1, r0
  cmp r1, r2
  IT GT
  movgt r1, r2
  ldr r0, =food_stock
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size increase_food_stock, .-increase_food_stock

.type decrease_food_stock, %function
@ r0 : decrement
decrease_food_stock:
  push {r1-r2}
  push {r0}
  ldr r0, =food_stock
  ldr r1, [r0]
  ldr r2, [r0, 4]
  pop {r0}
  sub r1, r0
  cmp r1, r2
  IT LT
  movlt r1, r2
  ldr r0, =food_stock
  str r1, [r0]
  pop {r1-r2}
  bx lr
.size decrease_food_stock, .-decrease_food_stock

.global food_stock
.data
feed_pet_background:
@ pet status background
.word 12, 1, 1, 1, 3, 2, 1, 2, 2, 2, 3, 3, 2
food_stock:
.word 5, 0, 5


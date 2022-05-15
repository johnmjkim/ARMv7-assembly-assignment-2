.syntax unified
@ Simple tamagochi library
@ NOTE: This module depends on led.S

@ --------------------- Module Interface --------------------
@ declare all labels corresponding to functions designed to be called from elsewhere
@ as global - this is the public API of the library
@ Function exports:
.global display_happy_face
@ .global init_leds, write_row_pin, write_column_pin, write_led_pin, 
@ .global write_led, write_pins, write_row_pins, write_column_pins, 
@ .global read_led, read_pins, read_row, read_column,
 
@ --------------------- Implementation --------------------
.type display_happy_face, %function
@ dd
@ --parameters--
@ none
display_happy_face:
  push {r0-r4}
  ldr r2, =eye
  mov r3, 0
  mov r4, 4
display_happy_face_eye_loop:
  cmp r3, r4
  beq display_happy_face_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_happy_face_eye_loop
display_happy_face_end:
  pop {r0-r4}
  bx lr
.size display_happy_face, .-display_happy_face

@ --------------------- Implementation --------------------
.type display_eye, %function
@ dd
@ --parameters--
@ none
display_eye:
  push {r0-r4}
  ldr r2, =eye
  mov r3, 0
  mov r4, 4
display_eye_loop:
  cmp r3, r4
  beq display_eye_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_eye_loop
display_eye_end:
  pop {r0-r4}
  bx lr
.size display_happy_face, .-display_happy_face

.type led_blink, %function
@ --parameters--
@ r0: row index (0-4 with 0 being the top row)
@ r1: column index (0-4 with 0 being the left most column)
@ --return--
@ none
led_blink:
  push {lr}
  bl led_on
  pop {lr}

  push {lr}
  bl led_off
  pop {lr}

  bx lr
.size led_blink, .-led_blink

.type led_on, %function
@ --parameters--
@ r0: row index (0-4 with 0 being the top row)
@ r1: column index (0-4 with 0 being the left most column)
@ --return--
@ none
led_on:
  push {r2}
  ldr r2, =0b1
  lsl r0, r2, r0
  push {r1, lr}
  bl write_row_pins
  pop {r1, lr}

  ldr r2, =0b1
  lsl r1, r2, r1
  ldr r0, =0b11111
  eor r0, r0, r1
  push {lr}
  bl write_column_pins
  pop {lr}

  pop {r2}

  bx lr
.size led_on, .-led_on

.type led_off, %function
@ Interrupts and toggle led
@ --parameters--
@ none
@ --return--
@ none
led_off:
  push {r2}
  ldr r0, =0b00000
  push {lr}
  bl write_row_pins
  pop {lr}

  ldr r0, =0b11111
  push {lr}
  bl write_column_pins
  pop {lr}
  pop {r2}

  bx lr
.size led_off, .-led_off

.data
eye:
@ happy:
.word 1, 1, 1, 3

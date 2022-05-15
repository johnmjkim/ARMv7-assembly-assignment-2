.syntax unified
@ Simple tamagochi library
@ NOTE: This module depends on led.S

@ --------------------- Module Interface --------------------
@ declare all labels corresponding to functions designed to be called from elsewhere
@ as global - this is the public API of the library
@ Function exports:
.global display_happy_face, display_neutral_face, display_sad_face
.global display_happy_sleep_face, display_neutral_sleep_face, display_sad_sleep_face
@ .global init_leds, write_row_pin, write_column_pin, write_led_pin, 
@ .global write_led, write_pins, write_row_pins, write_column_pins, 
@ .global read_led, read_pins, read_row, read_column,

@ --------------------- Implementation --------------------
.type display_happy_face, %function
@ eye (open), mouth (smile)
@ --parameters--
@ none
display_happy_face:
  push {r0, r1, lr}
  mov r0, 0
  mov r1, 0
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_happy_face, .-display_happy_face

@ --------------------- Implementation --------------------
.type display_neutral_face, %function
@ eye (open), mouth (neutral)
@ --parameters--
@ none
display_neutral_face:
  push {r0, r1, lr}
  mov r0, 0
  mov r1, 1
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_neutral_face, .-display_neutral_face

@ --------------------- Implementation --------------------
.type display_sad_face, %function
@ eye (open), mouth (upset)
@ --parameters--
@ none
display_sad_face:
  push {r0, r1, lr}
  mov r0, 0
  mov r1, 2
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_sad_face, .-display_sad_face

@ --------------------- Implementation --------------------
.type display_happy_sleep_face, %function
@ eye (closed), mouth (smile)
@ --parameters--
@ none
display_happy_sleep_face:
  push {r0, r1, lr}
  mov r0, 1
  mov r1, 0
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_happy_sleep_face, .-display_happy_sleep_face

@ --------------------- Implementation --------------------
.type display_neutrl_sleep_face, %function
@ eye (closed), mouth (neutral)
@ --parameters--
@ none
display_neutral_sleep_face:
  push {r0, r1, lr}
  mov r0, 1
  mov r1, 1
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_neutral_sleep_face, .-display_neutral_sleep_face

@ --------------------- Implementation --------------------
.type display_sad_sleep_face, %function
@ eye (closed), mouth (upset)
@ --parameters--
@ none
display_sad_sleep_face:
  push {r0, r1, lr}
  mov r0, 1
  mov r1, 2
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_sad_sleep_face, .-display_sad_sleep_face

@ --------------------- Implementation --------------------
.type display_face, %function
@ r0 : eye index 0 (open), 1 (closed)
@ r1 : mouth index 0 (smile), 1 (neutral), 2 (upset)
@ --parameters--
@ none
display_face:
  push {lr}
  bl display_eye
  pop {lr}
  push {lr}
  bl display_mouth
  pop {lr}
  bx lr
.size display_face, .-display_face

@ --------------------- Implementation --------------------
.type display_eye, %function
@ r0 : eye index 0 (open), 1 (closed)
@ --parameters--
@ none
display_eye:
  push {r1-r5}
  ldr r2, =eye
  mov r3, 0
  mov r5, 4
display_eye_type_loop:
  ldr r4, [r2]
  add r2, r5
  cmp r3, r0
  beq display_eye_loop_setup
  mla r2, r4, r5, r2
  add r3, 1
  b display_eye_type_loop
display_eye_loop_setup:
  mov r3, 0
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
  pop {r1-r5}
  bx lr
.size display_eye, .-display_eye

@ --------------------- Implementation --------------------
.type display_mouth, %function
@ r1 : mouth index 0 (smile), 1 (neutral), 2 (upset)
@ --parameters--
@ none
display_mouth:
  push {r0, r2-r5}
  ldr r2, =mouth
  mov r3, 0
  mov r5, 4
display_mouth_type_loop:
  ldr r4, [r2]
  add r2, r5
  cmp r3, r1
  beq display_mouth_loop_setup
  mla r2, r4, r5, r2
  add r3, 1
  b display_mouth_type_loop
display_mouth_loop_setup:
  mov r3, 0
display_mouth_loop:
  cmp r3, r4
  beq display_mouth_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_mouth_loop
display_mouth_end:
  pop {r0, r2-r5}
  bx lr
.size display_mouth, .-display_mouth

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
@ open_eye
.word 4, 1, 1, 1, 3
@ closed_eye
.word 8, 1, 0, 1, 1, 1, 3, 1, 4
mouth:
@ smile
.word 10, 3, 0, 4, 1, 4, 2, 4, 3, 3, 4
@ neutral
.word 6, 3, 1, 3, 2, 3, 3
@ upset
.word 10, 4, 0, 3, 1, 3, 2, 3, 3, 4, 4


.syntax unified
@ Simple myleds library
@ NOTE: This module depends on led.S

@ --------------------- Module Interface --------------------
@ declare all labels corresponding to functions designed to be called from elsewhere
@ as global - this is the public API of the library
@ Function exports:
.global led_blink_50ms, led_toggle, led_blink, led_on, led_off

.type led_blink_50ms, %function
@ --parameters--
@ r0: row index (0-4 with 0 being the top row)
@ r1: column index (0-4 with 0 being the left most column)
@ --return--
@ none
led_blink_50ms:
  push {lr}
  bl led_on
  pop {lr}

  ldr r0, =DELAY_50MS
  push {lr}
  bl delay
  pop {lr}

  push {lr}
  bl led_off
  pop {lr}

  bx lr
.size led_blink_50ms, .-led_blink_50ms

.type led_toggle, %function
@ --parameters--
@ r0: row index (0-4 with 0 being the top row)
@ r1: column index (0-4 with 0 being the left most column)
@ --return--
@ none
led_toggle:
  push {r4-r6}
  mov r4, r0
  mov r5, r1
  mov r6, 0b1
  push {lr}
  bl read_row
  pop {lr}

  lsl r4, r6, r4
  eor r0, r0, r4
  push {lr}
  bl write_row_pins
  pop {lr}

  push {lr}
  bl read_column
  pop {lr}

  lsl r5, r6, r5
  eor r0, r0, r5
  push {lr}
  bl write_column_pins
  pop {lr}
  pop {r4-r6}
  bx lr
.size led_toggle, .-led_toggle

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

.set DELAY_50MS,     3200000
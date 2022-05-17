.syntax unified
@ Simple status bar library
@ NOTE: This module depends on led.S
.global display_upper_status_bar, display_middle_status_bar, display_under_status_bar

@ --------------------- Implementation --------------------
.type display_upper_status_bar, %function
@ r0 index 0 (upper), 1 (middle), 2 (under)
@ r1 score (0~5)
@ --parameters--
@ none
display_upper_status_bar:
  push {r0, lr}
  mov r0, 0
  bl display_status_bar
  pop {r0, lr}
  bx lr
.size display_upper_status_bar, .-display_upper_status_bar

.type display_middle_status_bar, %function
@ r0 index 0 (upper), 1 (middle), 2 (under)
@ r1 score (0~5)
@ --parameters--
@ none
display_middle_status_bar:
  push {r0, lr}
  mov r0, 2
  bl display_status_bar
  pop {r0, lr}
  bx lr
.size display_middle_status_bar, .-display_middle_status_bar

.type display_under_status_bar, %function
@ r0 index 0 (upper), 1 (middle), 2 (under)
@ r1 score (0~5)
@ --parameters--
@ none
display_under_status_bar:
  push {r0, lr}
  mov r0, 2
  bl display_status_bar
  pop {r0, lr}
  bx lr
.size display_under_status_bar, .-display_under_status_bar

@ --------------------- Implementation --------------------
.type display_status_bar, %function
@ r0 : menu index 0 (upper), 1 (middle), 2 (under),
@ r1 : score (0~5)
@ --parameters--
@ none
display_status_bar:
  push {r2-r5}
  ldr r2, =status_bar
  mov r3, 0
  mov r5, 4
display_status_bar_type_loop:
  ldr r4, [r2]
  add r2, r5
  cmp r3, r0
  beq display_status_bar_loop_setup
  mla r2, r4, r5, r2
  add r3, 1
  b display_status_bar_type_loop
display_status_bar_loop_setup:
  mov r3, 0
  mov r5, 2
  mul r4, r1, r5
  push {r0-r1}
display_status_bar_loop:
  cmp r3, r4
  beq display_status_bar_end

  ldr r0, [r2, r3, lsl 2]
  add r3, 1
  ldr r1, [r2, r3, lsl 2]
  add r3, 1

  push {r2, r3, lr}
  bl led_blink
  pop {r2, r3, lr}

  b display_status_bar_loop
display_status_bar_end:
  pop {r0-r1}
  pop {r2-r5}
  bx lr
.size display_status_bar, .-display_status_bar

.data
status_bar:
@ upper status bar
.word 10, 0, 0, 0, 1, 0, 2, 0, 3, 0, 4
@ middle status bar
.word 10, 2, 0, 2, 1, 2, 2, 2, 3, 2, 4
@ under status bar
.word 10, 4, 0, 4, 1, 4, 2, 4, 3, 4, 4


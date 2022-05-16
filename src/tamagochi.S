.syntax unified
@ Simple tamagochi library
@ NOTE: This module depends on myleds.S

@ --------------------- Module Interface --------------------
@ declare all labels corresponding to functions designed to be called from elsewhere
@ as global - this is the public API of the library
@ Function exports:
.global display_see_pet
.global display_happy_face, display_neutral_face, display_sad_face
.global display_happy_sleep_face, display_neutral_sleep_face, display_sad_sleep_face

@ --------------------- Implementation --------------------
.type display_see_pet, %function
@ eye (open), mouth (smile)
@ --parameters--
@ none
display_see_pet:
  push {r0, r1, lr}
  mov r0, 0
  mov r1, 0
  bl display_face
  pop {r0, r1, lr}
  bx lr
.size display_see_pet, .-display_see_pet

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
  push {r0}
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
  pop {r0}
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


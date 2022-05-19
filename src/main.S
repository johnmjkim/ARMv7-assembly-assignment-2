.syntax unified
.global main

.type main, %function
main:
  nop
  @ Configure LEDS for some visual output
  bl init_leds

  @ Configure buttons for input 
  bl init_buttons

  @ Configure systick
  bl init_systick

  @ Configure random
  bl init_random

  @ Configure audio
  bl audio_init

  b loop_start
  
.size main, .-main


loop_start:
  nop
  ldr r0, =button_triggered
  ldr r3, [r0]
  cmp r3, 0
  IT EQ
  beq loop_end_set_up
  b loop_set_up

loop_set_up:
  @ get starting index of beat
  mov r4, 4
  ldr r0, =button_sound_index
  ldr r6, [r0, 8]
  add r6, 1
  mul r5, r3, r4
  mul r5, r5, r6

  @ add sound index offset
  ldr r7, [r0]
  mul r6, r7, r4
  add r5, r6

  @ beat starter r1 and adder r2
  mov r1, 0
  ldr r0, =button_trigger_sound
  ldr r2, [r0, r5]

  @ one beat count
  mov r4, 0
  ldr r0, =button_sound_count
  ldr r5, [r0, 8]
loop:
  cmp r4, r5
  IT EQ
  beq loop_next_set_up

  push {lr}
  bl display
  pop {lr}

  add r1, r2
  mov r0, r1
  push {r1-r3}
  bl audio_play_sample
  pop {r1-r3}

  add r4, 1

  b loop

loop_next_set_up:
  ldr r0, =button_sound_index
  ldr r4, [r0]
  ldr r5, [r0, 8]
  cmp r4, r5
  IT EQ
  beq loop_end_set_up
  add r4, 1
  str r4, [r0]
  b loop_set_up

loop_end_set_up:
  ldr r0, =button_sound_index
  ldr r4, [r0, 4]
  str r4, [r0]

  ldr r0, =button_sound_count
  ldr r5, [r0, 8]

  ldr r0, =button_triggered
  ldr r3, [r0, 4]
  str r3, [r0]

  mov r1, 0
  mov r2, 0
  mov r4, 0

loop_end:
  cmp r4, r5
  IT EQ
  beq loop_start

  push {lr}
  bl display
  pop {lr}

  add r1, r2
  mov r0, r1
  push {r1-r3}
  bl audio_play_sample
  pop {r1-r3}

  add r4, 1

  b loop_end

.type display, %function
@ current_state:
@ 0 (see pet), 1 (pet status), 2 (telepathy game), 3 (feed pet), 4 (sing to pet), 5 (menu display)
display:
  push {r0}
  ldr r0, =current_state
  ldr r0, [r0]
  cmp r0, 0
  IT EQ
  beq display_state0
  cmp r0, 1
  IT EQ
  beq display_state1
  cmp r0, 2
  IT EQ
  beq display_state2
  cmp r0, 3
  IT EQ
  beq display_state3
  cmp r0, 4
  IT EQ
  beq display_state4
  cmp r0, 5
  IT EQ
  beq display_state5
display_state0:
  push {lr}
  bl display_see_pet
  pop {lr}
  b display_end
display_state1:
  push {lr}
  bl display_pet_status
  pop {lr}
  b display_end
display_state2:
  push {lr}
  bl display_telepathy_game
  pop {lr}
  b display_end
display_state3:
  push {lr}
  bl display_feed_pet
  pop {lr}
  b display_end
display_state4:
  push {lr}
  bl display_sing_to_pet
  pop {lr}
  b display_end
@ current_menu_display
@ 0 (see pet), 1 (pet status), 2 (telepathy game), 3 (feed pet), 4 (sing to pet), 5 (exit option)
display_state5:
  ldr r0, =current_menu_display
  ldr r0, [r0]
  push {lr}
  bl display_menu
  pop {lr}
  b display_end
display_end:
  pop {r0}
  bx lr
.size display, .-display

.global button_triggered

.data
button_triggered:
@ 0 (none)
@ 1 (button A : select option)
@ 2 (button A : exit)
@ 3 (button A : select left at telepahty game)
@ 4 (button B : scroll)
@ 5 (button B : select right at telepahty game)
@ 6 (button B : feed pet)
.word 0, 0, 6
button_trigger_sound:
@ none
.word 0, 0, 0, 0, 0
@ button A : select option
.word 600, 0, 800, 0, 800
@ button A : select exit
.word 800, 0, 800, 0, 600
@ button A : select left at telepahty game
.word 500, 0, 0, 500, 500
@ button B : scroll
.word 400, 0, 800, 0, 400
@ button B : select right at telepahty game
.word 800, 0, 0, 800, 800
@ button B : feed pet
.word 800, 0, 600, 0, 600

button_sound_count:
.word 0, 0, 300
button_sound_index:
.word 0, 0, 4
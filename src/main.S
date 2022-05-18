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

  @ @ Configure microphone
  @ bl init_microphone

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
  cmp r3, 1
  IT EQ
  beq loop_A_set_up
  cmp r3, 2
  IT EQ
  beq loop_B_set_up
  

loop_end_set_up:
  mov r1, 0
  mov r2, 0
  mov r4, 0
  ldr r0, =button_sound_count
  ldr r5, [r0, 8]

  ldr r0, =button_triggered
  ldr r3, [r0, 4]
  str r3, [r0]

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

loop_A_set_up:
  mov r1, 0
  ldr r0, =button_A_trigger_sound
  ldr r2, [r0]
  mov r4, 0
  ldr r0, =button_sound_count
  ldr r5, [r0, 8]
loop_A:
  cmp r4, r5
  IT EQ
  beq loop_A_1_set_up

  push {lr}
  bl display
  pop {lr}

  add r1, r2
  mov r0, r1
  push {r1-r3}
  bl audio_play_sample
  pop {r1-r3}

  add r4, 1

  b loop_A

loop_A_1_set_up:
  mov r1, 0
  ldr r0, =button_A_trigger_sound
  ldr r2, [r0, 4]
  mov r4, 0
  ldr r0, =button_sound_count
  ldr r5, [r0, 8]
loop_A_1:
  cmp r4, r5
  IT EQ
  beq loop_end_set_up

  push {lr}
  bl display
  pop {lr}

  add r1, r2
  mov r0, r1
  push {r1-r3}
  bl audio_play_sample
  pop {r1-r3}

  add r4, 1

  b loop_A_1

loop_B_set_up:
  mov r1, 0
  ldr r0, =button_B_trigger_sound
  ldr r2, [r0]
  mov r4, 0
  ldr r0, =button_sound_count
  ldr r5, [r0, 8]
loop_B:
  cmp r4, r5
  IT EQ
  beq loop_B_1_set_up

  push {lr}
  bl display
  pop {lr}

  add r1, r2
  mov r0, r1
  push {r1-r3}
  bl audio_play_sample
  pop {r1-r3}

  add r4, 1

  b loop_B

loop_B_1_set_up:
  mov r1, 0
  ldr r0, =button_B_trigger_sound
  ldr r2, [r0, 4]
  mov r4, 0
  ldr r0, =button_sound_count
  ldr r5, [r0, 8]
loop_B_1:
  cmp r4, r5
  IT EQ
  beq loop_end_set_up

  push {lr}
  bl display
  pop {lr}

  add r1, r2
  mov r0, r1
  push {r1-r3}
  bl audio_play_sample
  pop {r1-r3}

  add r4, 1

  b loop_B_1

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
@ 0 (none), 1 (button A), 2 (butten B)
.word 0, 0, 1, 2
button_A_trigger_sound:
@ button A
.word 500, 800, 600
button_B_trigger_sound:
@ button B
.word 600, 500, 800
button_sound_count:
.word 0, 0, 500
button_sound_laps:
.word 0, 0, 2
.syntax unified
@ Simple button library
@ NOTE: This module depends on symbols.S
.global init_buttons
.global GPIOTE_IRQHandler

@ --------------------- Implementation --------------------
.type init_buttons, %function
@ initialize button
@ --parameters--
@ none
init_buttons:
  @ 1: Configure GPIOTE_CONFIG[0]
  @ Need to setup: mode, pin, port, polarity in the configuration register for GPIOTE[0]
  @ Section 6.9.4.8 in nRF52833 reference manual
  @ mode = 1 (event), pin = 14 and port = 0 (P0.14 = Button A), polarity = 1 (LoToHi)
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_CONFIG0
  add r0, r1
  ldr r1, =(1 | 14 << 8 | 0 << 13 | 1 << 16)
  str r1, [r0]

  @ 1: Configure GPIOTE_CONFIG[1]
  @ Need to setup: mode, pin, port, polarity in the configuration register for GPIOTE[1]
  @ Section 6.9.4.8 in nRF52833 reference manual
  @ mode = 1 (event), pin = 23 and port = 0 (P0.23 = Button B), polarity = 1 (LoToHi)
  @ ldr r0, =GPIOTE_CONFIG1
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_CONFIG1
  add r0, r1
  ldr r1, =(1 | 23 << 8 | 0 << 13 | 1 << 16)
  str r1, [r0]

  @ 2: Enable Interrupt for GPIOTE[0], GPIOTE[1] (id = 6)
  @ S6.9.4.6 in nRF52833 reference manual
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_INTENSET
  add r0, r1
  ldr r1, =0b11
  str r1, [r0]

  @ 3: enable GPIOTE (interrupt #6 = NVIC_GPIOTE_ID) in NVIC_ISER0
  @ NVIC_ISER0: B3.4.4 in ARMv7-M Reference Manual
  ldr r0, =ADR_NVIC
  ldr r1, =OFS_NVIC_ISER0
  add r0, r1
  ldr r1, =(1 << 6) @ set the 6th bit since NVIC_GPIOTE_ID = 6
  str r1, [r0]

  bx lr
.size init_buttons, .-init_buttons

.type GPIOTE_IRQHandler, %function
GPIOTE_IRQHandler:
  @ get bit from button A
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN0
  add r0, r1
  ldr r1, [r0]
  cmp r1, #1
  IT EQ
  beq GPIOTE_IRQHandler_A

  @ get bit from button B
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN1
  add r0, r1
  ldr r1, [r0]
  cmp r1, #1
  IT EQ
  beq GPIOTE_IRQHandler_B

@ execute program by button A
GPIOTE_IRQHandler_A:

  push {lr}
  bl button_A_clicked
  pop {lr}

  @ give delay
  ldr r0, =0x100
  push {lr}
  bl delay
  pop {lr}

  @ clear event for button A
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN0
  add r0, r1
  ldr r1, =0
  str r1, [r0]

  b GPIOTE_IRQHandler_end

@ execute program by button B
GPIOTE_IRQHandler_B:

  push {lr}
  bl button_B_clicked
  pop {lr}

  @ give delay
  ldr r0, =0x100
  push {lr}
  bl delay
  pop {lr}

  @ clear event for button B
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN1
  add r0, r1
  ldr r1, =0
  str r1, [r0]

  b GPIOTE_IRQHandler_end

GPIOTE_IRQHandler_end:

  @ give delay for clear event
  ldr r0, =0x100
  push {lr}
  bl delay
  pop {lr}

  bx lr
.size GPIOTE_IRQHandler, .-GPIOTE_IRQHandler

.type button_A_clicked, %function
button_A_clicked:
  push {r0-r4, lr}
  ldr r0, =current_state
  ldr r1, [r0]
  cmp r1, 0
  IT EQ
  beq button_A_clicked_state0
  cmp r1, 1
  IT EQ
  beq button_A_clicked_state1
  cmp r1, 2
  IT EQ
  beq button_A_clicked_state2
  cmp r1, 3
  IT EQ
  beq button_A_clicked_state3
  cmp r1, 4
  IT EQ
  beq button_A_clicked_state4
  cmp r1, 5
  IT EQ
  beq button_A_clicked_state5

@ button A clicked at state 0 : see pet
@ go back to menu display
button_A_clicked_state0:
  ldr r0, =current_state
  ldr r1, [r0, 8]
  str r1, [r0]
  b button_A_clicked_end

@ button A clicked at state 1 : pet status
@ go back to menu display
button_A_clicked_state1:
  ldr r0, =current_state
  ldr r1, [r0]
  ldr r2, [r0, 8]
  str r2, [r0]
  ldr r0, =current_menu_display
  str r1, [r0]
  b button_A_clicked_end

@ button A clicked at state 2 : telepathy game
@ select pet to move left
button_A_clicked_state2:
  push {lr}
  bl pet_position_left
  pop {lr}
  b button_A_clicked_end

@ button A clicked at state 3 : feed pet
@ go back to menu display
button_A_clicked_state3:
  ldr r0, =current_state
  ldr r1, [r0]
  ldr r2, [r0, 8]
  str r2, [r0]
  ldr r0, =current_menu_display
  str r1, [r0]
  b button_A_clicked_end

@ button A clicked at state 4 : sing to pet
@ go back to menu display
button_A_clicked_state4:
  ldr r0, =current_state
  ldr r1, [r0]
  ldr r2, [r0, 8]
  str r2, [r0]
  
  ldr r0, =current_menu_display
  str r1, [r0]

  ldr r0, =correct_sing
  mov r1, 0
  str r1, [r0]

  b button_A_clicked_end

@ button A clicked at state 5 : menu display
@ move to selected option
button_A_clicked_state5:
  ldr r0, =current_menu_display
  ldr r1, [r0]
  ldr r2, [r0, 8]
  cmp r1, r2
  IT EQ
  moveq r1, 0
  ldr r0, =current_state
  str r1, [r0]
  ldr r0, =current_menu_display
  ldr r1, [r0, 4]
  str r1, [r0]
  b button_A_clicked_end

button_A_clicked_end:
  pop {r0-r4, lr}
  bx lr
.size button_A_clicked, .-button_A_clicked

.type button_B_clicked, %function
button_B_clicked:
  push {r0-r4, lr}
  ldr r0, =current_state
  ldr r1, [r0]
  cmp r1, 2
  IT EQ
  beq button_B_clicked_state2
  cmp r1, 3
  IT EQ
  beq button_B_clicked_state3
  cmp r1, 5
  IT EQ
  beq button_B_clicked_state5
  b button_B_clicked_end

@ button B clicked at state 2 : telepathy game
@ select pet to move right
button_B_clicked_state2:
  push {lr}
  bl pet_position_right
  pop {lr}
  b button_B_clicked_end

@ button B clicked at state 3 : feed pet
@ feed my pet, increase HP by 1
button_B_clicked_state3:
  bl feed_pet
  b button_B_clicked_end

@ button B clicked at state 5 : menu display
@ scroll to the next option
button_B_clicked_state5:
  bl display_scroll
  b button_B_clicked_end

button_B_clicked_end:
  pop {r0-r4, lr}
  bx lr
.size button_B_clicked, .-button_B_clicked
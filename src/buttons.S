.syntax unified
@ Simple button library
@ NOTE: This module depends on symbols.S
.global init_buttons
.global GPIOTE_IRQHandler

@ --------------------- Implementation --------------------
.type init_buttons, %function
@ telepathy game
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

GPIOTE_IRQHandler_A:

  mov r0, 2
  mov r1, 0
  push {lr}
  bl led_blink_50ms
  pop {lr}

  @ clear event for button A
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN0
  add r0, r1
  ldr r1, =0
  str r1, [r0]

  b GPIOTE_IRQHandler_end

GPIOTE_IRQHandler_B:

  mov r0, 2
  mov r1, 4
  push {lr}
  bl led_blink_50ms
  pop {lr}

  @ clear event for button B
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN1
  add r0, r1
  ldr r1, =0
  str r1, [r0]

  b GPIOTE_IRQHandler_end

GPIOTE_IRQHandler_end:

  ldr r0, =0x10
  push {lr}
  bl delay
  pop {lr}

  bx lr
.size GPIOTE_IRQHandler, .-GPIOTE_IRQHandler
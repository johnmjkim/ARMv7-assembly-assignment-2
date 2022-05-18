.syntax unified
@ Simple microphone library
@ NOTE: This module depends on symbols.S
.global init_microphone
.global PDM_IRQHandler

@ --------------------- Implementation --------------------
.type init_microphone, %function
@ initialize microphone
@ --parameters--
@ none
init_microphone:
@   @ 1: Configure GPIOTE_CONFIG[0]
@   @ Need to setup: mode, pin, port, polarity in the configuration register for GPIOTE[0]
@   @ Section 6.9.4.8 in nRF52833 reference manual
@   @ mode = 1 (event), pin = 14 and port = 0 (P0.14 = Button A), polarity = 1 (LoToHi)
@   ldr r0, =ADR_GPIOTE
@   ldr r1, =OFS_GPIOTE_CONFIG0
@   add r0, r1
@   ldr r1, =(1 | 14 << 8 | 0 << 13 | 1 << 16)
@   str r1, [r0]

@   @ 1: Configure GPIOTE_CONFIG[1]
@   @ Need to setup: mode, pin, port, polarity in the configuration register for GPIOTE[1]
@   @ Section 6.9.4.8 in nRF52833 reference manual
@   @ mode = 1 (event), pin = 23 and port = 0 (P0.23 = Button B), polarity = 1 (LoToHi)
@   @ ldr r0, =GPIOTE_CONFIG1
@   ldr r0, =ADR_GPIOTE
@   ldr r1, =OFS_GPIOTE_CONFIG1
@   add r0, r1
@   ldr r1, =(1 | 23 << 8 | 0 << 13 | 1 << 16)
@   str r1, [r0]

@   @ 2: Enable Interrupt for GPIOTE[0], GPIOTE[1] (id = 6)
@   @ S6.9.4.6 in nRF52833 reference manual
@   ldr r0, =ADR_GPIOTE
@   ldr r1, =OFS_GPIOTE_INTENSET
@   add r0, r1
@   ldr r1, =0b11
@   str r1, [r0]

@   @ 3: enable GPIOTE (interrupt #6 = NVIC_GPIOTE_ID) in NVIC_ISER0
@   @ NVIC_ISER0: B3.4.4 in ARMv7-M Reference Manual
@   ldr r0, =ADR_NVIC
@   ldr r1, =OFS_NVIC_ISER0
@   add r0, r1
@   ldr r1, =(1 << 6) @ set the 6th bit since NVIC_GPIOTE_ID = 6
@   str r1, [r0]

  bx lr
.size init_microphone, .-init_microphone

.type PDM_IRQHandler, %function
PDM_IRQHandler:
    

  b PDM_IRQHandler_end

PDM_IRQHandler_end:

  bx lr
.size PDM_IRQHandler, .-PDM_IRQHandler
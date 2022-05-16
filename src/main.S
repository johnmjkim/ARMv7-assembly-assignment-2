.syntax unified
.global main

@ SysTick vars
.set RVR_50MS,     3200000
.set RVR_1MS,      64000
.set RVR_0_5MS,    32000
@ Timer vars
.set TIMER0_1MS,   1000
.set TIMER0_0_5MS, 500

.type main, %function
main:
  nop
  @ GPIO 0: P0.02
  @ GPIO 1: P0.03
  @ GPIO 2: P0.04
  @ wire from 0 -> 2

  @@@@ Configure LEDS for some visual output
  bl init_leds

  @@@@ Configure interrupt priorities
  @ GPIO > Systick > Timer
  @@ GPIOTE to priority 0
  ldr r0, =ADR_NVIC
  ldr r1, =OFS_NVIC_IPR1
  add r0, r1
  mov r1, 0
  mov r2, 21
  mov r3, 3
  bl copy_bits

  @@ Systick to priority 1
  ldr r0, =ADR_SCB_SHPR3
  mov r1, 1
  mov r2, 29
  mov r3, 3
  bl copy_bits

  @@@@ Set GPIO Output Defaults
  @@ Set P0.02 to output mode
  ldr r0, =ADR_P0
  ldr r1, =OFS_GPIO_DIR
  mov r2, 2
  bl set_bit
  @ Set P0.02 to default high
  ldr r0, =ADR_P0
  ldr r1, =OFS_GPIO_OUT
  mov r2, 2
  bl set_bit

  @@@@ Set GPIO Input Defaults
  @ Enable GPIOTE Falling Edge Interrupt
  mov r0, 4 @ Pin 4
  mov r1, 0 @ Port 0
  mov r2, 2 @ HiToLo
  bl enable_GPIOTE

  @@@@ Set Systick Defaults
  @ Set reload value for 1ms interrupt
  @ ldr r0, =RVR_1MS
  ldr r0, =RVR_50MS
  bl set_SysTick
  @ Start SysTick interrupt
  @ bl start_SysTick

  ldr r0, =game_round
  mov r1, 3
  str r1, [r0]

  ldr r0, =correct_motion
  mov r1, 2
  str r1, [r0]

  b loop
.size main, .-main

loop:
  nop
  push {lr}
  bl display_telepathy_game
  pop {lr}
  b loop


@ SysTick Handler
.type SysTick_Handler, %function
SysTick_Handler:
  push {lr}
  nop
  pop {lr}
  bx lr
.size SysTick_Handler, .-SysTick_Handler

@ This interrupt exists to wakeup the receiver, it can also be used to finalize the 
@ received message if you wish.
.type GPIOTE_IRQHandler, %function
GPIOTE_IRQHandler:
  push {lr}
  @ Write your wakeup etc. code here \/\/\/


  @ Clear GPIOTE event
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN0
  mov r2, 0
  bl clear_bit
  pop {lr}
  bx lr
.size GPIOTE_IRQHandler, .-GPIOTE_IRQHandler

@@@@ Helper functions @@@@
.type enable_GPIOTE, %function
@ Enables the GPIOTE (config 0) interrupt and clears any pending bits for it
@ --parameters--
@ r0: pin
@ r1: port
@ r2: interrupt type (0: None, 1: LoToHi, 2: HiToLo, 3: Toggle)
enable_GPIOTE:
  push {lr}
  push {r0 - r2}
  @ Clear events incase they were pending
  @ Clear GPIOTE event
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_EVENTS_IN0
  mov r2, 0
  bl clear_bit
  @ Clear NVIC
  ldr r0, =ADR_NVIC
  ldr r1, =OFS_NVIC_ICPR0
  mov r2, 6
  bl set_bit
  @ Set pull down resistor
  ldr r0, =ADR_P0
  ldr r1, =OFS_GPIO_PIN_CONF4
  add r0, r1
  mov r1, 1
  mov r2, 2
  mov r3, 2
  bl copy_bits
  @ Enable the interrupt
  pop {r0 - r2}
  lsl r0, 8
  lsl r1, 13
  lsl r2, 16
  orr r2, r0
  orr r2, r1
  orr r2, 1 @ Enable
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_CONFIG0
  str r2, [r0, r1]
  @ Enable GPIOTE Interrupt
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_INTENSET
  mov r2, 0b1
  str r2, [r0, r1]
  @ Enable GPIOTE (interrupt #6 = NVIC_GPIOTE_ID) in NVIC_ISER0
  @ NVIC_ISER0: B3.4.4 in ARMv7-M Reference Manual
  ldr r0, =ADR_NVIC
  ldr r1, =OFS_NVIC_ISER0
  mov r2, 6
  bl set_bit
  pop {lr}
  bx lr
.size enable_GPIOTE, .-enable_GPIOTE


.type disable_GPIOTE, %function
@ Disables the GPIOTE interrupt.
@ --parameters--
@ none
disable_GPIOTE:
  @ Disable this interrupt
  ldr r0, =ADR_GPIOTE
  ldr r1, =OFS_GPIOTE_INTENCLR
  mov r2, 0b1
  str r2, [r0, r1] @ write to disable
  bx lr
.size disable_GPIOTE, .-disable_GPIOTE


.type start_SysTick, %function
@ Starts SysTick with interrupts enabled.
@ --parameters--
@ none
start_SysTick:
  push {lr}
  @ Enable systick
  ldr r0, =ADR_SYST_CSR
  mov r1, 0b111
  mov r2, 0
  mov r3, 3
  bl copy_bits
  pop {lr}
  bx lr
.size start_SysTick, .-start_SysTick


.type stop_SysTick, %function
@ Stops SysTick.
@ --parameters--
@ none
stop_SysTick:
  push {lr}
  @ Disable systick
  ldr r0, =ADR_SYST_CSR
  mov r1, 0b100
  mov r2, 0
  mov r3, 3
  bl copy_bits
  pop {lr}
  bx lr
.size stop_SysTick, .-stop_SysTick


.type set_SysTick, %function
@ Sets the reload value for SysTick.
@ --parameters--
@ r0: SysTick reload value
set_SysTick:
  ldr r1, =ADR_SYST_RVR
  str r0, [r1]
  bx lr
.size set_SysTick, .-set_SysTick


.type reset_SysTick, %function
@ Resets the current count value for SysTick to 0.
@ --parameters--
@ none
reset_SysTick:
  @ Reset systick (any writes to CVR cause it to go to 0)
  ldr r0, =ADR_SYST_CVR
  mov r1, 1
  str r1, [r0]
  bx lr
.size reset_SysTick, .-reset_SysTick


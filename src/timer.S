.syntax unified
@ Simple timer library
@ NOTE: This module depends on symbols.S
.global init_buttons
.global SysTick_Handler, init_systick

.type init_systick, %function
init_systick:
  @ set SYST_CSR_ENABLE - bit 0
  @ set SYST_CSR_TICKINT - bit 1
  @ set SYST_CSR_CLKSOURCE - bit 2 (default)
  ldr r0, =ADR_SYST_CSR
  ldr r1, =(1 << 0 | 1 << 1)
  str r1, [r0]

  @ SysTick to interrupt at a constant rate
  @ count down from FIFTY_MILLISECONDS (3.2M cycles) repeating 5 times
  ldr r0, =ADR_SYST_RVR
  ldr r1, =RVR_50MS
  str r1, [r0]

  @ @ set priority of SYSTICK
  @ @ SHPR3: B3.2.12 in ARMv7-M Reference Manual
  @ ldr r0, =ADR_SCB_SHPR3
  @ ldr r1, =(1 << 30) @ set the 29-31th bit priority 2 (lower priority)
  @ str r1, [r0]

  bx lr
.size init_systick, .-init_systick

.type SysTick_Handler, %function
@ Interrupts and toggle led
@ --parameters--
@ none
@ --return--
@ none
SysTick_Handler:
  nop
  push {r0-r3, lr}
  ldr r0, =systic_repeat
  ldr r1, [r0]
  ldr r2, [r0, 8]
  cmp r1, r2
  IT LE
  blle SysTick_Handler_pass
SysTick_Handler_do:
  ldr r0, =pet_status_update_period
  ldr r1, [r0]
  add r2, r1, 1
  str r2, [r0]
  ldr r2, [r0, 8]

  push {lr}
  cmp r1, r2
  IT EQ
  bleq pet_status_update
  pop {lr}

  ldr r0, =target_sound_amplitude_update_period
  ldr r1, [r0]
  add r2, r1, 1
  str r2, [r0]
  ldr r2, [r0, 8]

  push {lr}
  cmp r1, r2
  IT EQ
  bleq target_sound_amplitude_update
  pop {lr} 

  ldr r0, =systic_repeat
  ldr r1, [r0, 4]
  str r1, [r0]
  b SysTick_Handler_end
SysTick_Handler_pass:
  add r1, r1, 1
  ldr r0, =systic_repeat
  str r1, [r0]
  b SysTick_Handler_end
SysTick_Handler_end:
  pop {r0-r3, lr}
  bx lr
.size SysTick_Handler, .-SysTick_Handler

.type pet_status_update, %function
pet_status_update:
  push {lr}
  bl change_pet_status
  pop {lr}

  ldr r0, =pet_status_update_period
  ldr r1, [r0, 4]
  str r1, [r0]

  bx lr
.size pet_status_update, .-pet_status_update

.type target_sound_amplitude_update, %function
target_sound_amplitude_update:
  push {lr}
  bl change_target_sound_amplitude
  pop {lr}

  push {lr}
  bl evaluate_sound_amplitude
  pop {lr}

  push {r0-r2}
  ldr r0, =correct_sing
  ldr r1, [r0]
  ldr r2, [r0, 8]
  cmp r1, r2
  IT EQ
  beq target_sound_amplitude_update_exit
  b target_sound_amplitude_update_end
target_sound_amplitude_update_exit:

  ldr r0, =current_state
  ldr r1, [r0]
  ldr r2, [r0, 8]
  str r2, [r0]
  ldr r0, =current_menu_display
  str r1, [r0]

  ldr r0, =correct_sing
  mov r1, 0
  str r1, [r0]

target_sound_amplitude_update_end:
  ldr r0, =target_sound_amplitude_update_period
  ldr r1, [r0, 4]
  str r1, [r0]
  pop {r0-r2}

  bx lr
.size target_sound_amplitude_update, .-target_sound_amplitude_update

.data
@ 50 ms per 1 cycle
@ 1 second per 20 cycles
@ 5 seconds per 100 cycles
@ 10 seconds per 200 cycles
@ 30 seconds per 600 cycles
systic_repeat:
.word 0, 0, 20
@ count in seconds
pet_status_update_period:
.word 0, 0, 5
target_sound_amplitude_update_period:
.word 0, 0, 1

@ SysTick vars
.set RVR_50MS,     3200000
.set RVR_10MS,     640000
.set RVR_1MS,      64000
.set RVR_0_5MS,    32000
.syntax unified
@ Simple microphone library
@ NOTE: This module depends on symbols.S
.global init_microphone, record_my_amplitude, start_PDM, stop_PDM
.global PDM_IRQHandler

@ --------------------- Implementation --------------------
.type init_microphone, %function
@ initialize microphone
@ --parameters--
@ none
init_microphone:
  @ 1: Enable PDM module (id = 29)
  @ S6.14.7.0 in nRF52833 reference manual
  ldr r0, =ADR_PDM
  ldr r1, =OFS_PDM_ENABLE
  add r0, r1
  ldr r1, =0b1
  str r1, [r0]

  @ 2: Enable Interrupt for PDM module (id = 29)
  @ S6.14.7.7 in nRF52833 reference manual
  ldr r0, =ADR_PDM
  ldr r1, =OFS_PDM_INTEN
  add r0, r1
  ldr r1, =0b1
  str r1, [r0]

  @ 3: enable PDM (interrupt #29 = NVIC_PDM_ID) in NVIC_ISER0
  @ NVIC_ISER0: B3.4.4 in ARMv7-M Reference Manual
  ldr r0, =ADR_NVIC
  ldr r1, =OFS_NVIC_ISER0
  add r0, r1
  ldr r1, =(1 << 29) @ set the 29th bit since NVIC_PDM_ID = 29
  str r1, [r0]

  bx lr
.size init_microphone, .-init_microphone

.type PDM_IRQHandler, %function
PDM_IRQHandler:
  mov r0, 3
  push {lr}
  bl record_my_amplitude
  pop {lr}
  b PDM_IRQHandler_end

PDM_IRQHandler_end:
  push {lr}
  bl stop_PDM
  pop {lr}

  bx lr
.size PDM_IRQHandler, .-PDM_IRQHandler

.type record_my_amplitude, %function
@ --parameters--
@ r0 recorded amplited
@ --result--
@ none
record_my_amplitude:
  push {r1}
  ldr r1, =my_sound_amplitude
  str r0, [r1]
  pop {r1}

  bx lr
.size record_my_amplitude, .-record_my_amplitude

.type start_PDM, %function
@ --parameters--
@ none
@ --result--
@ none
start_PDM:
  push {r0-r1}
  ldr r0, =ADR_PDM
  ldr r1, =OFS_PDM_TASKS_START
  add r0, r1
  ldr r1, =0b1
  str r1, [r0]
  pop {r0-r1}

  bx lr
.size start_PDM, .-start_PDM

.type stop_PDM, %function
@ --parameters--
@ none
@ --result--
@ none
stop_PDM:
  push {r0-r1}
  ldr r0, =ADR_PDM
  ldr r1, =OFS_PDM_TASKS_STOP
  add r0, r1
  ldr r1, =0b1
  str r1, [r0]
  pop {r0-r1}

  bx lr
.size stop_PDM, .-stop_PDM

.global ADR_PDM @ 0x4001D000
.global PDM_ID  @ 29
.global OFS_PDM_TASKS_START @ 0x000
.global OFS_PDM_TASKS_STOP @ 0x004
.global OFS_PDM_EVENTS_STARTED @ 0x100
.global OFS_PDM_EVENTS_STOPPED @ 0x104


@ ---------- PDM Tasks and Events ---------- @

@ PDM Base Address
.set ADR_PDM, 0x4001D000
@ ID of PDM in NVIC
.set PDM_ID, 29
@ PDM Offsets
.set OFS_PDM_TASKS_START, 0x000
.set OFS_PDM_TASKS_STOP, 0x004
.set OFS_PDM_EVENTS_STARTED, 0x100
.set OFS_PDM_EVENTS_STOPPED, 0x104
.set OFS_PDM_EVENTS_END, 0x108
.set OFS_PDM_INTEN, 0x300
.set OFS_PDM_INTENSET, 0x304
.set OFS_PDM_INTENCLR, 0x308
.set OFS_PDM_ENABLE, 0x500
.set OFS_PDM_PDMCLKCTRL, 0x504
.set OFS_PDM_MODE, 0x508
.set OFS_PDM_GAINL, 0x518
.set OFS_PDM_GAINR, 0x51C
.set OFS_PDM_RATIO, 0x520
.set OFS_PDM_PSEL_CLK, 0x540
.set OFS_PDM_PSEL_DIN, 0x560
.set OFS_PDM_SAMPLE_PTR, 0x560
.set OFS_PDM_SAMPLE_MAXCNT, 0x564
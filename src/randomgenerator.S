.syntax unified
@ Simple random number generator library
.global init_random, generate_random

@ --------------------- Implementation --------------------
.type init_random, %function
@ initialize random
@ --parameters--
@ none
init_random:
  @ 1: Enable RNG module (id = 13)
  @ S6.19.3.7 in nRF52833 reference manual
  ldr r0, =ADR_RNG
  ldr r1, =OFS_RNG_CONFIG
  add r0, r1
  ldr r1, =0b1
  str r1, [r0]

  bx lr
.size init_random, .-init_random

.type generate_random, %function
@ --parameters--
@ r0 upper bound (inclusive)
@ --result--
@ r0 random number
generate_random:
  push {r0-r1}
  @ Trigger random number task
  ldr r0, =ADR_RNG
  ldr r1, =OFS_RNG_TASKS_START
  add r0, r1
  ldr r1, =0b1
  str r1, [r0]

  @ Store random number
  ldr r0, =ADR_RNG
  ldr r1, =OFS_RNG_VALUE
  add r0, r1
  ldr r1, [r0]
  ldr r0, =random_number
  str r1, [r0]

  pop {r0-r1}

  @ Calculate remainder
  ldr r2, =random_number
  ldr r1, [r2]
  add r2, r0, #1
  udiv r3, r1, r2
  mul r3, r3, r2
  sub r0, r1, r3

  bx lr
.size generate_random, .-generate_random

.global ADR_RNG               @ 0x4000D000
.global RNG_ID                @ 13
.global OFS_RNG_TASKS_START   @ 0x000
.global OFS_RNG_TASKS_STOP    @ 0x004
.global OFS_RNG_EVENTS_VALRDY @ 0x100
.global OFS_RNG_SHORTS        @ 0x200
.global OFS_RNG_INTENSET      @ 0x304
.global OFS_RNG_INTENCLR      @ 0x308
.global OFS_RNG_CONFIG        @ 0x504
.global OFS_RNG_VALUE             @ 0x508

@ ---------- RNG Tasks and Events ---------- @

@ RNG Base Address
.set ADR_RNG, 0x4000D000
@ ID of RNG in NVIC
.set RNG_ID, 13
@ RNG Offsets
.set OFS_RNG_TASKS_START, 0x000
.set OFS_RNG_TASKS_STOP, 0x004
.set OFS_RNG_EVENTS_VALRDY, 0x100
.set OFS_RNG_SHORTS, 0x200
.set OFS_RNG_INTENSET, 0x304
.set OFS_RNG_INTENCLR, 0x308
.set OFS_RNG_CONFIG, 0x504
.set OFS_RNG_VALUE, 0x508

.global random_number
.data
random_number:
.word 0
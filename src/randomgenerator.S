.syntax unified
@ Simple random number generator library
.global generate_random

.type generate_random, %function
@ --parameters--
@ r0 upper bound (inclusive)
@ --result--
@ r0 random number
generate_random:
  push {r1-r3}
  ldr r1, =ADR_SYST_RVR
  ldr r1, [r1]
  ldr r2, =ADR_SYST_CVR
  ldr r2, [r2]
  sub r1, r2
  mov r2, #17
  mul r1, r2, r1
  mov r2, #13
  add r1, r2
  add r2, r0, #1
  udiv r3, r1, r2
  mul r3, r3, r2
  sub r0, r1, r3
  pop {r1-r3}
  bx lr
.size generate_random, .-generate_random
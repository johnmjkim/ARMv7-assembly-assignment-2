.syntax unified
@ Simple random number generator library
.global generate_random

.type generate_random, %function
@ --parameters--
@ r0 upper bound
@ --result--
@ r0 random number
generate_random:

  bx lr
.size generate_random, .-generate_random
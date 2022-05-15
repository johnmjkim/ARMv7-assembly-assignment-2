.syntax unified
@ Simple petstatus library
@ NOTE: This module depends on led.S
.global display_pet_status

@ --------------------- Implementation --------------------
.type display_pet_status, %function
@ pet status
@ --parameters--
@ none
display_pet_status:
  push {r0, lr}
@   mov r0, 1
@   bl display_menu
  pop {r0, lr}
  bx lr
.size display_pet_status, .-display_pet_status

@ @ --------------------- Implementation --------------------
@ .type display_menu, %function
@ @ r0 : menu 
@ @ 0 (see pet), 
@ @ 1 (pet status), 
@ @ 2 (telepathy game), 
@ @ 3 (feed pet), 
@ @ 4 (exit option)
@ @ --parameters--
@ @ none
@ display_menu:
@   push {r1-r5}
@   ldr r2, =pet_status_background
@   mov r3, 0
@   mov r5, 4
@ display_menu_type_loop:
@   ldr r4, [r2]
@   add r2, r5
@   cmp r3, r0
@   beq display_menu_loop_setup
@   mla r2, r4, r5, r2
@   add r3, 1
@   b display_menu_type_loop
@ display_menu_loop_setup:
@   mov r3, 0
@ display_menu_loop:
@   cmp r3, r4
@   beq display_menu_end

@   ldr r0, [r2, r3, lsl 2]
@   add r3, 1
@   ldr r1, [r2, r3, lsl 2]
@   add r3, 1

@   push {r2, r3, lr}
@   bl led_blink
@   pop {r2, r3, lr}

@   b display_menu_loop
@ display_menu_end:
@   pop {r1-r5}
@   bx lr
@ .size display_menu, .-display_menu

.data
pet_status_background:
@ pet status background
.word 10, 1, 2, 2, 1, 2, 2, 2, 3, 3, 2


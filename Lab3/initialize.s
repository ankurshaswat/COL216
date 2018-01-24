@initialize:
.equ SWI_Exit, 0x11
.text

mov r2,#2
  ldr r0,=score
  str r2,[r0,#0]
  str r2,[r0,#4]
  ldr r0,=active_player
  mov r0,#0

  ldr r2,=grid @ r2 is grid throughout now

  mov r0,#0 @ i=0

  @ 8x+y is used to access registers (store array linearly)

  outer_loop_start:

  mov r1,#0 @ j=0

  inner_loop_start:

  @mul r3,r0,#8         @ r3 = 8 * i
  add r3,r1,r0,LSL #3  @ r3 = r1 +r3 = 8*i + j
  @mul r3,r3,#4
  mov r12,#-1
str r12,[r2,r3,LSL #2]  @storing -1 at all positions


  add r1,r1,#1
  cmp r1,#8
  bne inner_loop_start

  add r0,r0,#1
  cmp r0,#8
  bne outer_loop_start

  ret:
ldr r3,=grid
mov r0,#0   @r0 is x
mov r1,#0   @r1 is y
add r5,r1,r0,LSL #3
ldr r4,[r3,r5]
    swi SWI_Exit
@mov pc,lr

.data
active_player: .word 0
score: .word 0, 0
success: .word 0
grid: .space 300
player_input: .word 0,0
valid: .word 0
.end

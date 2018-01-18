initialize:

  ldr r0,=score
  str #2,[r0,#0]
  str #2,[r0,#4]
  ldr r0,=active_player
  mv r0,#0

  ldr r2,=grid @ r2 is grid throughout now

  mv r0,#0 @ i=0

  @ 8x+y is used to access registers (store array linearly)

  outer_loop_start:

  mv r1,#0 @ j=0

  inner_loop_start:

  mul r3,r0,#8  @ r3 = 8 * i
  add r3,r1,r3  @ r3 = r1 +r3 = 8*i + j
  mul r3,r3,#4
  str #-1,[r2,r3]  @storing -1 at all positions


  add r1,r1,#1
  cmp r1,#8
  bne inner_loop_start

  add r0,r0,#1
  cmp r0,#8
  bne outer_loop_start

  ret:
        mov pc,lr

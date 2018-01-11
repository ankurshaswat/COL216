sum_square:

	AA:	.space 400

	ldr r12,=AA @@ AA is in r12 

	@r1 is *s
	str r1,[r12,#0] @AA[0] has r1 address
	@r2 is *x
	str r2,[r12,#4] @AA[1] has r2 address

	@ldr r2,[r2,#0] @x[0] is in r2

	@r3 is dd
	dd: .word 0,0,0,0
	ldr r3,=dd

	str r3,[r12,#8]

	mov r12,r2   @ x[0] is now in r12
	ldr r2,=zero @ zero is in r2

	
	ldr r1,[r12,#0]
	ldr r2,[r12,#4]
	bl copy_BCD


	ldr r1,[r12,#4]

	mov r0,#0   @ i is r0

			loop_start:

			ldr r1,=dd




			add r0,r0,#1
			cmp r0,#4
			blt loop_start


	ret:
	mov pc,lr
sum_square:

	AA:	.space 400

	ldr r12,=AA @@ AA is in r12 

	@r0 is *s
	str r0,[r12,#0] @AA[0] has r0 address
	@r1 is *x
	str r1,[r12,#4] @AA[1] has r1 address

	@r2 is dd
	dd: .word 0,0,0,0
	ldr r2,=dd
	str r2,[r12,#8]


	ldr r0,[r12,#0]
	ldr r1,=zero

	bl copy_BCD

	@ldr r1,[r12,#4]

	mov r3,#0   @ i is r3

			loop_start:

			ldr r0,=dd
			ldr r1,[r12,#4]
			ldr r1,[r1,r3]
			blt square_digit

			ldr r0,[r12,#0]
			mov r1,r0
			ldr r2,=dd
			blt add_BCD

			add r3,r3,#4
			cmp r3,#16
			blt loop_start



	ret:
	mov pc,lr
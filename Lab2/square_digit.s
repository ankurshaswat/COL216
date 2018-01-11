square_digit:	

	@r0 is *dd
	@r1 is d value

	mul r2,r1,r1  @ r2 has d square
	ldr r1, = zero @loading array zero into r3
	bl copy_BCD  @passing r0 and r1 i.e. *dd and *zero

	str r2,[r0]

	ldr r2,[r0]
	ldr r12,[r0,#4]
	@ r2 has value of dd[0]  and r12 has value of dd[1]
		loop_start:



	
		cmp r2,#9
		ble ret


		sub r2,r0,#10
		str r2,[r0]
		add r12,r12,#1
		str r12,[r0,#4]

		b loop_start

	ret:
	mov pc,lr
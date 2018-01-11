add_BCD:


	AA:	.space 400

	ldr r12,=AA @@ AA is in r12 

	str r0,[r12,#0] @ *x is stored here
	str r1,[r12,#4] @ *y is stored here
	str r2,[r12,#8] @ *z is stored here

	mov r3,#0   @ c is r3

	mov r0,#0  @ i is r0

	loop:	

		ldr r1,=AA
		mov r12,#0
		ldr r2,[r1,#8]
		ldr r2,[r2,r0]
		add r12,r12,r2
		ldr r2,[r1,#4]
		ldr r2,[r2,r0]

		add r12,r12,r2
		add r12,r12,r3

		ldr r1,[r1,#0]
		str r12,[r1,r0]

		cmp r12,#9
		ble skip_if

			sub r12,r12,#10
			str r12,[r1,r0]
			mov r3,#1

		skip_if:


		add r0,r0,#4
		cmp r0,#16
		blt loop

	ret:
	mov pc,lr





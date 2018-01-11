add_BCD:

@r11 is also used in this function

	ldr r0,[r0,#0]  @ *x is r0
	ldr r1,[r1,#0]  @ *y is r1
	ldr r2,[r2,#0]  @ *z is r2

	mov r12,#0   @ c is r12
	mov r11,#0   @ i is r11

		loop_start:

		add r3,r2,r12
		add r0,r3,r1
		mov r12,#0

		cmp r0,#9
		ble skip_if

			sub r0,r0,#10
			mov r12,#1

		skip_if:


		ldr r0,[r0,#4]  @ *x is r0
		ldr r1,[r1,#4]  @ *y is r1
		ldr r2,[r2,#4]  @ *z is r2

		add r11,r11,#1
		cmp r11,#4
		blt loop_start

	ret:
	mov pc,lr
	.equ SWI_Exit, 0x11
	.text

	mov r9,#100 @ is value of n

	@ldr r3, =AA 
	@mov r7,#57
	@str r7, [r3]
	@add r3, r3, #4
	@mov r7,#54
	@str r7, [r3]
	@add r3, r3, #4
	@mov r7,#26	
	@str r7, [r3]
	@add r3, r3, #4


	mov r1, #100
	mov r2, #400
	ldr r3, =AA 
	Lab1:
	str r2, [r3]
	add r3, r3, #4
	sub r2, r2, #4
	sub r1, r1, #1
	cmp r1, #0
	bne Lab1

	ldr r5, =AA  @currently v[0] is r5

	@i is r8
	mov r7,#4

	mov r0,r9  @ n
	mov r8,#0

	backtrack2:
	ldr r5, =AA  @currently v[0] is r5
	@temp is r1
	@temp2 is r2
	@temp3 is r3
	@j is r4
	@j inverse is r6
	sub r4,r9,#1  @ n-1
	mov r6,#0

	backtrack: 
	
	mul 	r1,r6,r7
	add 	r5,r1,r5
	ldr 	r2,[r5,#0]
	ldr 	r3,[r5,#4]
	cmp 	r2,r3
	blt 	L
	str 	r3,[r5,#0]
	str 	r2,[r5,#4]

	L: 
	
	add r6,r6,#1
	sub r4,r4,#1
	cmp r4,#0
	bne backtrack
	

	add r8,r8,#1
	sub r0,r0,#1
	cmp r0,#0
	bne backtrack2

	@SWI       [r5]
	@SWI       [r5,#4]
	@SWI       [r5,#396]
	swi SWI_Exit
	.data

AA:	.space 400
	.end

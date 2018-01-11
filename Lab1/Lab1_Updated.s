
	.equ SWI_Exit, 0x11
	.text

	mov r9,#7 @ is value of n

    ldr r10,= P

	@i is r8
	mov r7,#4

    mov r0,#0  @ n
	@mov r8,#0

	backtrack2:
	ldr r10, = P
	@temp is r1
	@temp2 is r2
	@temp3 is r3
	@j is r4
	@j inverse is r6
	@sub r4,#0  @ n
	mov r6,#0

	backtrack: 
	
	mul 	r1,r6,r7
	add 	r5,r1,r10
	ldr 	r2,[r5,#0]
	ldr 	r3,[r5,#4]
	cmp 	r2,r3
	blt 	L
	str 	r3,[r5,#0]
	str 	r2,[r5,#4]

	L: 
	
	add r6,r6,#1
	@add r4,r4,#1
	cmp r6,#6
	bne backtrack
	

	@add r8,r8,#1
	add r0,r0,#1
    cmp r0,r9
	bne backtrack2

	swi SWI_Exit
	.data
P: .word 4,10,6,5,19,3,67



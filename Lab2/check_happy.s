check_happy:
	mov r0,#1
	cmp r1,#7
	beq ret
	cmp r1,#1
 	beq ret
	mov r0,#0
ret: mov pc lr


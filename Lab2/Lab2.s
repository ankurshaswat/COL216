	.equ SWI_Exit, 0x11
	.text




ldr r0,=x
ldr r1,=one
bl copy_BCD

@r10 is i
@r9 is j
mov r10,#0
mov r9,#0


	for_loop_outer:



		ldr r0,=y
		ldr r1,=x
		bl copy_BCD

		while:

			ldr r0,=y
			bl check_gt_1
			cmp r0,#1
			bne while_end

			ldr r0,=s;
			ldr r1,=y;
			bl sum_square

			ldr r0,=y
			ldr r1,=s
			bl copy_BCD

			b while
		while_end:


		ldr r0,=y
		ldr r0,[r0,#0]
		bl check_happy
		cmp r0,#1
		bne skip_if_main

		add r9,r9,#1
		ldr r7,=x
		ldr r8,[r7,#0]
		ldr r8,[r7,#4]
		ldr r8,[r7,#8]
		ldr r8,[r7,#12]
		@PRINT

		skip_if_main:

		ldr r0,=x
		ldr r1,=x
		ldr r2,=one
		
		bl add_BCD

	add r10,r10,#1
	ldr r5,=9999
	cmp r10,r5
	blt for_loop_outer




check_gt_1:
@ r0 is *x
	mov r1,r0
	mov r0,#1
	ldr r2,[r1,#4]
	cmp r2,#0
	bgt ret
	ldr r2,[r1,#8]
	cmp r2,#0
	bgt ret
	ldr r2,[r1,#12]
	cmp r2,#0
	bgt ret
	mov r0,#0
ret: mov pc,lr



check_happy:
@ r0 is passed as x
	mov r1,r0
	mov r0,#1
	cmp r1,#7
	beq ret3
	cmp r1,#1
 	beq ret3
	mov r0,#0
ret3: mov pc,lr




@r0 is x[0]
@r1 is s[0]
copy_BCD:
	ldr r3,[r1,#0]		@r3 is x0 
	str r3,[r0,#0] 
	ldr r3,[r1,#4]		@r3 is x1
	str r3,[r0,#4]
	ldr r3,[r1,#8]		@r3 is x2 
	str r3,[r0,#8]
	ldr r3,[r1,#12]	@r3 is x3 
	str r3,[r0,#12]
 mov pc,lr



add_BCD:



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

	
	mov pc,lr






	sum_square:


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

			loop_start2:

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
			blt loop_start2



	
	mov pc,lr






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
		ble ret2


		sub r2,r0,#10
		str r2,[r0]
		add r12,r12,#1
		str r12,[r0,#4]

		b loop_start

	ret2:
	mov pc,lr




	swi SWI_Exit
	.data
x: .word 0,0,0,0
s: .word 0,0,0,0
y: .word 0,0,0,0
one: .word 1,0,0,0
zero: .word 0,0,0,0
AA: .space 400

	.end



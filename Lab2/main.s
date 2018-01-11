x: .word 0,0,0,0
s: .word 0,0,0,0
y: .word 0,0,0,0
one: .word 1,0,0,0

AA11: .space 400

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
	cmp r10,#9999
	blt for_loop_outer
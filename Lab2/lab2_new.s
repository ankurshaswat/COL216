	.equ SWI_Exit, 0x11
	.text


ldr r0,=OutFileName @ set Name for output file
mov r1,#1 @ mode is output
swi 0x66 @ open file for output
@bcs OutFileError @ if error ?
ldr r1,=OutFileHandle @ load o2utput file handle
str r0,[r1] @ save the file handle

ldr r0,=x
ldr r1,=one

mov r2,#1
strb r2,[r1]

bl copy_BCD

@r10 is i
@r9 is j
mov r10,#1
mov r9,#0


	for_loop_outer:

		@ldr r0,=x
		@ldrb r1,[r0]
		@ldrb r2,[r0,#1]
		@ldrb r3,[r0,#2]
		@ldrb r4,[r0,#3]

		ldr r0,=y
		ldr r1,=x
		bl copy_BCD

		while:

			ldr r0,=y
			b check_gt_1


			return_check_gt_1:

			cmp r0,#1
			bne while_end

			ldr r0,=s
			ldr r1,=zero

			bl copy_BCD


			mov r4,#0   @ inner i is r4

			loop_start2:

		
			ldr r0,=dd
			ldr r1,=zero
			bl copy_BCD  @passing r0 and r1 i.e. *dd and *zero

			ldr r5,=dd
			ldr r6,=y
			ldrb r7,[r6,r4]
			mul r6,r7,r7
			strb r6,[r5]

			ldr r6,=dd
			ldrb r5,[r6,#0]
			ldrb r7,[r6,#1]
				loop_start:



			
				cmp r5,#9
				ble ret2


				sub r5,r5,#10
				strb r5,[r6]
				add r7,r7,#1
				strb r7,[r6,#1]

				b loop_start

			ret2:
			
			ldr r0,=s
			ldr r1,=s
			ldr r2,=dd
			bl add_BCD

			add r4,r4,#1
			cmp r4,#4
			blt loop_start2


			ldr r0,=y
			ldr r1,=s
			bl copy_BCD

			b while
		while_end:


		ldr r0,=y
		ldrb r0,[r0,#0]
		b check_happy

		return_check_happy:

		cmp r0,#1
		bne skip_if_main

		add r9,r9,#1
		ldr r7,=x
		@ldr r8,[r7,#0]
		@ldr r8,[r7,#4]
		@ldr r8,[r7,#8]
		@ldr r8,[r7,#12]
		@PRINT
        @below it file handling


        ldr r0,=OutFileHandle
        ldr r0,[r0]


        ldr r1,=MatMsg0
        swi 0x69
        mov r1,r9
        swi 0x6b
        ldr r1,=MatMsg1
        swi 0x69
        ldrb r1,[r7,#3]
        swi 0x6b
        ldrb r1,[r7,#2]
        swi 0x6b
        ldrb r1,[r7,#1]
        swi 0x6b
        ldrb r1,[r7,#0]
        swi 0x6b
        ldr r1,=MatMsg2
        swi 0x69


        @ above this file handling
		skip_if_main:

		ldr r0,=x
		ldr r1,=x
		ldr r2,=one
		
		bl add_BCD

	add r10,r10,#1
	ldr r5,=9999
	cmp r10,r5
	blt for_loop_outer

    ldr r0,=OutFileHandle
    ldr r0,[r0]
    swi 0x68

    swi SWI_Exit



check_gt_1:
@ r0 is *x
	mov r1,r0
	mov r0,#1
	ldrb r2,[r1,#1]
	cmp r2,#0
	bgt ret
	ldrb r2,[r1,#2]
	cmp r2,#0
	bgt ret
	ldrb r2,[r1,#3]
	cmp r2,#0
	bgt ret
	mov r0,#0
ret: 
@mov pc,lr
b return_check_gt_1


check_happy:
@ r0 is passed as x
	mov r1,r0
	mov r0,#1
	cmp r1,#7
	beq ret3
	cmp r1,#1
 	beq ret3
	mov r0,#0
ret3: 
@mov pc,lr
b return_check_happy



@r0 is x[0]
@r1 is s[0]
copy_BCD:
	ldrb r3,[r1,#0]		@r3 is x0 
	strb r3,[r0,#0] 
	ldrb r3,[r1,#1]		@r3 is x1
	strb r3,[r0,#1]
	ldrb r3,[r1,#2]		@r3 is x2 
	strb r3,[r0,#2]
	ldrb r3,[r1,#3]	@r3 is x3 
	strb r3,[r0,#3]
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
		ldrb r2,[r2,r0]
		add r12,r12,r2
		ldr r2,[r1,#4]
		ldrb r2,[r2,r0]

		add r12,r12,r2
		add r12,r12,r3

		ldr r1,[r1,#0]
		strb r12,[r1,r0]

		
		mov r3,#0

		cmp r12,#9
		ble skip_if

			sub r12,r12,#10
			strb r12,[r1,r0]
			mov r3,#1

		skip_if:


		add r0,r0,#1
		cmp r0,#4
		blt loop

	
	mov pc,lr

















	.data
x: .word 0
s: .word 0
y: .word 0
one: .word 0
dd: .word 0
zero: .word 0
AA: .space 50
MatMsg0: .asciz "number["
MatMsg1: .asciz "] = "
MatMsg2: .asciz "\n"
OutFileName: .asciz "Outfile1.txt"
OutFileError:.asciz "Unable to open output file\n"
.align
OutFileHandle:.word 0
	.end



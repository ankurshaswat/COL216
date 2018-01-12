@r0 is x[0]
@r1 is s[0]
ldr r0,=x
ldr r1,=y





copy_BCD:
	ldr r3,[r1,#0]		@r3 is x0 
	str r3,[r0,#0] 
	ldr r3,[r1,#4]		@r3 is x1
	str r3,[r0,#4]
	ldr r3,[r1,#8]		@r3 is x2 
	str r3,[r0,#8]
	ldr r3,[r1,#12]	@r3 is x3 
	str r3,[r0,#12]
ret: @mov pc,lr


ldr r0,=x
ldr r1,[r0]
ldr r2,[r0,#4]
ldr r3,[r0,#8]
ldr r4,[r0,#12]




	.data
x: .word 0,0,0,0
s: .word 0,0,0,0
y: .word 3,4,5,6
one: .word 1,0,0,0
dd: .word 0,0,0,0
zero: .word 0,0,0,0
AA: .space 400
BB: .space 400
	.end


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
ret: mov pc lr
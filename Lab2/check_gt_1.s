

ldr r0,=X
@check_gt_1:
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
ret:

X:.word 1,0,0,1



mov r0,#8
@check_happy:
@ r0 is passed as x
mov r1,r0
mov r0,#1
cmp r1,#7
beq ret3
cmp r1,#1
beq ret3
mov r0,#0
ret3:




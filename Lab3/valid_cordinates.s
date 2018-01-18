valid_coordinate:
cmp r0,#7
bgt out
cmp r0 , #0
blt out
cmp r1,#7
bgt out
cmp r1 , #0
blt out
mov r0,#1
b ret
out:
mov r0,#0

ret:
    mov pc,lr

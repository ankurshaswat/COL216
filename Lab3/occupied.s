occupied : 
add r1,r1,r0,LSL #3
mov r1 ,r1,LSL #2
ldr r1,[r0,r1]
cmp r1, #-1
bgt out:
mov r0,#0

out :
    mov r0,#1

ret:
    mov pc,lr

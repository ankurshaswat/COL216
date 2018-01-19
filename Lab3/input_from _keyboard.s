read :
ldr r3, =A
L: swi 0x203
cmp r0, #0
beq L
mov r1, #0
tst r0, #255
addeq r1, r1, #8
moveq r0, r0, LSR #8
tst r0, #15
addeq r1, r1, #4
moveq r0, r0, LSR #4

tst r0, #3
addeq r1, r1, #2
moveq r0, r0, LSR #2
tst r0, #1
addeq r1, r1, #1
moveq r0, r0, LSR #1
@str r1, [r3]
@add r3, r3, #4
@cmp r1, #15
@bne L

mov r0,r1

mov pc,lr

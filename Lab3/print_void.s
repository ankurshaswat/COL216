.equ SWI_Exit, 0x11
.text

@print_void:
    bl initialize


    ldr r3,=grid
    mov r0,#0   @r0 is x
    mov r1,#0   @r1 is y
out_loop:
    cmp r0,#8
    mov r1,#0
    beq ret1
    in_loop:
        cmp r1 , #8
        addeq r0,r0,#1
        beq out_loop
        @Display the Integer
        ldr r2,[r3],#4
        cmp r2,#0
        beq disp
        cmp r2,#1
        beq disp
        bne disp_point
        b out5
disp_point:
        mov r0,r0,LSL #2
        mov r1,r1,LSL #1
        mov r2,#'.
        swi 0x207
         mov r1,r1,LSR #1
         mov r0,r0,LSR #2
        b out5
disp:
         mov r0,r0,LSL #2
        mov r1,r1,LSL #1
        swi 0x205
        mov r1,r1,LSR #1
         mov r0,r0,LSR #2
out5:

        add r1,r1,#1
        b in_loop

ret1:
mov r0,#34
mov r1,#1
    ldr r2,=Message0
    swi 0x204

mov r1,#6
    ldr r2,=Message1
    swi 0x204
mov r0,#36
mov r1,# 3
    ldr r3,=score
    ldr r2,[r3]
    swi 0x205
mov r1,#8
    ldr r2,[r3,#4]
    swi 0x205
swi SWI_Exit
 @   mov pc,lr


initialize:
mov r12,#2
ldr r0,=score
str r12,[r0,#0]
str r12,[r0,#4]
ldr r0,=active_player
mov r0,#0

ldr r2,=grid @ r2 is grid throughout now

mov r0,#0 @ i=0

@ 8x+y is used to access registers (store array linearly)

outer_loop_start:

mov r1,#0 @ j=0

inner_loop_start:

@@@@@mul r3,r0,#8  @ r3 = 8 * i
add r3,r1,r0,LSL #3  @ r3 = r1 +r3 = 8*i + j
@@@@@mul r3,r3,#4
mov r12,#3
str r12,[r2,r3,LSL #2]  @storing 3 at all positions


add r1,r1,#1
cmp r1,#8
bne inner_loop_start

add r0,r0,#1
cmp r0,#8
bne outer_loop_start

ldr r2,=grid
mov r0,#3
mov r1,#3
add r3,r1,r0,LSL #3  @ r3 = r1 +r3 = 8*i + j
mov r12,#1
str r12,[r2,r3,LSL #2]


mov r0,#4
mov r1,#4
add r3,r1,r0,LSL #3  @ r3 = r1 +r3 = 8*i + j
mov r12,#1
str r12,[r2,r3,LSL #2]

mov r0,#3
mov r1,#4
add r3,r1,r0,LSL #3  @ r3 = r1 +r3 = 8*i + j
mov r12,#0
str r12,[r2,r3,LSL #2]

mov r0,#4
mov r1,#3
add r3,r1,r0,LSL #3  @ r3 = r1 +r3 = 8*i + j
mov r12,#0
str r12,[r2,r3,LSL #2]


mov pc,lr

.data
active_player: .word 0
score: .word 0, 0
success: .word 0
grid: .space 300
player_input: .word 0,0
valid: .word 0
Message0: .asciz "BLACK"
Message1: .asciz "WHITE"
.end

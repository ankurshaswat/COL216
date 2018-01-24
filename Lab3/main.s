.equ SWI_Exit, 0x11
.text

    bl initialize



    infinite_repeat:
        bl clear_print
    @active player is stored in r7
    ldr r7,=active_player

    @change_Added
    ldr r7 ,[r7]
    @change_completed // 24.01.18

    @disc_to_find is opposite to the active player
    rsb r8,r7,#1  @1-active_player


    @get input of Column(y placeholder) into r4
    @get input of row(x placeholder) into r5
    @ was on //24.01.18
                    @ ldr r11,=player_input
                    @str r5,[r11]
                    @str r4,[r11,#4]
    @ added
    ldr r11,=player_input
    bl input_from_keyboard
    mov r5,r0
    str r5,[r11]
    bl input_from_keyboard
    mov r4,r0
    str r4,[r11,#4]
    @ addition completed


    ldr r11,=valid                                                    @@@@@mov r6,#0  @ r6 is valid is false
    mov r0,#0
    str r0,[r11]  @setting valid to be 0 i.e. false

    mov r0,r5
    mov r1,r4
    bl occupied  @ x and y as parameters

    cmp r0,#1
    @@@@@@@@   Display the invalid Message
    bne it_is_not_occupied
    bl display_invalid_input
    beq infinite_repeat  @continue if returns false
it_is_not_occupied:
    mov r0,r5
    mov r1,r4 @ changed was mov r1,r5   // 24.01.18
    bl valid_coordinate   @x and y as parameters to valid_co-valid_coordinate

    cmp r0,#0
    bne these_are_valid_coordinates
    bl display_invalid_input
    beq infinite_repeat   @continue if returns false

these_are_valid_coordinates:

    mov r9,#-1  @ i for loop

    outer_loop_start1:

    mov r10,#-1 @ j  for loop

    inner_loop_start1:

    cmp r9,#0
    bne skip_if
    cmp r10,#0
    bne skip_if
    b inner_loop_end1

    skip_if:
@ was on 24.01.18
    ldr r11,=player_input
    ldr r4,[r11]
    ldr r5,[r11,#4]
@ added on 24.01.18

@bl input_from_keyboard
@mov r4,r0
@bl input_from_keyboard
@mov r5,r1

@ done
    mov r6,#0  @ to_flip is r6

    add r4,r4,r9
    add r5,r5,r10

    @@@@start from while valid_coordinate and so on..........

    inner_while_start:

    mov r0,r4 @ x_copy in r0
    mov r1,r5 @ y_copy in r1
    bl valid_coordinate
    cmp r0,#0
    beq inner_while_end

    ldr r11,=grid
    add r7,r1,r0,LSL #3   @y_copy+ 8*x_copy
    @@@@mul r7,r7,#4   @number of bytes to check ahead

    add r11,r11,r7,LSL #2 @r11 points to grid[x_copy][y_copy]

    ldr r7,[r11] @r7 has value of r11 pointer

    cmp r7,r8

    bne else_if

    add r6,r6,#1 @to_flip++
    add r4,r4,r9
    add r5,r5,r10

    b end_if

    else_if:

    ldr r0,=active_player
    cmp r0,r7
    bne else

    @inner if starts here
    cmp r6,#0

    beq inner_while_end

    rsb r1,r9,#0 @ r1 is direction_x
    rsb r2,r10,#0 @ r2 is direction_y

    add r4,r4,r1
    add r5,r5,r2

    another_infinite_while_start:

    ldr r3,=player_input
    ldr r3,[r3]
    cmp r4,r3
    bne skip

    ldr r3,=player_input
    ldr r3,[r3,#4]
    cmp r5,r3
    beq another_infinite_while_end

    skip:

    str r0,[r11]
    ldr r7,=score
    ldr r3,[r7,r0,LSL #2]
    add r3,r3,#1
    str r3,[r7,r0,LSL #2]
    ldr r3,[r7,r8,LSL #2]
    sub r3,r3,#1
    str r3,[r7,r8,LSL #2]

    add r4,r4,r1
    add r5,r5,r2

    b another_infinite_while_start
    another_infinite_while_end:

    str r0,[r11]
    ldr r12,=valid
    mov r0,#1
    str r0,[r12]
    ldr r0,=active_player

    @ innner if ends


    b inner_while_end

    b end_if

    else:
    b inner_while_end

    end_if:



    add r4,r4,r9
    add r5,r5,r10
    b inner_while_start

    inner_while_end:


    inner_loop_end1:

    add r10,r10,#1
    cmp r10,#2
    bne inner_loop_start1


    outer_loop_end1:

    add r9,r9,#1
    cmp r9,#2
    bne outer_loop_start1



    ldr r0,=valid
    @ if start
    cmp r0,#1
    bne skip_if2

      ldr r0,=score

      ldr r1,=active_player
      ldr r1,[r1]

      ldr r2,[r0,r1,LSL #2]
      add r2,r2,#1
      str r2,[r0,r1,LSL #2]

      ldr r1,=active_player
      ldr r0,[r1,#0]
      rsb r0,r0,#1
      str r0,[r1]

    skip_if2:




    bl print_void


    b infinite_repeat



valid_coordinate:
    cmp r0,#7    @r0 is x
    bgt out      @//r1 is y
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


    right_led:
        mov r0, #0x01
        swi 0x201
        mov pc,lr

print_void:


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
            @swi SWI_Exit
            mov pc,lr






    occupied:
            add r1,r1,r0,LSL #3
            mov r1 ,r1,LSL #2
            ldr r0,=grid
            ldr r1,[r0,r1]
            cmp r1, #-1
            bgt out2
            mov r0,#0
            b out12
            out2:
                mov r0,#1
            out12:

                mov pc,lr


    left_led:
                mov r0, #0x02
                swi  0x201
                mov pc,lr




    input_from_keyboard:
                @ldr r3, =A
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

display_invalid_input:
                mov r0,#32
                mov r1,#11
                ldr r2,=invalid0
                swi 0x204
                mov r1,#12
                ldr r2,=invalid1
                swi 0x204
                mov r1,#13
                ldr r2,=invalid2
                swi 0x204
                mov r1,#14
                ldr r2,=invalid3
                swi 0x204
                mov pc,lr

clear_print:
                swi 0x206
                b print_void
                mov pc,lr


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
                    mov r12,#-1
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
invalid0: .asciz "INVALID"
invalid1: .asciz "INPUT"
invalid2: .asciz "ENTER"
invalid3: .asciz "AGAIN"
	.end

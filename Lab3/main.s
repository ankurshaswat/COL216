.equ SWI_Exit, 0x11
.text

    bl initialize

    bl print_void

    infinite_repeat:

    @active player is stored in r7
    mov r7,=active_player

    @disc_to_find is opposite to the active player
    sub r8,#1,r7  @1-active_player


    @get input of Column(y placeholder) into r4
    @get input of row(x placeholder) into r5
    ldr r11,=player_input
    str r5,[r11]
    str r4,[r11,#4]

    ldr r11,=valid
    @@@@@mov r6,#0  @ r6 is valid is false
    str #0,[r11]  @setting valid to be 0 i.e. false

    mov r0,r5
    mov r1,r4
    bl occupied  @ x and y as parameters

    cmp r0,#0
    beq infinite_repeat  @continue if returns false

    mov r0,r5
    mov r1,r5
    bl valid_coordinate   @x and y as parameters to valid_co-valid_coordinate

    cmp r0,#0
    beq infinite_repeat   @continue if returns false


    mov r9,#-1  @ i for loop

    outer_loop_start1:

    mov r10,#-1 @ j  for loop

    inner_loop_start1:

    cmp r9,#0
    bne skip_if
    cmp r10,#0
    bne skip_if
    b inner_loop_end1

    ldr r11,=player_input
    ldr r4,[r11]
    ldr r5,[r11,#4]

    mov r6,#0  @ to_flip is r6

    add r4,r4,r9
    add r5,r5,r10

    @@@@start from while valid_coordinate and so on..........

    inner_while_start:

    mv r0,r4 @ x_copy in r0
    mv r1,r5 @ y_copy in r1
    bl valid_coordinate
    cmp r0,#0
    beq inner_while_end

    ldr r11,=grid
    add r7,r1,r0 LSL #3   @y_copy+ 8*x_copy
    mul r7,r7,#4   @number of bytes to check ahead

    add r11,r11,r7 @r11 points to grid[x_copy][y_copy]

    ldr r7,[r11] @r7 has value of r11 pointer

    cmp r7,r8

    bne else_if

    add r6,r6,#1 #to_flip++
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

    sub r1,#0,r9 @ r1 is direction_x
    sub r2,#0,r10 @ r2 is direction_y

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
    ldr r3,[r7,r0 LSL #2]
    add r3,r3,#1
    str r3,[r7,r0 LSL #2]
    ldr r3,[r7,r8 LSL #2]
    sub r3,r3,#1
    str r3,[r7,r8 LSL #2]

    add r4,r4,r1
    add r5,r5,r2

    b another_infinite_while_start
    another_infinite_while_end:

    str r0,[r11]
    ldr r12,=valid
    str #1,[r12]

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

    add r10,#1
    cmp r10,2
    bne inner_loop_start1


    outer_loop_end1:

    add r9,#1
    cmp r9,2
    bne outer_loop_start1



    ldr r0,=valid
    @ if start
    cmp r0,#1
    bne skip_if2

      ldr r0,=score

      ldr r1,=active_player
      ldr r1,[r1]

      ldr r2,[r0,r1 LSL #2]
      add r2,r2,#1
      str r2,[r0,r1 LSL #2]

      ldr r1,=active_player
      ldr r0,[r1,#0]
      sub r0,#1,r0
      str r0.[r1]

    skip_if2:




    bl print_void


    b infinite_repeat


	.data
active_player: .word 0
score: .word 0, 0
success: .word 0
grid: .space 300
player_input: .word 0,0
valid: .word 0
	.end

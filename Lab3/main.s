.equ SWI_Exit, 0x11
.text

    bl initialize

    bl update_screen

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

    inner_loop_end1:

    add r10,#1
    cmp r10,2
    bne inner_loop_start1


    outer_loop_end1:

    add r9,#1
    cmp r9,2
    bne outer_loop_start1





























    b infinite_repeat


	.data
active_player: .word 0
score: .word 0, 0
success: .word 0
grid: .space 300
player_input: .word 0,0
valid: .word 0
	.end

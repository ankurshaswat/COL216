print_void:
    mov r3,=grid   @r2 contains the address of the grid = grid
    mov r0,#0   @r0 is x
    mov r1,#0   @r1 is y
out_loop:
    cmp r0,#8
    beq ret
    in_loop:
        cmp r1 , #8
        addeq r0,r0,#1
        beq out_loop
        @Display the Integer
        ldr r2,[r3],#4
        add r1,r1#1
        b in_loop
ret :
    mov pc,lr

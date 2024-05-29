.global main

# use main to be able to call c functions and return 0 as exit code
main:
        # allocate stack space and save s0, s1 and return address
        addi sp, sp, -32
        sd   ra, 16(sp)
        sd   s0, 8(sp)
        sd   s1, 0(sp)

        # prompt user for first number
        li    a0, 1
        la    a1, prompt_num_one
        li    a2, 22
        li    a7, 64
        ecall

        # get input of user in buffer
        li a0, 0
        la a1, buffer_num_one
        li a2, 64
        li a7, 63
        ecall

        # convert buffer to float
        la    a0, buffer_num_one
        li    a1, 0
        call strtod

        # move float to temp float register
        fmv.d f0, fa0

        # prompt user for second number
        li    a0, 1
        la    a1, prompt_num_two
        li    a2, 23
        li    a7, 64
        ecall

        # get input of user in buffer
        li a0, 0
        la a1, buffer_num_two
        li a2, 64
        li a7, 63
        ecall

        # convert buffer to float
        la    a0, buffer_num_two
        li    a1, 0
        call strtod

        # move float 2 to temp float register
        fmv.d f1, fa0

prompt:
        # prompt user for arithmetic symbol
        li a0, 1
        la a1, prompt_symbol
        li a2, 35
        li a7, 64
        ecall

        # get input of user in buffer
        li a0, 0
        la a1, buffer_symbol
        li a2, 8
        li a7, 63
        ecall

        # check if symbol is + (43)
        la x5, buffer_symbol
        lb x6, 0(x5)
        li x7, 43
        beq x6, x7, plus # if not equal -> check other symbols

        # check if symbol is - (45)
        li x7, 45
        beq x6, x7, minus

        # check if symbol is / (47)
        li x7, 47
        beq x6, x7, division

        # check if symbol is * (42)
        li x7, 42
        beq x6, x7, multiplication

        # else: prompt again
        j prompt

plus:
        # calculate sum
        fadd.d f2, f0, f1

        # jump to print
        j print

minus:
        # calculate difference
        fsub.d f2, f0, f1

        # jump to print
        j print

division:
        # calculate ratio
        fdiv.d f2, f0, f1

        # jump to print
        j print

multiplication:
        # calculate product
        fmul.d f2, f0, f1

        # jump to print
        j print

print:
        # print float via printf
        fmv.x.d  a1, f2
        la a0, float_msg
        call printf

        # deallocate stack space and return with 0
        li    a0, 0
        ld    s1, 0(sp)
        ld    s2, 8(sp)
        ld    ra, 16(sp)
        addi  sp, sp, 32
        ret

.data
plus_msg: .ascii "plus"
.align 4
minus_msg: .ascii "minus"
.align 4
multiplication_msg: .ascii "multiplication"
.align 4
division_msg: .ascii "division"
.align 4
prompt_num_one: .ascii "Erste Zahl eingeben:\n"
.align 4
prompt_num_two: .ascii "Zweite Zahl eingeben:\n"
.align 4
prompt_symbol: .ascii "Rechenzeichen (+,-,/,*) eingeben:\n"
.align 4
float_msg: .asciz "Ergebnis: %f\n"
.align 4
buffer_symbol: .skip 8 # standard ascii is 7 bit, skip 8 for alignment
buffer_num_one: .skip 64 # 64 bit buffer for 64 bit double precision float
buffer_num_two: .skip 64 

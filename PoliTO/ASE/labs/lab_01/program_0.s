; **** MIPS64 ****
.data

v1: .byte  1,  3,   8, 2,  6, -3, 11,  9, 11, -3,  6, 2, 8,  3, 1
v2: .byte  4,  7, -10, 3, 11,  9,  7,  6,  4,  7,  5, 4, 1,  7, 4
v3: .byte  4, -1,   3, 9, 22,  5, -1,  9, -1,  5, 22, 9, 3, -1, 4
f1: .space 1
f2: .space 1
f3: .space 1
v4: .space 15

.text
main:
    daddi   R2,         R0,             8                           ; loads half+1 the length of the vectors in R2
    daddi   R7,         R0,             v1                          ; loads the address of v1 into R7
    daddi   R8,         R7,             14                          ; loads the address of the last element of v1 into R8

loopv1:
    daddi   R2,         R2,             -1                          ; loops on the vector

    lb      R4,         0(R7)                                       ; loads the first element of the vector
    lb      R5,         0(R8)                                       ; loads the last element of the vector

    bne     R4,         R5,             nov1                        ; checks if the first and last elements are equal
    daddi   R7,         R7,             1                           ; increments the first element
    daddi   R8,         R8,             -1                          ; decrements the last element

    beqz    R2,         yesv1
    j       loopv1
yesv1:
    daddi   R6,         R0,             1
    sb      R6,         f1(R0)

nov1:
    daddi   R2,         R0,             8                           ; loads half+1 the length of the vectors in R2
    daddi   R7,         R0,             v2                          ; loads the address of v2 into R7
    daddi   R8,         R7,             14                          ; loads the address of the last element of v2 into R8

loopv2:
    daddi   R2,         R2,             -1                          ; loops on the vector

    lb      R4,         0(R7)                                       ; loads the first element of the vector
    lb      R5,         0(R8)                                       ; loads the last element of the vector

    bne     R4,         R5,             nov2                        ; checks if the first and last elements are equal
    daddi   R7,         R7,             1                           ; increments the first element
    daddi   R8,         R8,             -1                          ; decrements the last element

    beqz    R2,         yesv2
    j       loopv2

yesv2:
    daddi   R6,         R0,             1
    sb      R6,         f2(R0)

nov2:
    daddi   R2,         R0,             8                           ; loads half+1 the length of the vectors in R2
    daddi   R7,         R0,             v3                          ; loads the address of v3 into R7
    daddi   R8,         R7,             14                          ; loads the address of the last element of v3 into R8

loopv3:
    daddi   R2,         R2,             -1                          ; loops on the vector

    lb      R4,         0(R7)                                       ; loads the first element of the vector
    lb      R5,         0(R8)                                       ; loads the last element of the vector

    bne     R4,         R5,             nov3                        ; checks if the first and last elements are equal
    daddi   R7,         R7,             1                           ; increments the first element
    daddi   R8,         R8,             -1                          ; decrements the last element

    beqz    R2,         yesv3
    j       loopv3

yesv3:
    daddi   R6,         R0,             1
    sb      R6,         f3(R0)

nov3:

; Given that there are not that many cases we can just iterate over each one of them

    daddi   R4,         R0,             f1
    daddi   R5,         R0,             f2
    daddi   R6,         R0,             f3

    lb      R4,         0(R4)
    lb      R5,         0(R5)
    lb      R6,         0(R6)

    bnez    R4,         casev1
    bnez    R5,         casev2
    bnez    R6,         casev3
    j       end                                                     ; casse none

casev1:
    bnez    R5,         casev1v2
    bnez    R6,         casev1v3
    daddi   R1,         R0,             14                          ; uses R1 as index, initalizes it to 14
    daddi   R7,         R0,             v1
    daddi   R7,         R0,             14                          ; loads the address of the last element of v1 in R7
l1:
    lb      R8,         0(R7)
    sb      R8,         v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    bnez    R1,         l1
    j       end

casev2:
    bnez    R6,         casev2v3
    daddi   R1,         R0,             14                          ; uses R1 as index, initalizes it to 14
    daddi   R7,         R0,             v2
    daddi   R7,         R0,             14                          ; loads the address of the last element of v1 in R7
l2:
    lb      R8,         0(R7)
    sb      R8,         v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    bnez    R1,         l2
    j       end

casev3:
    daddi   R1,         R0,             14                          ; uses R1 as index, initalizes it to 14
    daddi   R7,         R0,             v3
    daddi   R7,         R0,             14                          ; loads the address of the last element of v1 in R7
l3:
    lb      R8,         0(R7)
    sb      R8,         v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    bnez    R1,         l3
    j       end

casev1v2:
    bnez    R6,         casev1v2v3
    daddi   R1,         R0,             14

    daddi   R7,         R0,             v1
    daddi   R8,         R0,             v2

    daddi   R7,         R7,             14
    daddi   R8,         R8,             14
l4:
    lb      R9,         0(R7)
    lb      R10,        0(R8)
    dadd    R11,        R9,             R10
    sb      R11,        v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    daddi   R8,         R8,             -1
    bnez    R1,         l4
    j       end

casev1v3:
    daddi   R1,         R0,             14

    daddi   R7,         R0,             v1
    daddi   R8,         R0,             v3

    daddi   R7,         R7,             14
    daddi   R8,         R8,             14
l5:
    lb      R9,         0(R7)
    lb      R10,        0(R8)
    dadd    R11,        R9,             R10
    sb      R11,        v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    daddi   R8,         R8,             -1
    bnez    R1,         l5
    j       end

casev2v3:
    daddi   R1,         R0,             14

    daddi   R7,         R0,             v2
    daddi   R8,         R0,             v3

    daddi   R7,         R7,             14
    daddi   R8,         R8,             14
l6:
    lb      R9,         0(R7)
    lb      R10,        0(R8)
    dadd    R11,        R9,             R10
    sb      R11,        v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    daddi   R8,         R8,             -1
    bnez    R1,         l6
    j       end

casev1v2v3:
    daddi   R1,         R0,             14

    daddi   R7,         R0,             v1
    daddi   R8,         R0,             v2
    daddi   R9,         R0,             v3

    daddi   R7,         R7,             14
    daddi   R8,         R8,             14
    daddi   R9,         R9,             14
l7:
    lb      R10,        0(R7)
    lb      R11,        0(R8)
    lb      R12,        0(R9)
    dadd    R13,        R10,            R11
    dadd    R14,        R13,            R12
    sb      R14,        v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    daddi   R8,         R8,             -1
    daddi   R9,         R9,             -1
    bnez    R1,         l7
    j       end

end:
    halt

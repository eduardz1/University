; **** MIPS64 ****
.data

v1: .byte  1,  3,   8, 2,  6, -3, 11,  9, 11, -3,  6, 2, 8,  3, 1
v2: .byte  4,  7, -10, 3, 11,  9,  7,  6,  4,  7,  5, 4, 1,  7, 4
v3: .byte  4, -1,   3, 9, 22,  5, -1,  9, -1,  5, 22, 9, 3, -1, 4
f1: .space 0
f2: .space 0
f3: .space 0
v4: .space 15

.text
main:
    daddi   R2,         R0,             8                           ; loads half+1 the length of the vectors in R2
    daddi   R7,         R0,             v1                          ; loads the address of v1 into R7
    daddi   R8,         R7,             14                          ; loads the address of the last element of v1 into R8

loop_v1:
    daddi   R2,         R2,             -1                          ; loops on the vector

    lb      R4,         0(R7)                                       ; loads the first element of the vector
    lb      R5,         0(R8)                                       ; loads the last element of the vector

    bne     R4,         R5,             no_v1                       ; checks if the first and last elements are equal
    daddi   R7,         R7,             1                           ; increments the first element
    daddi   R8,         R8,             -1                          ; decrements the last element

    beqz    R2,         yes_v1
    j       loop_v1
yes_v1:
    daddi   R6,         R0,             1
    sb      R6,         f1(R0)

no_v1:
    daddi   R2,         R0,             8                           ; loads half+1 the length of the vectors in R2
    daddi   R7,         R0,             v2                          ; loads the address of v2 into R7
    daddi   R8,         R7,             14                          ; loads the address of the last element of v2 into R8

loop_v2:
    daddi   R2,         R2,             -1                          ; loops on the vector

    lb      R4,         0(R7)                                       ; loads the first element of the vector
    lb      R5,         0(R8)                                       ; loads the last element of the vector

    bne     R4,         R5,             no_v2                       ; checks if the first and last elements are equal
    daddi   R7,         R7,             1                           ; increments the first element
    daddi   R8,         R8,             -1                          ; decrements the last element

    beqz    R2,         yes_v2
    j       loop_v2

yes_v2:
    daddi   R6,         R0,             1
    sb      R6,         f2(R0)

no_v2:
    daddi   R2,         R0,             8                           ; loads half+1 the length of the vectors in R2
    daddi   R7,         R0,             v3                          ; loads the address of v3 into R7
    daddi   R8,         R7,             14                          ; loads the address of the last element of v3 into R8

loop_v3:
    daddi   R2,         R2,             -1                          ; loops on the vector

    lb      R4,         0(R7)                                       ; loads the first element of the vector
    lb      R5,         0(R8)                                       ; loads the last element of the vector

    bne     R4,         R5,             no_v3                       ; checks if the first and last elements are equal
    daddi   R7,         R7,             1                           ; increments the first element
    daddi   R8,         R8,             -1                          ; decrements the last element

    beqz    R2,         yes_v3
    j       loop_v3

yes_v3:
    daddi   R6,         R0,             1
    sb      R6,         f3(R0)

no_v3:

; Given that there are not that many cases we can just iterate over each one of them

    daddi   R4,         R0,             f1
    daddi   R5,         R0,             f2
    daddi   R6,         R0,             f3

    bnez    R4,         case_v1
    bnez    R5,         case_v2
    bnez    R6,         case_v3
    j       end                                                     ; casse none

case_v1:
    bnez    R5,         case_v1_v2
    bnez    R6,         case_v1_v3
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

case_v2:
    bnez    R6,         case_v2_v3
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

case_v3:
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

case_v1_v2:
    bnez    R6,         case_v1_v2_v3
    daddi   R1,         R0,             14

    daddi   R7,         R0,             v1
    daddi   R8,         R0,             v2

    daddi   R7,         R7,             14
    daddi   R8,         R8,             14
l4:
    lb      R9,         0(R7)
    lb      R10,        0(R8)
    daddi   R11,        R9,             R10
    sb      R11,        v4(R1)
    daddi   R1,         R1,             -1
    daddi   R7,         R7,             -1
    daddi   R8,         R8,             -1
    bnez    R1,         l4
    j       end

case_v1_v3:
    nop     
    ;       ;,          ;,              ;,      ;,;,;,;,;,;,;       ; ;
case_v2_v3:
    nop     
    ;       ;,          ;,              ;,      ;,;,;,;,;,;,;       ; ;
case_v1_v2_v3:
    nop     
    ;       ;,          ;,              ;,      ;,;,;,;,;,;,;       ; ;
end:
    nop     
    halt    
    ;       ;,          ;,              ;,      ;,;,;,;,;,;,;       ; ;






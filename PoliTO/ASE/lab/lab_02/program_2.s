; ******** winMIPS64 **********
; Program that computes the output y of a neural computation
; formalized by the following equation:
; x = sum_{i=0}^{k-1} (i_j * w_j + b)
; y = f(x)
; 
; where, to prevent the propagation of NaN (Not a Number)
; the activation function f is defined as follows:
; f(x) = 0 if the exponent part of x is equal to 0x7ff
;        x otherwise

.data

i: .double 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0
.double 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0
.double 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0

w: .double 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.11
.double 0.01, 0.01, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.12
.double 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, 0.13

b: .double 171.0                                                            ; 0xAB

check: .word 2047                                                           ; 0xf77

y: .space 8

.text

main:

    daddi   R11,    R0,         240                                         ; load index k in R11
    ld      R21,    check(R0)                                               ; loads 0x7FF into R21
    add.d   F3,     F0,         F0                                          ; initializes F3 to store y
    l.d     F5,     b(R0)                                                   ; loads b in F5

loop:

    daddi   R11,    R11,        -8                                          ; decrements index of 8 byte

    l.d     F1,     i(R11)
    l.d     F2,     w(R11)

; check if both i and w are NaN by isolating the exponent (bits 62-52)

    mfc1    R20,    F1                                                      ; cannot perform shift on floating-point registers
    dsll    R20,    R20,        1
    dsrl    R20,    R20,        31
    dsrl    R20,    R20,        22                                          ; shift is only 5 bit

    mfc1    R22,    F2                                                      ; cannot perform shift on floating-point registers
    dsll    R22,    R22,        1
    dsrl    R22,    R22,        31
    dsrl    R22,    R22,        22                                          ; shift is only 5 bit

; exponent is now in bits 0-10

    beq     R21,    R20,        nan                                         ; exponent
    beq     R21,    R22,        nan                                         ; exponent

    mul.d   F4,     F1,         F2                                          ; F4 = i[k]*w[k]
    add.d   F4,     F4,         F5                                          ; F4 = F4 + b

nan:

    add.d   F3,     F3,         F4
    bnez    R11,    loop

end:

    s.d     F3,     y(R0)
    halt    

; ------------------------------------------------------------------------------
; --- Expected result ----------------------------------------------------------
; 5174.315000
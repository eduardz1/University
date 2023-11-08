; ******** MIPS64 *********
; int m=1 /* 64  bit */
; double k,p
; for (i = 0; i < 64; i++){
;   if (i is even) {
;       p= v1[i] * ((double)( m<< i)) /*logic shift */
;       m = (int)p
;   } else { /*  i is odd */ 
;       p= v1[i] / ((double)m* i))
;       k =  ((float)((int)v4[i]/ 2^i)
;   }
; 
;   v5[i] = ((p * v2[i]) + v3[i])+v4[i];
;   v6[i] = v5[i]/(k+v1[i]);
;   v7[i] = v6[i]*(v2[i]+v3[i]);
; }

.data

; We have 4 vectors of 64 doubles each
; assuming v1 and v4 do not contain 0 values
; v5, v6, v7 are empty vectors of the same size

v1: .double 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1
.double 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
.double 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
.double 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1
.double 33.1, 34.1, 35.1, 36.1, 37.1, 38.1, 39.1, 40.1
.double 41.1, 42.1, 43.1, 44.1, 45.1, 46.1, 47.1, 48.1
.double 49.1, 50.1, 51.1, 52.1, 53.1, 54.1, 55.1, 56.1
.double 57.1, 58.1, 59.1, 60.1, 61.1, 62.1, 63.1, 64.1
v2: .double 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1
.double 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
.double 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
.double 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1
.double 33.1, 34.1, 35.1, 36.1, 37.1, 38.1, 39.1, 40.1
.double 41.1, 42.1, 43.1, 44.1, 45.1, 46.1, 47.1, 48.1
.double 49.1, 50.1, 51.1, 52.1, 53.1, 54.1, 55.1, 56.1
.double 57.1, 58.1, 59.1, 60.1, 61.1, 62.1, 63.1, 64.1
v3: .double 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1
.double 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
.double 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
.double 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1
.double 33.1, 34.1, 35.1, 36.1, 37.1, 38.1, 39.1, 40.1
.double 41.1, 42.1, 43.1, 44.1, 45.1, 46.1, 47.1, 48.1
.double 49.1, 50.1, 51.1, 52.1, 53.1, 54.1, 55.1, 56.1
.double 57.1, 58.1, 59.1, 60.1, 61.1, 62.1, 63.1, 64.1
v4: .double 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1
.double 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
.double 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
.double 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1
.double 33.1, 34.1, 35.1, 36.1, 37.1, 38.1, 39.1, 40.1
.double 41.1, 42.1, 43.1, 44.1, 45.1, 46.1, 47.1, 48.1
.double 49.1, 50.1, 51.1, 52.1, 53.1, 54.1, 55.1, 56.1
.double 57.1, 58.1, 59.1, 60.1, 61.1, 62.1, 63.1, 64.1

v5: .space 512
v6: .space 512
v7: .space 512

m: .word 1
k: .double 0.0
p: .double 0.0

.text

main:

    daddi   R11,    R0,         512                     ; loads index i in R11
    daddi   R17,    R0,         64                      ; loads index i/8 in R17
    daddi   R21,    R0,         1                       ; loads 1 in R21, constant for 2 powers
loop:
    daddi   R11,    R11,        -8                      ; i--
    daddi   R17,    R17,        -1                      ; (i/8)--

; loads the value of vx[i] in Fx

    l.d     F13,    p(R0)                               ; loads p regardless
    ld      R12,    m(R0)                               ; loads m regardless

; i is odd

    dmul    R19,    R12,        R11                     ; R12 = m * i
    l.d     F4,     v4(R11)
    cvt.l.d F22,    F4                                  ; cast v4[i] to int
    mfc1    R12,    F22                                 ; move (int)v4[i] to R12
    dsllv   R13,    R21,        R11                     ; R13 = 2^i
    ddiv    R12,    R12,        R13                     ; LO = v4[i] / 2^i

    mtc1    R19,    F14                                 ; move m * i to F14
    cvt.d.l F14,    F14                                 ; cast m * i to double
    div.d   F13,    F1,         F14                     ; p = v1[i] / (m * i)
    cvt.d.l F15,    F15                                 ; cast k to double
    mtc1    R12,    F15                                 ; move R12 to F15
    s.d     F15,    k(R0)                               ; store k

    l.d     F1,     v1(R11)
    l.d     F2,     v2(R11)
    l.d     F3,     v3(R11)

    s.d     F13,    p(R0)                               ; store p

    j       common

even:                                                   ; i is even
    daddi   R11,    R11,        -8                      ; i--
    daddi   R17,    R17,        -1                      ; (i/8)--

    l.d     F13,    p(R0)                               ; loads p regardless
    ld      R12,    m(R0)                               ; loads m regardless
    dsllv   R12,    R12,        R11                     ; R12 = m << i, we would need to divide it if we dsll instead
    mtc1    R12,    F13                                 ; move m << i to F13
    cvt.d.l F13,    F13                                 ; cast m << i to double
    l.d     F1,     v1(R11)
    mul.d   F13,    F13,        F1                      ; p = v1[i] * R12
    
    l.d     F2,     v2(R11)
    l.d     F3,     v3(R11)
    l.d     F4,     v4(R11)

    cvt.l.d F13,    F13                                 ; cast p to int
    mfc1    R12,    F13                                 ; move (int)p to R12
    sd      R12,    m(R0)                               ; store m

common:

    mul.d   F12,    F1,         F2                      ; F12 = v1[i]*v2[i]
    add.d   F20,    F4,         F1                      ; F20 = v4[i] + v1[i]
    add.d   F21,    F2,         F3                      ; F21 = v2[i] + v3[i]

    add.d   F12,    F12,        F3                      ; F12 = F12 + v3[i]
    add.d   F12,    F12,        F4                      ; F12 = F12 + v4[i]
    s.d     F12,    v5(R11)                             ; v5[i] = F12

    l.d     F5,     v5(R11)
    div.d   F20,    F5,         F20                     ; F20 = v5[i]/F20

    s.d     F20,    v6(R11)                             ; v6[i] = F12
    l.d     F6,     v6(R11)

    mul.d   F21,    F6,         F21                     ; F21 = v6[i]*F21
    s.d     F21,    v7(R11)                             ; v7[i] = F21

    beqz    R11,    end                                 ; if i == 0, end
    andi    R18,    R17,        1
    beqz    R18,    even
    bnez    R11,    loop                                ; if i != 0, repeat

end:
    nop
    halt    

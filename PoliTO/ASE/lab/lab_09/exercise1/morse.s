        AREA function, CODE, READONLY
        EXPORT translate_morse
; parameters:
;   R0 = char* vect_input
;   R1 = int vect_input_lenght
;   R2 = char* vect_output
;   R3 = int vet_output_lenght
;   R4 = char change_symbol
;   R5 = char space
;   R6 = char sentence_end
translate_morse
        MOV   R12, sp

        PUSH {R2, R4-R8, R10-R11, lr} ; save volatile registers

        MOV R7, #0   ; index for input vector (post condition: num converter symbols)

        LDR   R4, [R12]     ; change_symbol
        LDR   R5, [R12, #4] ; space
        LDR   R6, [R12, #8] ; sentence_end

start
        MOV R9, #0   ; tmp
        MOV R10, #24 ; tmp variable for shifting
main_loop 
        LDRB R8, [R0], #1
        SUBS R1, R1, #1
        BMI exit

        ; Case character == space
        CMP R8, R5
        MOVEQ R8, #0x20 ; space in ASCII
        ADDEQ R7, R7, #1
        STRBEQ R8, [R2, #1]
        BEQ decode

        ; Case character == sentence_end
        CMP R8, R6
        BEQ decode

        ; Case character == change_symbol
        CMP R8, R4
        BEQ decode

        LSL R8, R10 ; saves the bytes read in a 32 bit register
        ORR R9, R9, R8

        SUB R10, R10, #8
        CMP R10, #-8
        LDRBMI R11, [R0, #-1] ; fifth byte to read implies the symbol is a number
        BMI decode_number

        B main_loop

exit
        MOV  R0, R7 ; save return value in R0
        POP {R2, R4-R8,R10-R11,pc} ; restore volatile registers

decode
        CMP R10, #-16
        BGE decode_letter
        B decode_number

decode_letter
        PUSH {R2, R9}
        PUSH {R4, R5, R6}
        LDR R5, [SP, #12] ; output
        LDR R4, [SP, #16] ; letter to decode

        LDR R6, =letters
loop_alphabet
        LDR R7, [R6], #8

        CMP R4, R7
        LDREQ R4, [R6, #-4]
        STRBEQ R4, [R5], #1
        
        BNE loop_alphabet
        POP {R2, R4, R5, R6, R9}
        CMP R8, R5 ; increment the pointer if we got to decode from a SPACE
        ADDEQ R2, R2, #1
        ADD R7, R7, #1
        B start


decode_number
        PUSH {R2, R9}
        PUSH {R4, R5, R6, R7}
        LDR R5, [SP, #16] ; output
        LDR R4, [SP, #20] ; number to decode
        LDR R6, [SP, #24] ; 5th byte

        CMP R6, #0x31
        BNE five_to_nine

        LDR R7,=0x31313131
        CMP R4, R7
        MOVEQ R6, #0x30 ; 0
        STRBEQ R6, [R5], #1

        LDR R7,=0x30313131
        CMP R4, R7
        MOVEQ R6, #0x31 ; 1
        STRBEQ R6,[R5],#1
        BEQ end_number_decode
        
        LDR R7, =0x30303131
        CMP R4, R7
        MOVEQ R6, #0x32 ; 2
        STRBEQ R6, [R5], #1
        BEQ end_number_decode
        
        LDR R7,=0x30303031
        CMP R4, R7
        MOVEQ R6, #0x33 ; 3
        STRBEQ R6, [R5], #1
        BEQ end_number_decode
        
        LDR R7, =0x30303030
        CMP R4, R7
        CMPEQ R6, #0x31
        MOVEQ R6, #0x34 ; 4
        STRBEQ R6, [R5], #1
        BEQ end_number_decode

five_to_nine
        LDR R7, =0x30303030
        CMP R4, R7
        MOVEQ R6, #0x35 ; 5
        STRBEQ R6, [R5], #1
        BEQ end_number_decode
        
        LDR R7, =0x31303030
        CMP R4, R7
        MOVEQ R6, #0x36 ; 6
        STRBEQ R6, [R5], #1
        BEQ end_number_decode
        
        LDR R7, =0x31313030
        CMP R4, R7
        MOVEQ R6, #0x37 ; 7
        STRBEQ R6, [R5], #1
        BEQ end_number_decode
        
        LDR R7, =0x31313130
        CMP R4, R7
        MOVEQ R6, #0x38 ; 8
        STRBEQ R6, [R5], #1
        BEQ end_number_decode
        
        LDR R7, =0x31313131
        CMP R4, R7
        MOVEQ R6, #0x39 ; 9
        STRBEQ R6, [R5], #1

end_number_decode
        POP {R2, R4, R5, R6, R7, R9, R11}
        ADD R7, R7, #1
        B start

        LTORG

letters DCD 0x30310000, 0x41, 0x31303030, 0x42, 0x31303130, 0x43, 0x31303000, 0x44
        DCD 0x30000000, 0x45, 0x30303130, 0x46, 0x31313000, 0x47, 0x30303030, 0x48
        DCD 0x30300000, 0x49, 0x30313131, 0x4A, 0x31303100, 0x4B, 0x30313030, 0x4C
        DCD 0x31310000, 0x4D, 0x31300000, 0x4E, 0x31313100, 0x4F, 0x30313130, 0x50
        DCD 0x31313031, 0x51, 0x30313000, 0x52, 0x30303000, 0x53, 0x31000000, 0x54
        DCD 0x30303100, 0x55, 0x30303031, 0x56, 0x30313100, 0x57, 0x31303031, 0x58
        DCD 0x31303131, 0x59, 0x31313030, 0x5A

        END
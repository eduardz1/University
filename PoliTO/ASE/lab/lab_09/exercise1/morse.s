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

        ; save volatile registers
        PUSH {R2, R4-R8, R10-R11, lr}

        MOV R7, #0   ; index for input vector
        MOV R9, #0   ; tmp
        MOV R10, #24 ; used to shift

        LDR   R4, [R12]     ; change_symbol
        LDR   R5, [R12, #4] ; space
        LDR   R6, [R12, #8] ; sentence_end

LP_OUTER    LDRB R8,[r0],#1

        ; Case character == space
        CMP R8, R5
        BEQ decode

        ; Case character == senetcne_end
        CMP R8, R6
        BEQ handle_dcd

        ; Case character == change_symbol
        CMP R8, R4
        BEQ handle_dcd

        LSL R8,R10; byte read << R10
        ORR R9,R9,R8;R9= R9 | (R8<<R10). 
        
        SUB R10, R10, #8
        CMP R10, #-8
        LDRBMI R11,[r0,#-1];the symbol is a letter bc it has 5 characters
        BMI decode2
        B LP_OUTER
                
handle_dcd 		CMP R10,#-16
                BGE decode;if shift>=-8, then we have to decode a letter,otherwise a number
                B decode2
                
decode2;for numbers 
                PUSH{R2,R9,R11}
                B dcd_number
exit2			POP{R2,R9,R11}
                
                ADD R2,R2,#1
                ADD R7,R7,#1
                LDRB R9,[R0]
                CMP R9,#0x34
                BEQ end_fx
                ADD R0,R0,#1;I have to skip the end letter symbol 
                
                MOV R9,#0
                MOV R10,#24
                CMP R8,R6;byte read = end sentece

                BEQ end_fx
                B LP_OUTER
                
decode			PUSH{R2,R9}
                B dcd_letter
exit			POP{R2,R9}
                CMP R8,#0x33
                ADD R2,R2,#1
                ADD R7,R7,#1
                MOVEQ R8,#0x20
                ADDEQ R7,R7,#1
                STRBEQ R8,[R2],#1
                MOV R9,#0
                MOV R10,#24
                CMP R8,R6;byte read = end sentece
                BEQ end_fx
                B LP_OUTER
                
                ; setup a value for R0 to return
end_fx			MOV	  R0, R7
                ; restore volatile registers
                POP {R2}
                POP {r4-r8,r10-r11,pc}
                
                    
dcd_number 	     
                PUSH{R4,R5,R6,R7}
                LDR R5,[SP,#16];vec output
                LDR R4,[SP,#20];number to decode
                LDR R6,[SP,#24];extra byte for number
                
                LDR R7,=0x30313131
                CMP R4,R7;1= 0111 1
                CMPEQ R6,#0x31
                MOVEQ R6,#0x31;ASCII for 1
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x30303131
                CMP R4,R7;2= 0011 1
                CMPEQ R6,#0x31
                MOVEQ R6,#0x32;ASCII for 2
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x30303031
                CMP R4,R7;3=0001 1
                CMPEQ R6,#0x31
                MOVEQ R6,#0x33;ASCII for 3
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x30303030
                CMP R4,R7;4=0000 1
                CMPEQ R6,#0x31
                MOVEQ R6,#0x34;ASCII for 4
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x30303030
                CMP R4,R7;5=0000 0
                CMPEQ R6,#0x30
                MOVEQ R6,#0x35;ASCII for 5
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x31303030
                CMP R4,R7;6=1000 0
                CMPEQ R6,#0x30
                MOVEQ R6,#0x36;ASCII for 6
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x31313030
                CMP R4,R7;7=1100 0
                CMPEQ R6,#0x30
                MOVEQ R6,#0x37;ASCII for 7
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x31313130
                CMP R4,R7;8=1110 0
                CMPEQ R6,#0x30
                MOVEQ R6,#0x38;ASCII for 8
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x31313131
                CMP R4,R7;9=1111 0
                CMPEQ R6,#0x30
                MOVEQ R6,#0x39;ASCII for 9
                STRBEQ R6,[R5],#1
                BEQ end2
                
                LDR R7,=0x31313131
                CMP R4,R7;0=1111 1
                CMPEQ R6,#0x31
                MOVEQ R6,#0x30;ASCII for 0
                STRBEQ R6,[R5],#1
                BEQ end2
        
end2            POP{R4,R5,R6,R7}
                B exit2
            
                
dcd_letter 	
                PUSH {R4,R5,R6}
                LDR R5,[SP,#12];vec output
                LDR R4,[SP,#16];letter to decode
                
                LDR R6,=0x30310000
                CMP R4,R6;R4 is 01 aka A
                MOVEQ R4,#0x41;ASCII for A
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31303030
                CMP R4,R6;R4 is 1000 aka B
                MOVEQ R4,#0x42;ASCII for B
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31303130
                CMP R4,R6;R4 is 1010 aka C
                MOVEQ R4,#0x43;ASCII for C
                STRBEQ R4,[R5],#1
                BEQ.W end3	
                
                LDR R6,=0x31303000
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x44;ASCII for D
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30000000;R4 is 0 aka E
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x45;ASCII for E
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30303130;R4 is 0010 aka F
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x46;ASCII for F
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31313000;R4 is 110 aka G
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x47;ASCII for G
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30303030;R4 is 0000 aka H
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x48;ASCII for H
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30300000;R4 is 00 aka I
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x49;ASCII for I
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30313131;R4 is 0111 aka J
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x4A;ASCII for J
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31303100;R4 is 101 aka K
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x4B;ASCII for K
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30313030;R4 is 0100 aka L
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x4C;ASCII for L
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31310000;R4 is 11 aka M
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x4D;ASCII for M
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31300000;R4 is 10 aka N
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x4E;ASCII for N
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31313100;R4 is 111 aka O
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x4F;ASCII for O
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30313130;R4 is 0110 aka P
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x50;ASCII for P
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31313031;R4 is 1101 aka Q
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x51;ASCII for Q
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30313000;R4 is 010 aka R
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x52;ASCII for R
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30303000;R4 is 000 aka S
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x53;ASCII for S
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31000000;R4 is 1 aka T
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x54;ASCII for T
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30303100;R4 is 001 aka U
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x55;ASCII for U
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30303031;R4 is 0001 aka V
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x56;ASCII for V
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x30313100;R4 is 011 aka W
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x57;ASCII for W
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31303031;R4 is 1001 aka X
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x58;ASCII for X
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31303131;R4 is 1011 aka Y
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x59;ASCII for Y
                STRBEQ R4,[R5],#1
                BEQ.W end3
                
                LDR R6,=0x31313030;R4 is 1100 aka Z
                CMP R4,R6;R4 is 100 aka D
                MOVEQ R4,#0x5A;ASCII for Z
                STRBEQ R4,[R5],#1
                BEQ.W end3

end3			POP {R4,R5,R6}	
                B exit
            
        END
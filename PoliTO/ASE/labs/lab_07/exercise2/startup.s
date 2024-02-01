;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF

                AREA    |variables|, DATA, READWRITE

_Calories_food_tmp	    SPACE 56
_Calories_sport_tmp		SPACE 24
  
_Calories_food_ordered		SPACE 28
_Calories_sport_ordered		SPACE 12 
 
					
                AREA    |.text|, CODE, READONLY, align=3

Days            RN      1
Calories_food   RN      2
Calories_sport  RN      3
Num_days        RN      4
Num_days_sport  RN      5
i               RN      6
j               RN      10
Result          RN      11

; Bubble Sort assembly implementation
; R0: Array source, R1: Array size, R2: Array destination
Sort            PROC
                EXPORT  Sort             [WEAK]                                            
                
                PUSH {R0-R11, LR}
                
Sort_next       
                MOV R3, #0 ; R3 = current elem number
                MOV R11, #0 ; number of swaps
Sort_loop
                ADD R4, R3, #1 ; R4 = next elem number
                CMP R4, R1
                BGE Sort_check ; check if any swap has been made when we reach the end
				
				ADD R9, R0, R3, LSL #3 ; calculate offset from R0
				LDRD r5, r6, [r9] 
				
				ADD R10, R0, R4, LSL #3 ; calculate offset from R0
				LDRD r7, r8, [r10]
                
                CMP R6, R8
				
				STRDLT R7, R8, [R9]
				STRDLT R5, R6, [R10]
                
                ADDLT R11, R11, #1
                MOV R3, R4
                B Sort_loop
Sort_check
                CMP R11, #0 ; check if any swap occurred
                SUBGT R1, R1, #1 ; skip last value in the next loop
                
                LDR R7, [R0, R1, LSL #3]
                STRGT R7, [R2, R1, LSL #2]
                BGT Sort_next
Sort_end
                CMP R1, #0 ; check if there are still values left to save
                SUBGT R1, R1, #1
                LDRGT R7, [R0, R1, LSL #3]
                STRGT R7, [R2, R1, LSL #2]
                BGT Sort_end
                
                POP {R0-R11, PC}
                
                BX      LR
                ENDP

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]                                            

                ; Copy the content from the Calories_food and Calories_sport
                ; arrays to the Calories_food_ordered and Calories_sport_ordered
                ; arrays
                
                LDR R3, =_Calories_sport
                LDR R0, =_Calories_sport_tmp
                LDM R3, {R3-R8} ; loads the values of Calories_sport in R4-R9
                STM R0, {R3-R8} ; stores the values of Calories_sport in Calories_sport_tmp
                   
                LDR R4, =_Num_days_sport
                LDRB R1, [R4]
                LDR R2, =_Calories_sport_ordered
                BL      Sort ; sort(source_array, size, dest_array)

                LDR R4, =_Calories_food
                LDR R0, =_Calories_food_tmp
                LDM R4!, {R5-R12} ; loads the values of the first 8 elements of Calories_food in R4-R11
                STM R0!, {R5-R12} ; stores the values of the first 8 elements of Calories_food in Calories_food_tmp
                LDM R4, {R5-R10} ; loads the values of the last 6 elements of Calories_food in R4-R9
                STM R0, {R5-R10} ; stores the values of the last 6 elements of Calories_food in Calories_food_tmp

                LDR R0, =_Calories_food_tmp
                LDR R5, =_Num_days
                LDRB R1, [R5]
                LDR R2, =_Calories_food_ordered
                BL      Sort

                
                MOV     i, #0 ; initialize loop index
                LDR     Result, =MAX_INT
                LDR     Result, [Result]

                ; loads the array indeces in the registers
				LDR     Days, =_Days
                LDR     Calories_sport, =_Calories_sport
                LDR     Num_days, =_Num_days
				LDRB   Num_days, [Num_days]
				LDR     Num_days_sport, =_Num_days_sport
				LDRB   Num_days_sport, [Num_days_sport] 

loop_days       CMP    Num_days, i
                BLE     end_loop_days
                
                LDRB R7, [Days], #1
				LDR Calories_food, =_Calories_food

loop_calories_food LDR R8, [Calories_food], #8
                CMP R7, R8
                BNE loop_calories_food

                LDR R12, [Calories_food, #-4] ; sotres the calories value of food in R12 without updating it
				LDR Calories_sport, =_Calories_sport
				MOV     j, #0 ; initialize loop index
				
loop_calories_sport CMP j, Num_days_sport
                BPL end_loop_calories_sport

                LDR R9, [Calories_sport], #8
                ADD j, j, #1
                CMP R9, R8
                BNE loop_calories_sport
                
                LDR R9, [Calories_sport, #-4] ;stores the calories value of sport in R9 without updating it
                SUB R12, R12, R9

end_loop_calories_sport

end_loop_calories_food
				
				CMP R12, Result
                MOVLT Result, R12
				
				ADD i, i, #1
                B       loop_days
end_loop_days         

stop            B       stop
				
                ENDP
                    

                LTORG


MY_DATA         SPACE 4096

_Days				DCB 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07

_Calories_food 	 	DCD 0x06, 1300, 0x03, 1700, 0x02, 1200, 0x04, 1900
                    DCD 0x05, 1110, 0x01, 1670, 0x07, 1000

_Calories_sport	 	DCD 0x02, 500, 0x05, 800, 0x06, 400

_Num_days	 		DCB 7
_Num_days_sport		DCB 3

MAX_INT             DCD 0x7FFFFFFF

 
; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END

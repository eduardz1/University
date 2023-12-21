/*********************************************************************************************************
**--------------File
*Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "../led/led.h"
#include "lpc17xx.h"
#include "timer.h"

int intCount = 0;
int i;
const int X = 1000000;

/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
extern unsigned char led_value; /* defined in funct_led
                                 */
void TIMER0_IRQHandler(void) {
  static uint8_t position = 7;
  LED_Off(position);
  if (position == 7)
    position = 2;
  else
    position++;
  LED_On(position);
  /* alternatively to LED_On and LED_off try to use LED_Out */
  // LED_Out((1<<position)|(led_value & 0x3));
  /* LED_Out is CRITICAL due to the shared led_value variable */
  /* LED_Out MUST NOT BE INTERRUPTED */

  LPC_TIM0->IR = 1; /* clear interrupt flag */
  return;
}

/******************************************************************************
** Function name:		Timer1_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER1_IRQHandler(void) {
  LPC_TIM1->IR = 1; /* clear interrupt flag */
  return;
}

/******************************************************************************
** Function name:		Timer3_IRQHandler
**
** Descriptions:		Timer/Counter 2 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER2_IRQHandler(void) {
  intCount++;
  LPC_TIM2->IR = 1; /* clear interrupt flag */
  enable_timer(2);
  return;
}

/******************************************************************************
** Function name:		Timer3_IRQHandler
**
** Descriptions:		Timer/Counter 3 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER3_IRQHandler(void) {
  intCount = 0;

  for (i = 0; i < X; i++) {
    __ASM("nop");
  }

  if (intCount > 255)
    LED_Out(255);
  else
    LED_Out(intCount);

  LPC_TIM3->IR = 1; /* clear interrupt flag */
  enable_timer(3);
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/

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
#include <stdbool.h>
#include <stdlib.h>

extern unsigned char led_value; /* defined in funct_led */
extern int RES;
bool on = false;

/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER0_IRQHandler(void) {
  LED_Out(0);

  NVIC_EnableIRQ(EINT0_IRQn);
  NVIC_EnableIRQ(EINT2_IRQn);

  reset_timer(0);
  disable_timer(0);

  LPC_TIM0->IR |= 1; /* clear interrupt flag */
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
  LED_Out(on == true ? RES : 0);
  on = !on;

  LPC_TIM1->IR |= 1; /* clear interrupt flag */

  enable_timer(1);
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/

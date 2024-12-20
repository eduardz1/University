/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose:
 *		to control led11 and led 10 through EINT buttons (similarly to
 *project 03_) to control leds9 to led4 by the timer handler (1 second -
 *circular cycling) Note(s): this version supports the LANDTIGER Emulator
 * Author: 	Paolo BERNARDI - PoliTO - last modified 15/12/2020
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2017 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/

#include "LPC17xx.H" /* LPC17xx definitions                */
#include "button_EXINT/button.h"
#include "led/led.h"
#include "timer/timer.h"
#include <stdio.h>

/* Led external variables from funct_led */
extern unsigned char led_value; /* defined in lib_led */
#ifdef SIMULATOR
extern uint8_t
    ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to
               // find the symbol (can be placed also inside system_LPC17xx.h
               // but since it is RO, it needs more work)
#endif
/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main(void) {

  SystemInit();  /* System Initialization (i.e., PLL)  */
  LED_init();    /* LED Initialization                 */
  BUTTON_init(); /* BUTTON Initialization              */

  init_timer(2, 0x455BA); // 0.015625s
  init_timer(3, 0x2FAF080);

  enable_timer(0);
  enable_timer(2);
  enable_timer(3);

  LPC_SC->PCON |= 0x1; /* power-down mode */
  LPC_SC->PCON &= 0xFFFFFFFFD;

  while (1) { /* Loop forever                       */
    __ASM("wfi");
  }
}

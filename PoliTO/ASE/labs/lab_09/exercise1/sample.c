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

#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "timer/timer.h"

extern unsigned char led_value; /* defined in lib_led */
uint8_t input[100] = {0, 0, 0, 0, 2, 1, 1, 1, 2, 0, 1, 0, 0, 2, 0, 1,
                      3, 1, 1, 2, 0, 0, 1, 2, 1, 0, 2, 1, 0, 0, 2, 1,
                      1, 1, 3, 0, 1, 1, 1, 1, 2, 0, 0, 1, 1, 1, 4};

char vector[100];
char output[100] = {'\0'}; // initializes array with null (end of string)

extern int length;
extern int RES;
extern int translate_morse(const char *input, const int input_length,
                           char *output, const int output_length,
                           const char change_symbol, const char space,
                           const char sentence_end);

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

  //init_timer(0, 0x47868C0);
	init_timer(0, 0x1); // debug
  init_timer(1, 0xBEBC20); // 0.5sec (2Hz)

  LPC_SC->PCON |= 0x1; /* power-down	mode
                        */
  LPC_SC->PCON &= 0xFFFFFFFFD;

  while (1) { /* Loop forever                       */
    __ASM("wfi");
  }
}

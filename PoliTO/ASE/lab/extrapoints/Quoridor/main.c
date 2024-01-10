/******************************Copyright*(c)************************************
 **
 **                       http://www.powermcu.com
 **
 **--------------File Info------------------------------------------------------
 ** File name:               main.c
 ** Descriptions:            The GLCD application function
 **
 **-----------------------------------------------------------------------------
 ** Created by:              AVRman
 ** Created date:            2010-11-7
 ** Version:                 v1.0
 ** Descriptions:            The original version
 **
 **-----------------------------------------------------------------------------
 ** Modified by:             Paolo Bernardi
 ** Modified date:           03/01/2020
 ** Version:                 v2.0
 ** Descriptions:            basic program for LCD and Touch Panel teaching
 **
 ******************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "GLCD/GLCD.h"
#include "LPC17xx.h"
#include "RIT/RIT.h"
#include "button_EXINT/button.h"
#include "common.h"
#include "game/game.h"
#include "joystick/joystick.h"

#define RIT_TIME 0x004C4B40 // 50ms polling

#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the
                          // emulator to find the symbol (can be placed also
                          // inside system_LPC17xx.h but since it is RO, it
                          // needs more work)
#endif

int main(void)
{
    SystemInit(); /* System Initialization (i.e., PLL)  */
    LCD_Initialization();
    BUTTON_init();
    joystick_init();

    init_RIT(RIT_TIME); /* Poll joystick every 50ms */

    game_init();

    // snprintf(string, sizeof(string), "%#08x", board.moves->data[0]);
    // GUI_Text(0, 280, (uint8_t *)string, Blue, White);
    // LCD_DrawLine(0, 0, 200, 200, White);
    // init_timer(0, 0x1312D0 );                       /* 50ms * 25MHz
    // = 1.25*10^6 = 0x1312D0
    // */
    // init_timer(0, 0x6108 );                        /* 1ms * 25MHz = 25*10^3
    // = 0x6108
    // */
    // init_timer(0, 0x4E2 );                           /* 500us * 25MHz
    // = 1.25*10^3 = 0x4E2
    // */
    // init_timer(0, 0xC8); /* 8us * 25MHz = 200 ~= 0xC8 */

    // enable_timer(0);

    // LPC_SC->PCON |= 0x1; /* power-down	mode */
    // LPC_SC->PCON &= ~(0x2);
}

/*********************************************************************************************************
      END FILE
*********************************************************************************************************/

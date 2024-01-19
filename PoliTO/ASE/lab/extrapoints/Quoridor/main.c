#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6000000)
//   implicit conversion changes signedness: 'int' to 'unsigned int'
#pragma clang diagnostic ignored "-Wsign-conversion"
#endif

#include "CAN/CAN.h"
#include "GLCD/GLCD.h"
#include "LPC17xx.h"
#include "RIT/RIT.h"
#include "button_EXINT/button.h"
#include "common.h"
#include "game/game.h"
#include "joystick/joystick.h"
#include <stdlib.h>
#include <time.h>

#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the
                          // emulator to find the symbol (can be placed also
                          // inside system_LPC17xx.h but since it is RO, it
                          // needs more work)
#endif

int main(void)
{
    SystemInit(); /* System Initialization (i.e., PLL)  */
    srand(5);     // FIXME: everything breaks if I do this
    LCD_Initialization();
    CAN_Init();
    BUTTON_init();
    joystick_init();

    init_RIT(RIT_TIME); /* Poll joystick every 50ms */

    game_init();

    LPC_SC->PCON |= 0x1; /* power-down	mode */
    LPC_SC->PCON &= ~(0x2);

    while (true)
        __ASM("wfi");
}

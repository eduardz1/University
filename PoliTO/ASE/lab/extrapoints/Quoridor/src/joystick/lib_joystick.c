#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6000000)
//   implicit conversion changes signedness: 'int' to 'unsigned int'
#pragma clang diagnostic ignored "-Wsign-conversion"
#endif

/*********************************************************************************************************
**--------------File
*Info---------------------------------------------------------------------------------
** File name:           joystick.h
** Last modified Date:  2018-12-30
** Last Version:        V1.00
** Descriptions:        Atomic joystick init functions
** Correlated files:    lib_joystick.c, funct_joystick.c
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/

#include "joystick.h"
#include "LPC17xx.h"

/*----------------------------------------------------------------------------
  Function that initializes joysticks and switch them off
 *----------------------------------------------------------------------------*/

void joystick_init(void)
{
    /* joystick Select functionality */
    LPC_PINCON->PINSEL3 &= ~(3 << 18); // PIN mode GPIO (00b value per P1.25)
    LPC_GPIO1->FIODIR &= ~(1 << 25); // P1.25 Input (joysticks on PORT1 defined
                                     // as Input)
}

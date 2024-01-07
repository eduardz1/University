/*********************************************************************************************************
**--------------File
*Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "../game/game.h"
#include "../led/led.h"
#include "RIT.h"
#include "lpc17xx.h"
#include <stdint.h>

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

volatile int down = 0;
extern char led_value;
extern uint8_t current_player;
extern enum Mode mode;
extern enum Direction direction;

__attribute__((always_inline)) void
do_update(const uint8_t x, const uint8_t y, const int up, const int right)
{
    update_selector update = mode == WALL_PLACEMENT ? update_wall_selector :
                                                      update_player_selector;

    if (x < 0 || x > BOARD_SIZE - 1 || y < 0 || y > BOARD_SIZE - 1) return;

    update(x, y, up, right); // FIXME: logic here does not make sense, x and y
                             // need to be updated to reflect the last position
                             // of the selector
}

/**
 * @brief Tracks joystick movements and updates the player position accordingly
 *
 */
void RIT_IRQHandler(void)
{
    static int j_select = 0;
    static int j_down = 0;
    static int j_left = 0;
    static int j_right = 0;
    static int j_up = 0;

    static uint8_t x, y;

    static bool flag = true;
    if (flag)
    {
        find_player(current_player, &x, &y);
        flag = false;
    }

    if (!(LPC_GPIO1->FIOPIN & (1 << 25)) && ++j_select == 1) /* SELECT */
    {
        // TODO: manage invalid move
        if (mode == PLAYER_MOVE)
            move_player(current_player, j_up, j_down, j_left, j_right);
        else
            place_wall(current_player, j_up, j_down, j_left, j_right);

        mode = !mode;
        flag = true;

        j_up = 0;
        j_down = 0;
        j_left = 0;
        j_right = 0;
    }
    else
    {
        j_select = 0;
    }

    if (!(LPC_GPIO1->FIOPIN & (1 << 26))) /* DOWN */
        do_update(x, y, ++j_down - j_up, j_right - j_left);
    if (!(LPC_GPIO1->FIOPIN & (1 << 27))) /* LEFT */
        do_update(x, y, j_down - j_up, j_right - ++j_left);
    if (!(LPC_GPIO1->FIOPIN & (1 << 28))) /* RIGHT */
        do_update(x, y, j_down - j_up, ++j_right - j_left);
    if (!(LPC_GPIO1->FIOPIN & (1 << 29))) /* UP */
        do_update(x, y, j_down - ++j_up, j_right - j_left);

    LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
}

/******************************************************************************
**                            End Of File
******************************************************************************/

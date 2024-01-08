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
extern enum Player current_player;
extern enum Mode mode;
extern enum Direction direction;
extern struct PlayerInfo red;
extern struct PlayerInfo white;

__attribute__((always_inline)) void do_update(const int up, const int right)
{
    update_selector update = mode == WALL_PLACEMENT ? update_wall_selector :
                                                      update_player_selector;

    update(up, right, true); // FIXME: logic here does not make sense, x and y
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

    if ((LPC_GPIO1->FIOPIN & (1 << 25)) ==
        0 /* TODO: what is this for? && ++j_select == 1*/) /* SELECT */
    {
        uint8_t x = j_right - j_left;
        uint8_t y = j_down - j_up;
        union Move res;

        if (mode == PLAYER_MOVE)
        {
            update_player_selector(0, 0, false);

            x += current_player == RED ? red.x : white.x;
            y += current_player == RED ? red.y : white.y;

            CLAMP(x, 0, BOARD_SIZE - 1)
            CLAMP(y, 0, BOARD_SIZE - 1)

            res = move_player(x, y);
        }
        else
        {
            update_wall_selector(0, 0, false);

            x += (BOARD_SIZE >> 1);
            y += (BOARD_SIZE >> 1);

            CLAMP(x, 0, BOARD_SIZE - 2)
            CLAMP(y, 0, BOARD_SIZE - 2)

            res = place_wall(x, y);
        }

        if (res.as_uint32_t == UINT32_MAX) // TODO: invalid move
        {}
        else
        {
            current_player = !current_player;
            mode = PLAYER_MOVE;
            manage_turn();

            j_up = 0;
            j_down = 0;
            j_left = 0;
            j_right = 0;
        }
    }
    else
    {
        j_select = 0;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 26)) == 0) /* DOWN */
    {
        do_update(1, 0);
        ++j_down;
    }
    if ((LPC_GPIO1->FIOPIN & (1 << 27)) == 0) /* LEFT */
    {
        do_update(0, -1);
        ++j_left;
    }
    if ((LPC_GPIO1->FIOPIN & (1 << 28)) == 0) /* RIGHT */
    {
        do_update(0, 1);
        ++j_right;
    }
    if ((LPC_GPIO1->FIOPIN & (1 << 29)) == 0) /* UP */
    {
        do_update(-1, 0);
        ++j_up;
    }

    LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
}

/******************************************************************************
**                            End Of File
******************************************************************************/

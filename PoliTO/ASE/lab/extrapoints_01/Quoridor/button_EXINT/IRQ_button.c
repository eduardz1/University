#include "../game/game.h"
#include "button.h"
#include "lpc17xx.h"

extern int down;
extern enum Direction direction;
extern enum Mode mode;

extern enum Player current_player;
extern struct PlayerInfo red;
extern struct PlayerInfo white;

// FIXME: erase sprites when button 1 and 2 are pressed

#define CLEAR_PENDING_INTERRUPT(n) LPC_SC->EXTINT &= (1 << n);

void EINT0_IRQHandler(void) /* INT0 */
{
    CLEAR_PENDING_INTERRUPT(0)
}

void EINT1_IRQHandler(void) /* KEY1 */ // TODO: use LEDs for counting the walls
{
    if (mode == PLAYER_MOVE)
    {
        if (current_player == RED)
        {
            if (red.wall_count == 0)
            {
                // TODO: error message
            }
            else
            {
                mode = WALL_PLACEMENT;
            }
        }
        else
        {
            if (white.wall_count == 0)
            {
                // TODO: error message
            }
            else
            {
                mode = WALL_PLACEMENT;
            }
        }
    }
    else
    {
        mode = PLAYER_MOVE;
    }
    CLEAR_PENDING_INTERRUPT(1)
}

void EINT2_IRQHandler(void) /* KEY2 */
{
    direction = !direction;
    CLEAR_PENDING_INTERRUPT(2)
}

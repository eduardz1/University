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
                clear_highlighted_moves();
                update_player_selector(0, 0, false);
                update_wall_selector(0, 0, true);
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
                clear_highlighted_moves();
                update_player_selector(0, 0, false);
                update_wall_selector(0, 0, true);
                mode = WALL_PLACEMENT;
            }
        }
    }
    else
    {
        // clear wall selector
        update_wall_selector(0, 0, false);
        update_player_selector(0, 0, true);
        highlight_possible_moves();
        mode = PLAYER_MOVE;
    }
    CLEAR_PENDING_INTERRUPT(1)
}

void EINT2_IRQHandler(void) /* KEY2 */
{
    direction = !direction;
    update_wall_selector(0, 0, true);
    CLEAR_PENDING_INTERRUPT(2)
}

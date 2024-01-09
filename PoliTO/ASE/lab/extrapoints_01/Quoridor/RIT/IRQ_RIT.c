#include "../GLCD/GLCD.h"
#include "../game/game.h"
#include "../game/graphics.h"
#include "../imgs/sprites.h"
#include "../led/led.h"
#include "RIT.h"
#include "lpc17xx.h"
#include <stdint.h>

extern enum Player current_player;
extern enum Mode mode;
extern enum Direction direction;
extern struct PlayerInfo red;
extern struct PlayerInfo white;
extern struct Board board;

__attribute__((always_inline)) void do_update(const int up, const int right)
{
    update_selector update = mode == WALL_PLACEMENT ? update_wall_selector :
                                                      update_player_selector;
    update(up, right, true);
}

void RIT_IRQHandler(void)
{
    static union Move error_move = {
        .direction = 1, .player_id = 0, .type = 0, .x = 0, .y = 0};
    static uint32_t counter = (20 * 1000) / 50; // 20 ms/50ms --> 400 iterations

    if (counter-- % 20) // 20 iterations --> 1 second
        refresh_info_panel(counter / 20);

    if (counter == 0)
    {
        error_move.player_id = current_player;

        dyn_array_push(board.moves, error_move.as_uint32_t);
        change_turn();
        counter = (20 * 1000) / 50;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 25)) == 0) /* SELECT */
    {
        struct Coordinate offset;
        union Move res;

        if (mode == PLAYER_MOVE)
        {
            offset = update_player_selector(0, 0, false);
            res = move_player(offset.x, offset.y);
        }
        else
        {
            offset = update_wall_selector(0, 0, false);
            res = place_wall(offset.x, offset.y);
        }

        if (res.as_uint32_t == UINT32_MAX)
        {
            write_invalid_move();

            mode = PLAYER_MOVE;
            update_player_selector(0, 0, true);
        }
        else
        {
            change_turn();
            counter = (20 * 1000) / 50;
        }
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 26)) == 0) do_update(1, 0);  /* DOWN */
    if ((LPC_GPIO1->FIOPIN & (1 << 27)) == 0) do_update(0, -1); /* LEFT */
    if ((LPC_GPIO1->FIOPIN & (1 << 28)) == 0) do_update(0, 1);  /* RIGHT */
    if ((LPC_GPIO1->FIOPIN & (1 << 29)) == 0) do_update(-1, 0); /* UP */

    LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
}

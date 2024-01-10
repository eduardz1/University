#include "../GLCD/GLCD.h"
#include "../common.h"
#include "../game/game.h"
#include "../game/graphics.h"
#include "../imgs/sprites.h"
#include "../led/led.h"
#include "RIT.h"
#include "LPC17xx.h"
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
#ifdef SIMULATOR
    static union Move error_move = {.direction = HORIZONTAL,
                                    .player_id = RED,
                                    .type = PLAYER_MOVE,
                                    .x = 0,
                                    .y = 0};
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
#else
    static int j_select = 0;
    static int j_down = 0;
    static int j_up = 0;
    static int j_left = 0;
    static int j_right = 0;

    static int button1 = 0;
    static int button2 = 0;

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
        j_select++;
        switch (j_select)
        {
        case 1:
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
            break;

        default: break;
        }
    }
    else
    {
        j_select = 0;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 26)) == 0) /* DOWN */
    {
        j_down++;
        switch (j_down)
        {
        case 1: do_update(1, 0); break;
        default: break;
        }
    }
    else
    {
        j_down = 0;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 27)) == 0) /* LEFT */
    {
        j_left++;
        switch (j_left)
        {
        case 1: do_update(0, -1); break;
        default: break;
        }
    }
    else
    {
        j_left = 0;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 28)) == 0)
    { /* RIGHT */
        j_right++;
        switch (j_right)
        {
        case 1: do_update(0, 1); break;
        default: break;
        }
    }
    else
    {
        j_right = 0;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 29)) == 0) /* UP */
    {
        j_up++;
        switch (j_up)
        {
        case 1: do_update(-1, 0); break;
        default: break;
        }
    }
    else
    {
        j_up = 0;
    }

    button1++;
    if ((LPC_GPIO2->FIOPIN & (1 << 11)) == 0)
    {
        reset_RIT();
        switch (button1)
        {
        case 1:
            if (mode == PLAYER_MOVE)
            {
                if (current_player == RED)
                {
                    if (red.wall_count == 0)
                    {
                        LCD_write_text(2,
                                       9,
                                       " No walls available, ",
                                       Black,
                                       TRANSPARENT,
                                       1);
                        LCD_write_text(2,
                                       9 + 8 + 4,
                                       "   move the token    ",
                                       Black,
                                       TRANSPARENT,
                                       1);
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
                        LCD_write_text(2,
                                       9,
                                       " No walls available, ",
                                       Black,
                                       TRANSPARENT,
                                       1);
                        LCD_write_text(2,
                                       9 + 8 + 4,
                                       "   move the token    ",
                                       Black,
                                       TRANSPARENT,
                                       1);
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

            break;
        default: break;
        }
    }
    else
    { /* button released */
        button1 = 0;
        reset_RIT();
        NVIC_EnableIRQ(EINT1_IRQn);       /* disable Button interrupts			*/
        LPC_PINCON->PINSEL4 |= (1 << 22); /* External interrupt 0 pin selection
                                           */
    }

    button2++;
    if ((LPC_GPIO2->FIOPIN & (1 << 12)) == 0)
    {
        reset_RIT();
        switch (button2)
        {
        case 1:
            direction = !direction;
            update_wall_selector(0, 0, true);
            break;
        default: break;
        }
    }
    else
    { /* button released */
        button2 = 0;
        reset_RIT();
        NVIC_EnableIRQ(EINT2_IRQn);       /* disable Button interrupts			*/
        LPC_PINCON->PINSEL4 |= (1 << 21); /* External interrupt 0 pin selection
                                           */
    }
#endif

    LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
}

#pragma diag_suppress 68 // integer conversion resulted in a change of sign

#include "../GLCD/GLCD.h"
#include "../common.h"
#include "../game/game.h"
#include "../game/graphics.h"
#include "../imgs/sprites.h"
#include "../led/led.h"
#include "LPC17xx.h"
#include "RIT.h"
#include <stdint.h>

extern enum Player current_player;
extern enum Mode mode;
extern enum Direction direction;
extern struct PlayerInfo red;
extern struct PlayerInfo white;
extern struct Board board;

#define TURN_INTERVAL 20 // 20 seconds per turn
#ifdef SIMULATOR
#define RIT_SCALING_FACTOR                                                     \
    20 // simulator ~ 20 times slower than board on my machine
#else
#define RIT_SCALING_FACTOR 1
#endif

__attribute__((always_inline)) struct Coordinate
handle_update_selector(const int up, const int right, bool show)
{
    return (mode == WALL_PLACEMENT ? update_wall_selector :
            mode == PLAYER_MOVE    ? update_player_selector :
                                     update_menu_selector)(up, right, show);
}

void handle_info_panel(uint32_t *counter)
{
    if (mode != PLAYER_MOVE && mode != WALL_PLACEMENT)
        return; // game not started yet

    // refresh every second
    if ((*counter)-- % (TURN_INTERVAL / RIT_SCALING_FACTOR) == 0)
        refresh_info_panel(*counter / (TURN_INTERVAL / RIT_SCALING_FACTOR));

    if (*counter != 0) return;

    (void)dyn_array_push(board.moves,
                         (union Move){.direction = HORIZONTAL,
                                      .player_id = current_player,
                                      .type = PLAYER_MOVE,
                                      .x = 0,
                                      .y = 0}
                             .as_uint32_t);

    (void)handle_update_selector(0, 0, false);
    change_turn();
    *counter = ((TURN_INTERVAL * 1000) / RIT_MS) / RIT_SCALING_FACTOR; // reset
}

void RIT_IRQHandler(void)
{
    static struct Coordinate offset; // saves osset of current move
    static int button_1 = 0, button_2 = 0, j_select = 0, j_down = 0, j_up = 0,
               j_left = 0, j_right = 0;
    static uint32_t counter =
        ((TURN_INTERVAL * 1000) / RIT_MS) / RIT_SCALING_FACTOR;

    handle_info_panel(&counter);

    // HANDLE JOYSTICK MOVEMENT

    if ((LPC_GPIO1->FIOPIN & (1 << 25)) == 0 && ++j_select == 1)
    {
        if (mode != PLAYER_MOVE && mode != WALL_PLACEMENT)
        {
            select_menu_option(offset.y);
        }
        else
        {
            union Move res = (mode == PLAYER_MOVE ? move_player : place_wall)(
                offset.x, offset.y);

            if (res.as_uint32_t == -1)
            {
                write_invalid_move();
            }
            else
            {
                (void)handle_update_selector(0, 0, false);
                change_turn();
                counter =
                    ((TURN_INTERVAL * 1000) / RIT_MS) / RIT_SCALING_FACTOR;
            }
        }
    }
    else
    {
        j_select = 0;
    }

    if ((LPC_GPIO1->FIOPIN & (1 << 26)) == 0 && ++j_down == 1)
        offset = handle_update_selector(1, 0, true);
    else
        j_down = 0;

    if ((LPC_GPIO1->FIOPIN & (1 << 27)) == 0 && ++j_left == 1)
        offset = handle_update_selector(0, -1, true);
    else
        j_left = 0;

    if ((LPC_GPIO1->FIOPIN & (1 << 28)) == 0 && ++j_right == 1)
        offset = handle_update_selector(0, 1, true);
    else
        j_right = 0;

    if ((LPC_GPIO1->FIOPIN & (1 << 29)) == 0 && ++j_up == 1)
        offset = handle_update_selector(-1, 0, true);
    else
        j_up = 0;

    // HANDLE BUTTON PRESSES

    if ((LPC_PINCON->PINSEL4 & (1 << 22)) == 0 &&
        (LPC_GPIO2->FIOPIN & (1 << 11)) == 0 && ++button_1 == 1)
    {
        if ((current_player == RED ? red.wall_count : white.wall_count) == 0)
        {
            LCD_write_text(
                2, 9, " No walls available, ", Black, TRANSPARENT, 1);
            LCD_write_text(
                2, 9 + 8 + 4, "   move the token    ", Black, TRANSPARENT, 1);
        }
        else
        {
            if (mode == PLAYER_MOVE) clear_highlighted_moves();

            (void)handle_update_selector(0, 0, false);
            mode = mode == PLAYER_MOVE ? WALL_PLACEMENT : PLAYER_MOVE;
            offset = handle_update_selector(0, 0, true);

            if (mode == PLAYER_MOVE) highlight_possible_moves();
        }
    }
    else // button released
    {
        button_1 = 0;
        NVIC_EnableIRQ(EINT1_IRQn);       // disable Button interrupts
        LPC_PINCON->PINSEL4 |= (1 << 22); // External interrupt 0 pin selection
    }

    if ((LPC_PINCON->PINSEL4 & (1 << 24)) == 0 &&
        (LPC_GPIO2->FIOPIN & (1 << 12)) == 0 && ++button_2 == 1)
    {
        direction = direction == VERTICAL ? HORIZONTAL : VERTICAL;
        offset = update_wall_selector(0, 0, true);
    }
    else // button released
    {
        button_2 = 0;
        NVIC_EnableIRQ(EINT2_IRQn);       // disable Button interrupts
        LPC_PINCON->PINSEL4 |= (1 << 24); // External interrupt 0 pin selection
    }

    reset_RIT(); // FIXME: check if it helps avoid overflow

    LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
}

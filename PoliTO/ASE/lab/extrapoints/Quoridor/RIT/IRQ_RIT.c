#pragma diag_suppress 68 // integer conversion resulted in a change of sign

#include "../GLCD/GLCD.h"
#include "../common.h"
#include "../game/game.h"
#include "../game/graphics.h"
#include "../imgs/sprites.h"
#include "LPC17xx.h"
#include "RIT.h"
#include <stdint.h>

extern enum Player current_player;
extern enum Mode mode;
extern enum Direction direction;
extern struct PlayerInfo red;
extern struct PlayerInfo white;
extern struct Board board;

enum Joystick
{
    SELECT = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3,
    UP = 4
};

#define GPIO_DOWN(n) ((LPC_GPIO1->FIOPIN & (1 << (25 + n))) == 0)
#define BUTTON_DOWN(n)                                                         \
    ((LPC_PINCON->PINSEL4 & (1 << (20 + n * 2))) == 0 &&                       \
     (LPC_GPIO2->FIOPIN & (1 << (10 + n))) == 0)

#define TURN_INTERVAL 20 // 20 seconds per turn
#ifdef SIMULATOR
#define RIT_SCALING_FACTOR                                                     \
    20 // simulator ~ 20 times slower than board on my machine
#else
#define RIT_SCALING_FACTOR 1
#endif
#define COUNTER_VAL (((TURN_INTERVAL * 1000) / RIT_MS) / RIT_SCALING_FACTOR)

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
    *counter = COUNTER_VAL; // reset
}

static void handle_joystick_select(int *joystick,
                                   uint32_t *counter,
                                   struct Coordinate *offset)
{
    if (GPIO_DOWN(SELECT) && ++joystick[SELECT] == 1)
    {
        if (mode != PLAYER_MOVE && mode != WALL_PLACEMENT)
        {
            select_menu_option(offset->y);
        }
        else
        {
            union Move res = (mode == PLAYER_MOVE ? move_player : place_wall)(
                offset->x, offset->y);

            if (res.as_uint32_t == -1)
            {
                write_invalid_move();
            }
            else
            {
                (void)handle_update_selector(0, 0, false);
                change_turn();
                *counter = COUNTER_VAL;
            }
        }
    }
    else if (!GPIO_DOWN(SELECT))
    {
        joystick[SELECT] = 0;
    }
}

static void handle_joystick_movement(int *joystick, struct Coordinate *offset)
{
    for (uint8_t i = DOWN; i <= UP; i++)
    {
        if (GPIO_DOWN(i) && ++joystick[i] == 1)
        {
            int x = i == DOWN ? 1 : i == UP ? -1 : 0;
            int y = i == RIGHT ? 1 : i == LEFT ? -1 : 0;
            *offset = handle_update_selector(x, y, true);
        }
        else if (!GPIO_DOWN(i))
        {
            joystick[i] = 0;
        }
    }
}

void handle_joystick(uint32_t *counter, struct Coordinate *offset)
{
    static int joystick[5] = {0};

    handle_joystick_select(joystick, counter, offset);

    handle_joystick_movement(joystick, offset);
}

void handle_buttons(struct Coordinate *offset)
{
    static int button_1 = 0, button_2 = 0;

    if (BUTTON_DOWN(1) && ++button_1 == 1)
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
            *offset = handle_update_selector(0, 0, true);

            if (mode == PLAYER_MOVE) highlight_possible_moves();
        }
    }
    else if (!BUTTON_DOWN(1)) // button released
    {
        button_1 = 0;
        NVIC_EnableIRQ(EINT1_IRQn);       // disable Button interrupts
        LPC_PINCON->PINSEL4 |= (1 << 22); // External interrupt 0 pin selection
    }

    if (BUTTON_DOWN(2) && ++button_2 == 1)
    {
        direction = direction == VERTICAL ? HORIZONTAL : VERTICAL;
        *offset = update_wall_selector(0, 0, true);
    }
    else if (!BUTTON_DOWN(2)) // button released
    {
        button_2 = 0;
        NVIC_EnableIRQ(EINT2_IRQn);       // disable Button interrupts
        LPC_PINCON->PINSEL4 |= (1 << 24); // External interrupt 0 pin selection
    }
}

void RIT_IRQHandler(void)
{
    static struct Coordinate offset;       // saves offset of current move
    static uint32_t counter = COUNTER_VAL; // used as timer

    handle_info_panel(&counter);

    handle_joystick(&counter, &offset);

    handle_buttons(&offset);

    reset_RIT();            // TODO: verify if it helps avoid overflow
    LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
}

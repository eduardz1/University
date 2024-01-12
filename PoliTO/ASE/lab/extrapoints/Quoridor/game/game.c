#pragma diag_suppress 68 // integer conversion resulted in a change of sign

#include "game.h"
#include "../GLCD/GLCD.h"
#include "../RIT/RIT.h"
#include "../imgs/sprites.h"
#include "../led/led.h"
#include "../utils/dynarray.h"
#include "../utils/stack.h"
#include "graphics.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

union Move current_possible_moves[5] = {0};
enum Player current_player = WHITE;
struct Board board = {0};
enum Mode mode = PLAYER_MOVE;
enum Direction direction = VERTICAL;

struct PlayerInfo red = {RED, 3, 0, 8};
struct PlayerInfo white = {WHITE, 3, 6, 8};

void game_init(void)
{
    board.moves = dyn_array_new(0);
    draw_board();

    enable_RIT(); /* start accepting inputs */

    change_turn();

    while (true)
        __ASM("wfi");
}

void change_turn(void)
{
    current_player = current_player == RED ? WHITE : RED;
    mode = PLAYER_MOVE; // reset to default
    clear_highlighted_moves();
    LCD_draw_rectangle(2, 9, 2 + 8 * 21, 9 + 8 + 4, TABLE_COLOR);
    calculate_possible_moves();
    highlight_possible_moves(); // TODO: maybe inline
    refresh_info_panel(20);
}

void calculate_possible_moves(void)
{
    uint8_t i, x = current_player == RED ? red.x : white.x,
               y = current_player == RED ? red.y : white.y;
    union Move possible_moves[5] = {0}; // MAX number of possible moves

    for (i = 0; i < ARRAY_SIZE(possible_moves); i++)
    {
        possible_moves[i].player_id = current_player;
    }
    i = 0;

    // check left
    if (x > 0 && !board.board[x][y].walls.left)
    {
        if (board.board[x - 1][y].player_id != NONE)
        {
            if (x - 1 > 0 && !board.board[x - 1][y].walls.left)
            { // jump over left
                possible_moves[i].x = x - 2;
                possible_moves[i++].y = y;
            }
            else
            { // TODO: check if you can move diagonally even though you can jump
                if (y > 0 && !board.board[x - 1][y].walls.top)
                { // up and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y - 1;
                }
                if (y < BOARD_SIZE - 1 && !board.board[x - 1][y].walls.bottom)
                { // down and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y + 1;
                }
            }
        }
        else
        { // left
            possible_moves[i].x = x - 1;
            possible_moves[i++].y = y;
        }
    }

    // check right
    if (x < BOARD_SIZE - 1 && !board.board[x][y].walls.right)
    {
        if (board.board[x + 1][y].player_id != NONE)
        {
            if (x + 1 < BOARD_SIZE - 1 && !board.board[x + 1][y].walls.right)
            { // jump over right
                possible_moves[i].x = x + 2;
                possible_moves[i++].y = y;
            }
            else
            {
                if (y > 0 && !board.board[x + 1][y].walls.top)
                { // up and right
                    possible_moves[i].x = x + 1;
                    possible_moves[i++].y = y - 1;
                }
                if (y < BOARD_SIZE - 1 && !board.board[x + 1][y].walls.bottom)
                { // down and right
                    possible_moves[i].x = x + 1;
                    possible_moves[i++].y = y + 1;
                }
            }
        }
        else
        { // right
            possible_moves[i].x = x + 1;
            possible_moves[i++].y = y;
        }
    }

    // check top
    if (y > 0 && !board.board[x][y].walls.top)
    {
        if (board.board[x][y - 1].player_id != NONE)
        {
            if (y - 1 > 0 && !board.board[x][y - 1].walls.top)
            { // jump over top
                possible_moves[i].x = x;
                possible_moves[i++].y = y - 2;
            }
            else
            {
                if (x > 0 && !board.board[x][y - 1].walls.left)
                { // up and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y - 1;
                }
                if (x < BOARD_SIZE - 1 && !board.board[x][y - 1].walls.right)
                { // up and right
                    possible_moves[i].x = x + 1;
                    possible_moves[i++].y = y - 1;
                }
            }
        }
        else
        { // top
            possible_moves[i].x = x;
            possible_moves[i++].y = y - 1;
        }
    }

    // check bottom
    if (y < BOARD_SIZE - 1 && !board.board[x][y].walls.bottom)
    {
        if (board.board[x][y + 1].player_id != NONE)
        {
            if (y + 1 < BOARD_SIZE - 1 && !board.board[x][y + 1].walls.bottom)
            { // jump over bottom
                possible_moves[i].x = x;
                possible_moves[i++].y = y + 2;
            }
            else
            {
                if (x > 0 && !board.board[x][y + 1].walls.left)
                { // down and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y + 1;
                }
                if (x < BOARD_SIZE - 1 && !board.board[x][y + 1].walls.right)
                { // down and right
                    possible_moves[i].x = x + 1;
                    possible_moves[i++].y = y + 1;
                }
            }
        }
        else
        { // bottom
            possible_moves[i].x = x;
            possible_moves[i++].y = y + 1;
        }
    }

    for (; i < ARRAY_SIZE(possible_moves); possible_moves[i++].as_uint32_t = -1)
        ;

    memcpy(current_possible_moves, possible_moves, sizeof(possible_moves));
}

union Move move_player(const uint8_t x, const uint8_t y)
{
    union Move move = {0};
    move.x = x;
    move.y = y;
    move.player_id = current_player;

    for (uint8_t i = 0; i < ARRAY_SIZE(current_possible_moves); i++)
    {
        if (current_possible_moves[i].as_uint32_t != move.as_uint32_t) continue;

        board
            .board[current_player == RED ? red.x : white.x]
                  [current_player == RED ? red.y : white.y]
            .player_id = NONE;
        board.board[move.x][move.y].player_id = current_player;

        clear_highlighted_moves();
        update_player_sprite(move.x, move.y);

        if (current_player == RED)
        {
            red.x = move.x;
            red.y = move.y;
        }
        else
        {
            white.x = move.x;
            white.y = move.y;
        }

        dyn_array_push(board.moves, move.as_uint32_t);

        if (red.y == BOARD_SIZE - 1)
        {
            LCD_write_text(48, MAX_Y - 27, "RED wins!", Black, TRANSPARENT, 2);
            exit(0);
        }
        else if (white.y == 0)
        {
            LCD_write_text(
                32, MAX_Y - 27, "WHITE wins!", Black, TRANSPARENT, 2);
            exit(0);
        }

        return move;
    }

    move.as_uint32_t = -1;
    return move; // DO NOT MERGE THE PRECEDING LINE WITH THIS ONE
}

bool is_wall_between(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2)
{
    return (x1 == x2 && y1 < y2 && board.board[x1][y1].walls.bottom) ||
           (x1 == x2 && y1 > y2 && board.board[x1][y1].walls.top) ||
           (y1 == y2 && x1 < x2 && board.board[x1][y1].walls.right) ||
           (y1 == y2 && x1 > x2 && board.board[x1][y1].walls.left);
}

bool is_not_trapped(const enum Player player)
{
    struct Stack stack;
    struct Coordinate coordinate;
    uint8_t x = player == RED ? red.x : white.x;
    uint8_t y = player == RED ? red.y : white.y;
    bool visited[BOARD_SIZE][BOARD_SIZE] = {false};

    stack_init(&stack, BOARD_SIZE * BOARD_SIZE);
    push(&stack, x, y); // push starting position
    visited[x][y] = true;

    while (!is_empty(&stack))
    {
        coordinate = pop(&stack);
        x = coordinate.x;
        y = coordinate.y;

        if (y == (player == RED ? BOARD_SIZE - 1 : 0))
        {
            free_stack(&stack);
            return true;
        }

        // neighbors to visit
        struct Coordinate neighbors[] = {
            {x,     y - 1},
            {x,     y + 1},
            {x + 1, y    },
            {x - 1, y    }
        };

        for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
        {
            uint8_t new_x = neighbors[i].x;
            uint8_t new_y = neighbors[i].y;

            if (new_x < BOARD_SIZE && new_y < BOARD_SIZE &&
                !visited[new_x][new_y] && !is_wall_between(x, y, new_x, new_y))
            {
                push(&stack, new_x, new_y);
                visited[new_x][new_y] = true;
            }
        }
    }

    free_stack(&stack);
    return false;
}

bool is_wall_clipping(const uint8_t x,
                      const uint8_t y,
                      const enum Direction dir)
{
    switch (dir)
    {
    case HORIZONTAL:
        // check overlap
        if (board.board[x][y].walls.bottom ||
            board.board[x + 1][y].walls.bottom)
            return true;

        // check intersection
        if (y < BOARD_SIZE - 1 && board.board[x][y + 1].walls.right &&
            board.board[x][y].walls.right)
            return true;
        break;

    case VERTICAL:
        // check overlap
        if (board.board[x][y].walls.right || board.board[x][y + 1].walls.right)
            return true;

        // check intersection
        if (x < BOARD_SIZE - 1 && board.board[x][y].walls.bottom &&
            board.board[x + 1][y].walls.bottom)
            return true;
        break;
    }

    return false;
}

bool is_wall_valid(const uint8_t x, const uint8_t y, const enum Direction dir)
{
    if (x > BOARD_SIZE - 1 || y > BOARD_SIZE - 1 ||
        (x == BOARD_SIZE - 1 && dir == VERTICAL) || // outside right boundary
        (y == BOARD_SIZE - 1 && dir == HORIZONTAL)  // outside bottom boundary
    )
        return false;

    return is_not_trapped(RED) && is_not_trapped(WHITE);
}

void write_invalid_move(void)
{
    LCD_write_text(24, MAX_Y - 27, "Invalid Move", Black, TRANSPARENT, 2);
#ifndef SIMULATOR
    delay_ms(1500); // FIXME: busy waiting
#endif
    LCD_draw_rectangle(24, MAX_Y - 27, 12 * 16 + 24, MAX_Y - 11, TABLE_COLOR);
}

union Move place_wall(const uint8_t x, const uint8_t y)
{
    const enum Direction dir = direction; // cache const for performance
    const struct PlayerInfo *player = current_player == RED ? &red : &white;
    const struct Sprite *wall_sprite = dir == HORIZONTAL ? &wall_horizontal :
                                                           &wall_vertical;
    union Move move = {.x = x,
                       .y = y,
                       .direction = dir,
                       .type = WALL_PLACEMENT,
                       .player_id = current_player};

    // wall placement affects 4 cells
    const struct Coordinate neighbors[] = {
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    uint8_t walls_backup[ARRAY_SIZE(neighbors)];

    if (player->wall_count == 0 || is_wall_clipping(x, y, dir))
    {
        move.as_uint32_t = -1;
        return move; // DO NOT MERGE THE PRECEDING LINE WITH THIS ONE
    }

    if (current_player == RED)
        red.wall_count--;
    else
        white.wall_count--;

    for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
    {
        walls_backup[i] =
            board.board[move.x + neighbors[i].x][move.y + neighbors[i].y]
                .walls.as_uint8_t;
    }

    switch (dir)
    {
    case HORIZONTAL:
        board.board[move.x][move.y].walls.bottom = true;
        board.board[move.x + 1][move.y].walls.bottom = true;
        board.board[move.x][move.y + 1].walls.top = true;
        board.board[move.x + 1][move.y + 1].walls.top = true;
        break;
    case VERTICAL:
        board.board[move.x][move.y].walls.right = true;
        board.board[move.x][move.y + 1].walls.right = true;
        board.board[move.x + 1][move.y].walls.left = true;
        board.board[move.x + 1][move.y + 1].walls.left = true;
        break;
    }

    if (!is_wall_valid(move.x, move.y, dir))
    { // rollback
        for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
        {
            board.board[move.x + neighbors[i].x][move.y + neighbors[i].y]
                .walls.as_uint8_t = walls_backup[i];
        }

        move.as_uint32_t = -1;
        return move; // DO NOT MERGE THE PRECEDING LINE WITH THIS ONE
    }

    wall_sprite->draw(board.board[move.x][move.y].x + // add cell height offset
                          (dir == HORIZONTAL ? 0 : empty_square.width),
                      board.board[move.x][move.y].y + // add cell width offset
                          (dir == HORIZONTAL ? empty_square.height : 0));

    dyn_array_push(board.moves, move.as_uint32_t);
    return move;
}

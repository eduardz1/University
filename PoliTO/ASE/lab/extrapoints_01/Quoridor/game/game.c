#include "game.h"
#include "../GLCD/GLCD.h"
#include "../imgs/sprites.h"
#include "../utils/dynarray.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define BLOCK_PADDING 2
#define TOP_PADDING 40
#define PLAYER_PADDING (((empty_square.width - player_red.width) / 2))

union Move current_possible_moves[5] = {0};
uint8_t current_player = RED;
struct Board *board;
enum Mode mode = PLAYER_MOVE;
enum Direction direction = VERTICAL;

uint8_t num_walls_red = 8;
uint8_t num_walls_white = 8;

void game_init(struct Board *const init_board)
{
    union Move move = {0};
    board = init_board;
    draw_board();

    while (true) // TODO: make game end
    {
        calculate_possible_moves(current_possible_moves, current_player);
        highlight_possible_moves(current_possible_moves);

        // fake move
        move = move_player(RED, 0, 0, 1, 0);
        if (move.as_uint32_t != UINT32_MAX) // successful move
        {
            dyn_array_push(board->moves, move.as_uint32_t);
        }
        else
        {
            while (true)
            {
                __ASM("wfi");
            }
        }

        // while (true)
        //     __ASM("wfi");

        current_player = current_player == RED ? WHITE : RED;
    }
}

void clear_highlighted_moves(const union Move *moves)
{
    uint8_t i = 0;
    uint16_t x, y, start_x, start_y, end_x, end_y;

    for (i = 0; i < 5; i++)
    {
        if (moves[i].as_uint32_t == 0) break;

        x = moves[i].X;
        y = moves[i].Y;

        start_x = board->board[x][y].position.x;
        start_y = board->board[x][y].position.y;
        end_x = start_x + empty_square.width;
        end_y = start_y + empty_square.height;

        LCD_draw_image(start_x, start_y, end_x, end_y, empty_square.data);
    }
}

void draw_board(void)
{

    uint16_t x, y, w = 0;
    uint16_t start_x;
    uint16_t start_y;
    uint16_t end_x;
    uint16_t end_y;

    start_x = 0;
    start_y = TOP_PADDING - BLOCK_PADDING;
    end_x = MAX_X;
    end_y = start_y;

    /* Draw background */
    LCD_draw_full_width_rectangle(0, end_y, 0x9C0E);
    LCD_DrawLine(start_x, start_y, end_x, end_y, Black);
    LCD_draw_full_width_rectangle(start_y + 1, MAX_Y - end_y, 0x6A67);
    LCD_DrawLine(start_x, MAX_Y - start_y, end_x, MAX_Y - end_y, Black);
    LCD_draw_full_width_rectangle(MAX_Y - start_y + 1, MAX_Y, 0x9C0E);

    end_y = start_y - 1 - BLOCK_PADDING; // subtracts width of line and padding
    start_y = end_y - wall.height;
    end_x = start_x + wall.width;

    /* Draw the usable walls */
    for (w = 0; w < WALL_COUNT; w++)
    {
        LCD_draw_image(start_x, start_y, end_x, end_y, wall.data);
        LCD_draw_image(
            start_x, MAX_Y - end_y, end_x, MAX_Y - start_y, wall.data);
        start_x += wall.width + empty_square.width;
        end_x += wall.width + empty_square.width;
    }

    start_x = BLOCK_PADDING;
    start_y = BLOCK_PADDING + TOP_PADDING;
    end_x = start_x + empty_square.width;
    end_y = start_y + empty_square.height;

    /* Draws the empty squares */
    for (x = 0; x < BOARD_SIZE; x++)
    {
        for (y = 0; y < BOARD_SIZE; y++)
        {
            LCD_draw_image(start_x, start_y, end_x, end_y, empty_square.data);

            board->board[x][y].player_id = NONE;
            // board->board[x][y].walls.bottom = {0}; TODO: check if it zero by
            // default
            board->board[x][y].position.x = start_x;
            board->board[x][y].position.y = start_y;

            start_y += empty_square.height + BLOCK_PADDING;
            end_y += empty_square.height + BLOCK_PADDING;
        }
        start_y = BLOCK_PADDING + TOP_PADDING;
        end_y = start_y + empty_square.height;

        start_x += empty_square.width + BLOCK_PADDING;
        end_x += empty_square.width + BLOCK_PADDING;
    }

    /* Draws the players */ // TODO: refactor hard coded values
    start_x = board->board[3][0].position.x + PLAYER_PADDING;
    start_y = board->board[3][0].position.y + PLAYER_PADDING;
    end_x = start_x + player_red.width;
    end_y = start_y + player_red.height;
    LCD_draw_image(start_x, start_y, end_x, end_y, player_red.data);
    LCD_draw_image(
        start_x, MAX_Y - end_y, end_x, MAX_Y - start_y, player_white.data);

    board->board[3][0].player_id = RED;
    board->board[3][6].player_id = WHITE;
}

bool find_player(const uint8_t player_id, uint8_t *const x, uint8_t *const y)
{
    bool found = false;
    for (*x = 0; *x < BOARD_SIZE && !found; (*x)++)
    {
        for (*y = 0; *y < BOARD_SIZE; (*y)++)
        {
            if (board->board[*x][*y].player_id == player_id)
            {
                found = true;
                break;
            }
        }
    }
    (*x)--;

    return found;
}

void calculate_possible_moves(union Move *moves, const uint8_t player_id)
{
    uint8_t x, y, i = 0;
    union Move possible_moves[5] = {0}; // MAX number of possible moves
    if (!find_player(player_id, &x, &y)) return;

    /* Check first 4 adiecent cells */

    // check left
    if (x > 0 && board->board[x][y].walls.left == false)
    {
        if (board->board[x - 1][y].player_id != NONE)
        {
            if (x - 1 > 0 && board->board[x - 1][y].walls.left == false)
            { // jump over left
                possible_moves[i].PlayerID = player_id;
                possible_moves[i].PlayerMove_or_WallPlacement = 0;
                possible_moves[i].X = x - 2;
                possible_moves[i].Y = y;
                i++;
            }
            else
            { // TODO: check if you can move diagonally even though you can jump
                if (y > 0 && board->board[x - 1][y].walls.top == false)
                { // up and left
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x - 1;
                    possible_moves[i].Y = y - 1;
                    i++;
                }

                if (y < BOARD_SIZE - 1 &&
                    board->board[x - 1][y].walls.bottom == false)
                { // down and left
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x - 1;
                    possible_moves[i].Y = y + 1;
                    i++;
                }
            }
        }
        else
        { // left
            possible_moves[i].PlayerID = player_id;
            possible_moves[i].PlayerMove_or_WallPlacement = 0;
            possible_moves[i].X = x - 1;
            possible_moves[i].Y = y;
            i++;
        }
    }

    // check right
    if (x < BOARD_SIZE - 1 && board->board[x][y].walls.right == false)
    {
        if (board->board[x + 1][y].player_id != NONE)
        {
            if (x + 1 < BOARD_SIZE - 1 &&
                board->board[x + 1][y].walls.right == false)
            { // jump over right
                possible_moves[i].PlayerID = player_id;
                possible_moves[i].PlayerMove_or_WallPlacement = 0;
                possible_moves[i].X = x + 2;
                possible_moves[i].Y = y;
                i++;
            }
            else
            {
                if (y > 0 && board->board[x + 1][y].walls.top == false)
                { // up and right
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x + 1;
                    possible_moves[i].Y = y - 1;
                    i++;
                }
                if (y < BOARD_SIZE - 1 &&
                    board->board[x + 1][y].walls.bottom == false)
                { // down and right
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x + 1;
                    possible_moves[i].Y = y + 1;
                    i++;
                }
            }
        }
        else
        { // right
            possible_moves[i].PlayerID = player_id;
            possible_moves[i].PlayerMove_or_WallPlacement = 0;
            possible_moves[i].X = x + 1;
            possible_moves[i].Y = y;
            i++;
        }
    }

    // check top
    if (y > 0 && board->board[x][y].walls.top == false)
    {
        if (board->board[x][y - 1].player_id != NONE)
        {
            if (y - 1 > 0 && board->board[x][y - 1].walls.top == false)
            { // jump over top
                possible_moves[i].PlayerID = player_id;
                possible_moves[i].PlayerMove_or_WallPlacement = 0;
                possible_moves[i].X = x;
                possible_moves[i].Y = y - 2;
                i++;
            }
            else
            {
                if (x > 0 && board->board[x][y - 1].walls.left == false)
                { // up and left
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x - 1;
                    possible_moves[i].Y = y - 1;
                    i++;
                }
                if (x < BOARD_SIZE - 1 &&
                    board->board[x][y - 1].walls.right == false)
                { // up and right
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x + 1;
                    possible_moves[i].Y = y - 1;
                    i++;
                }
            }
        }
        else
        { // top
            possible_moves[i].PlayerID = player_id;
            possible_moves[i].PlayerMove_or_WallPlacement = 0;
            possible_moves[i].X = x;
            possible_moves[i].Y = y - 1;
            i++;
        }
    }

    // check bottom
    if (y < BOARD_SIZE - 1 && board->board[x][y].walls.bottom == false)
    {
        if (board->board[x][y + 1].player_id != NONE)
        {
            if (y + 1 < BOARD_SIZE - 1 &&
                board->board[x][y + 1].walls.bottom == false)
            { // jump over bottom
                possible_moves[i].PlayerID = player_id;
                possible_moves[i].PlayerMove_or_WallPlacement = 0;
                possible_moves[i].X = x;
                possible_moves[i].Y = y + 2;
                i++;
            }
            else
            {
                if (x > 0 && board->board[x][y + 1].walls.left == false)
                { // down and left
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x - 1;
                    possible_moves[i].Y = y + 1;
                    i++;
                }
                if (x < BOARD_SIZE - 1 &&
                    board->board[x][y + 1].walls.right == false)
                { // down and right
                    possible_moves[i].PlayerID = player_id;
                    possible_moves[i].PlayerMove_or_WallPlacement = 0;
                    possible_moves[i].X = x + 1;
                    possible_moves[i].Y = y + 1;
                    i++;
                }
            }
        }
        else
        { // bottom
            possible_moves[i].PlayerID = player_id;
            possible_moves[i].PlayerMove_or_WallPlacement = 0;
            possible_moves[i].X = x;
            possible_moves[i].Y = y + 1;
            i++;
        }
    }

    memcpy(moves, possible_moves, sizeof(possible_moves));
}

void highlight_possible_moves(const union Move *moves)
{
    uint8_t i = 0;
    uint16_t x, y, start_x, start_y, end_x, end_y;
    const uint8_t HIGHLIGHT_PADDING =
        (empty_square.width - highlighted_square.width) / 2;

    for (i = 0; i < 5; i++)
    {
        if (moves[i].as_uint32_t == 0)
        {
            break;
        }

        x = moves[i].X;
        y = moves[i].Y;

        start_x = board->board[x][y].position.x + HIGHLIGHT_PADDING;
        start_y = board->board[x][y].position.y + HIGHLIGHT_PADDING;
        end_x = start_x + highlighted_square.width;
        end_y = start_y + highlighted_square.height;

        LCD_draw_image(start_x, start_y, end_x, end_y, highlighted_square.data);
    }
}

union Move move_player(const uint8_t player_id,
                       const uint8_t up,
                       const uint8_t down,
                       const uint8_t left,
                       const uint8_t right)
{
    union Move move = {0};
    uint8_t player_x, player_y;

    find_player(player_id, &player_x, &player_y);

    move.X = player_x + right - left;
    move.Y = player_y + down - up;
    move.PlayerID = player_id;

    for (uint8_t i = 0; i < 5; i++)
    {
        if (current_possible_moves[i].as_uint32_t == move.as_uint32_t)
        {
            board->board[player_x][player_y].player_id = NONE;
            board->board[move.X][move.Y].player_id = player_id;
            clear_highlighted_moves(current_possible_moves);
            update_player_sprite(player_id,
                                 board->board[player_x][player_y].position.x,
                                 board->board[player_x][player_y].position.y,
                                 board->board[move.X][move.Y].position.x,
                                 board->board[move.X][move.Y].position.y);
            return move;
        }
    }

    move.as_uint32_t = UINT32_MAX;
    return move;
}

union Move place_wall(const uint8_t player_id,
                      const uint8_t up,
                      const uint8_t down,
                      const uint8_t left,
                      const uint8_t right)
{
    union Move move = {0};
    uint8_t player_x, player_y;

    // wall defaults to center in [3][3] // TODO: make it dynamic
    move.X = 3 + right - left;
    move.Y = 3 + down - up;
    move.PlayerID = player_id;

    move.as_uint32_t = UINT32_MAX;
    return move;
}

bool can_wall_be_placed(const enum Player player, uint8_t x, const uint8_t y)
{
    bool can_be_placed = true;

    return can_be_placed;
}

void update_player_sprite(const uint8_t player_id,
                          const uint16_t old_x,
                          const uint16_t old_y,
                          const uint16_t new_x,
                          const uint16_t new_y)
{
    uint16_t start_x, start_y, end_x, end_y;

    start_x = old_x;
    start_y = old_y;
    end_x = start_x + empty_square.width;
    end_y = start_y + empty_square.height;

    LCD_draw_image(start_x, start_y, end_x, end_y, empty_square.data);

    start_x = new_x + PLAYER_PADDING;
    start_y = new_y + PLAYER_PADDING;
    end_x = start_x + player_red.width;
    end_y = start_y + player_red.height;

    if (player_id == RED)
        LCD_draw_image(start_x, start_y, end_x, end_y, player_red.data);
    else
        LCD_draw_image(start_x, start_y, end_x, end_y, player_white.data);
}

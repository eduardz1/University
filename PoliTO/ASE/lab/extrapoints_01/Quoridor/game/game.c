#include "game.h"
#include "../GLCD/GLCD.h"
#include "../imgs/sprites.h"
#include "../utils/dynarray.h"
#include <cstdint>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define BLOCK_PADDING 2
#define TOP_PADDING 40
#define PLAYER_PADDING (((empty_square.width - player_red.width) >> 1))
#define PLAYER_SELECTOR_PADDING                                                \
    (((empty_square.width - player_selector.width) >> 1))

union Move current_possible_moves[5] = {0};
enum Player current_player = RED;
struct Board *board;
enum Mode mode = PLAYER_MOVE;
enum Direction direction = VERTICAL;

struct PlayerInfo red = {RED, 3, 0, 8};
struct PlayerInfo white = {WHITE, 3, 6, 8};

void game_init(struct Board *const init_board)
{
    uint8_t x, y;
    union Move move = {0};
    board = init_board;
    draw_board();

    while (true) // TODO: make game end
    {
        find_player(current_player, &x, &y);
        calculate_possible_moves(current_possible_moves, current_player, x, y);
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

        x = moves[i].x;
        y = moves[i].y;

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

bool find_player(const enum Player player, uint8_t *const x, uint8_t *const y)
{
    bool found = false;
    for (*x = 0; *x < BOARD_SIZE && !found; (*x)++)
    {
        for (*y = 0; *y < BOARD_SIZE; (*y)++)
        {
            if (board->board[*x][*y].player_id == player)
            {
                found = true;
                break;
            }
        }
    }
    (*x)--;

    return found;
}

void calculate_possible_moves(union Move *moves,
                              const enum Player player,
                              uint8_t x,
                              uint8_t y)
{
    uint8_t i;
    union Move possible_moves[5] = {0}; // MAX number of possible moves

    for (i = 0; i < ARRAY_SIZE(possible_moves);
         possible_moves[++i].player_id = player)
        ;
    i = 0;

    // check left
    if (x > 0 && !board->board[x][y].walls.left)
    {
        if (board->board[x - 1][y].player_id != NONE)
        {
            if (x - 1 > 0 && !board->board[x - 1][y].walls.left)
            { // jump over left
                possible_moves[i].x = x - 2;
                possible_moves[i++].y = y;
            }
            else
            { // TODO: check if you can move diagonally even though you can jump
                if (y > 0 && !board->board[x - 1][y].walls.top)
                { // up and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y - 1;
                }
                if (y < BOARD_SIZE - 1 && !board->board[x - 1][y].walls.bottom)
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
    if (x < BOARD_SIZE - 1 && !board->board[x][y].walls.right)
    {
        if (board->board[x + 1][y].player_id != NONE)
        {
            if (x + 1 < BOARD_SIZE - 1 && !board->board[x + 1][y].walls.right)
            { // jump over right
                possible_moves[i].x = x + 2;
                possible_moves[i++].y = y;
            }
            else
            {
                if (y > 0 && !board->board[x + 1][y].walls.top)
                { // up and right
                    possible_moves[i].x = x + 1;
                    possible_moves[i++].y = y - 1;
                }
                if (y < BOARD_SIZE - 1 && !board->board[x + 1][y].walls.bottom)
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
    if (y > 0 && !board->board[x][y].walls.top)
    {
        if (board->board[x][y - 1].player_id != NONE)
        {
            if (y - 1 > 0 && !board->board[x][y - 1].walls.top)
            { // jump over top
                possible_moves[i].x = x;
                possible_moves[i++].y = y - 2;
            }
            else
            {
                if (x > 0 && !board->board[x][y - 1].walls.left)
                { // up and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y - 1;
                }
                if (x < BOARD_SIZE - 1 && !board->board[x][y - 1].walls.right)
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
    if (y < BOARD_SIZE - 1 && !board->board[x][y].walls.bottom)
    {
        if (board->board[x][y + 1].player_id != NONE)
        {
            if (y + 1 < BOARD_SIZE - 1 && !board->board[x][y + 1].walls.bottom)
            { // jump over bottom
                possible_moves[i].x = x;
                possible_moves[i++].y = y + 2;
            }
            else
            {
                if (x > 0 && !board->board[x][y + 1].walls.left)
                { // down and left
                    possible_moves[i].x = x - 1;
                    possible_moves[i++].y = y + 1;
                }
                if (x < BOARD_SIZE - 1 && !board->board[x][y + 1].walls.right)
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

    for (; i < ARRAY_SIZE(possible_moves);
         possible_moves[++i].as_uint32_t = UINT32_MAX)
        ;

    memcpy(moves, possible_moves, sizeof(possible_moves));
}

void highlight_possible_moves(const union Move *moves)
{
    uint8_t i = 0;
    uint16_t start_x, start_y, end_x, end_y;
    const uint8_t HIGHLIGHT_PADDING =
        (empty_square.width - highlighted_square.width) / 2;

    for (i = 0; i < 5; i++)
    {
        if (moves[i].as_uint32_t == UINT32_MAX) continue;

        start_x =
            board->board[moves[i].x][moves[i].y].position.x + HIGHLIGHT_PADDING;
        start_y =
            board->board[moves[i].x][moves[i].y].position.y + HIGHLIGHT_PADDING;

        end_x = start_x + highlighted_square.width;
        end_y = start_y + highlighted_square.height;

        LCD_draw_image(start_x, start_y, end_x, end_y, highlighted_square.data);
    }
}

union Move move_player(const enum Player player,
                       const uint8_t up,
                       const uint8_t down,
                       const uint8_t left,
                       const uint8_t right)
{
    union Move move = {0};
    const uint8_t player_x = player == RED ? red.x : white.x,
                  player_y = player == RED ? red.y : white.y;

    move.x = player_x + right - left;
    move.y = player_y + down - up;
    move.player_id = player;

    for (uint8_t i = 0; i < ARRAY_SIZE(current_possible_moves); i++)
    {
        if (current_possible_moves[i].as_uint32_t != move.as_uint32_t) continue;

        board->board[player_x][player_y].player_id = NONE;
        board->board[move.x][move.y].player_id = player;

        if (player == RED)
        {
            red.x = move.x;
            red.y = move.y;
        }
        else
        {
            white.x = move.x;
            white.y = move.y;
        }

        clear_highlighted_moves(current_possible_moves);
        update_player_sprite(player,
                             board->board[player_x][player_y].position.x,
                             board->board[player_x][player_y].position.y,
                             board->board[move.x][move.y].position.x,
                             board->board[move.x][move.y].position.y);
        return move;
    }

    move.as_uint32_t = UINT32_MAX;
    return move;
}

bool dumb_recursion(const enum Player player,
                    const uint8_t x,
                    const uint8_t y,
                    const uint8_t end_y)
{
    bool end_reached = false;
    uint8_t i = 0;
    union Move possible_moves[5] = {0};
    calculate_possible_moves(possible_moves, player, x, y);

    // FIXME: needs a sorting step, sort is small, insert sort is probably
    // fine need a way to return early if end is reached

    for (; i < ARRAY_SIZE(possible_moves) && !end_reached; i++)
    {
        if (possible_moves[i].as_uint32_t == UINT32_MAX) continue;

        if (possible_moves[i].y == end_y)
        {
            end_reached = true;
            break;
        }

        end_reached |= dumb_recursion(
            player, possible_moves[i].x, possible_moves[i].y, end_y);
    }

    return end_reached;
}

bool check_trapped(const enum Player player)
{
    const uint8_t x = player == RED ? red.x : white.x,
                  y = player == RED ? red.y : white.y,
                  end_y = player == RED ? BOARD_SIZE - 1 : 0;

    return dumb_recursion(player, x, y, end_y);
}

bool is_wall_valid(const uint8_t x, const uint8_t y, const enum Direction dir)
{
    if (x < 0 || y < 0 || x > BOARD_SIZE - 1 || y > BOARD_SIZE - 1 ||
        (x == BOARD_SIZE - 1 && dir == VERTICAL) || // outside right boundary
        (y == BOARD_SIZE - 1 && dir == HORIZONTAL)  // outside bottom boundary
    )
        return false;

    // Player trapped algorithm // FIXME: implement in a more efficient way with
    // a path finding algorithm, need a temporary way to solve it for the 11th

    return check_trapped(RED) || check_trapped(WHITE);
}

union Move place_wall(const enum Player player,
                      const uint8_t up,
                      const uint8_t down,
                      const uint8_t left,
                      const uint8_t right)
{
    union Move move = {0};
    uint8_t player_x, player_y;

    const enum Direction dir = direction; // cache const for performance

    move.x = (BOARD_SIZE >> 1) + right - left;
    move.y = (BOARD_SIZE >> 1) + down - up;

    if (!is_wall_valid(move.x, move.y, dir))
    {
        move.as_uint32_t = UINT32_MAX;
        return move;
    }

    if (player == RED)
    {
        if (red.wall_count == 0)
        {
            move.as_uint32_t = UINT32_MAX;
            return move;
        }
        red.wall_count--;
    }
    else
    {
        if (white.wall_count == 0)
        {
            move.as_uint32_t = UINT32_MAX;
            return move;
        }
        white.wall_count--;
    }

    move.player_id = player;

    if (dir == HORIZONTAL)
    {
        board->board[move.x][move.y].walls.bottom = true;
        board->board[move.x][move.y + 1].walls.top = true;
    }
    else
    {
        board->board[move.x][move.y].walls.right = true;
        board->board[move.x + 1][move.y].walls.left = true;
    }

    return move;
}

void update_player_selector(const uint16_t old_x,
                            const uint16_t old_y,
                            const uint16_t new_x,
                            const uint16_t new_y)
{
    uint16_t start_x = old_x, start_y = old_y, end_x = start_x, end_y = start_y;
    const struct Sprite *sprite;

    switch (board->board[old_x][old_y].player_id)
    {
    case NONE:
        end_x += empty_square.width;
        end_y += empty_square.height;
        sprite = &empty_square;
        break;

    case RED:
        start_x += PLAYER_PADDING;
        start_y += PLAYER_PADDING;
        end_x = start_x + player_red.width;
        end_y = start_y + player_red.height;
        sprite = &player_red;
        break;

    case WHITE:
        start_x += PLAYER_PADDING;
        start_y += PLAYER_PADDING;
        end_x = start_x + player_white.width;
        end_y = start_y + player_white.height;
        sprite = &player_white;
        break;
    }

    LCD_draw_image(start_x, start_y, end_x, end_y, sprite->data);

    start_x = new_x + PLAYER_SELECTOR_PADDING;
    start_y = new_y + PLAYER_SELECTOR_PADDING;
    end_x = start_x + player_selector.width;
    end_y = start_y + player_selector.height;

    LCD_draw_image(start_x, start_y, end_x, end_y, player_selector.data);
}

void update_wall_selector(const uint16_t old_x,
                          const uint16_t old_y,
                          const uint16_t new_x,
                          const uint16_t new_y)
{
    uint16_t start_x = old_x, start_y = old_y, end_x = start_x, end_y = start_y;

    if (board->board[old_x][old_y].walls.bottom)
    {
        end_x += wall.height;
        end_y += wall.width;
        LCD_draw_image(start_x, start_y, end_x, end_y, wall.data);
    }

    if (board->board[old_x][old_y].walls.right)
    {
        end_x += wall.width;
        end_y += wall.height;
        LCD_draw_image(start_x, start_y, end_x, end_y, wall.data);
    }

    start_x = new_x;
    start_y = new_y;

    if (direction == HORIZONTAL)
    {
        end_x = start_x + wall.height;
        end_y = start_y + wall.width;
    }
    else
    {
        end_x = start_x + wall.width;
        end_y = start_y + wall.height;
    }

    LCD_draw_image(start_x, start_y, end_x, end_y, wall_selector.data);
}

/**
 * @pre the move is valid
 *
 */
void update_player_sprite(const enum Player player,
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

    if (player == RED)
        LCD_draw_image(start_x, start_y, end_x, end_y, player_red.data);
    else
        LCD_draw_image(start_x, start_y, end_x, end_y, player_white.data);
}

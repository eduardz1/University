#include "game.h"
#include "../GLCD/GLCD.h"
#include "../RIT/RIT.h"
#include "../imgs/sprites.h"
#include "../utils/dynarray.h"
#include "../utils/stack.h"
#include <cstdint>
#include <stdbool.h>
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
struct Board board = {0};
enum Mode mode = PLAYER_MOVE;
enum Direction direction = VERTICAL;

struct PlayerInfo red = {RED, 3, 0, 8};
struct PlayerInfo white = {WHITE, 3, 6, 8};

void game_init(void)
{
    board.moves = dyn_array_new(0);
    uint8_t x, y;
    union Move move = {0};
    draw_board();

    enable_RIT(); /* start accepting inputs */

    // while (true) // TODO: make game end
    // {
    manage_turn();

    // fake move
    // move = move_player(RED, 0, 0, 1, 0);
    // if (move.as_uint32_t != UINT32_MAX) // successful move
    // {
    //     dyn_array_push(board->moves, move.as_uint32_t);
    // }
    // else
    //{
    //    while (true)
    //    {
    //        __ASM("wfi");
    //    }
    //}

    while (true)
        __ASM("wfi");

    //     current_player = current_player == RED ? WHITE : RED;
    // }
}

void manage_turn(void)
{
    uint8_t x = current_player == RED ? red.x : white.x;
    uint8_t y = current_player == RED ? red.y : white.y;

    calculate_possible_moves();
    highlight_possible_moves(); // TODO: maybe inline

    // TODO: show current player's turn in a nicer way
    GUI_Text(4,
             4,
             (uint8_t *)(current_player == RED ? "RED  " : "WHITE"),
             Black,
             TABLE_COLOR);
}

void clear_highlighted_moves(void)
{
    uint8_t i = 0;
    uint16_t x, y, start_x, start_y;
    const uint8_t HIGHLIGHT_PADDING =
        (empty_square.width - highlighted_square.width) >> 1;

    for (i = 0; i < 5; i++)
    {
        if (current_possible_moves[i].as_uint32_t == UINT32_MAX) break;

        x = current_possible_moves[i].x;
        y = current_possible_moves[i].y;

        start_x = board.board[x][y].x + HIGHLIGHT_PADDING;
        start_y = board.board[x][y].y + HIGHLIGHT_PADDING;

        highlighted_square_cell_color.draw(start_x, start_y);
    }
}

void draw_board(void)
{

    uint16_t start_x = 0, start_y = TOP_PADDING - BLOCK_PADDING, x, y;

    /* Draw background */
    LCD_draw_full_width_rectangle(0, start_y, TABLE_COLOR);
    LCD_DrawLine(start_x, start_y, MAX_X, start_y, Black);
    LCD_draw_full_width_rectangle(start_y + 1, MAX_Y - start_y, BOARD_COLOR);
    LCD_DrawLine(start_x, MAX_Y - start_y, MAX_X, MAX_Y - start_y, Black);
    LCD_draw_full_width_rectangle(MAX_Y - start_y + 1, MAX_Y, TABLE_COLOR);

    // FIXME: remove and use leds to represent walls
    // end_y = start_y - 1 - BLOCK_PADDING; // subtracts width of line and
    // padding start_y = end_y - wall_vertical.height; end_x = start_x +
    // wall_vertical.width;

    // /* Draw the usable walls */
    // for (w = 0; w < WALL_COUNT; w++)
    // {
    //     wall_vertical.draw(start_x, start_y);
    //     wall_vertical.draw(start_x, MAX_Y - end_y);

    //     start_x += wall_vertical.width + empty_square.width;
    //     end_x += wall_vertical.width + empty_square.width;
    // }

    start_x = BLOCK_PADDING;
    start_y = BLOCK_PADDING + TOP_PADDING;

    /* Draws the empty squares */
    for (x = 0; x < BOARD_SIZE; x++)
    {
        for (y = 0; y < BOARD_SIZE; y++)
        {
            empty_square.draw(start_x, start_y);

            board.board[x][y].player_id = NONE;
            board.board[x][y].walls.as_uint8_t = 0;
            board.board[x][y].x = start_x;
            board.board[x][y].y = start_y;

            start_y += empty_square.height + BLOCK_PADDING;
        }
        start_y = BLOCK_PADDING + TOP_PADDING;
        start_x += empty_square.width + BLOCK_PADDING;
    }

    start_x = board.board[BOARD_SIZE >> 1][0].x + PLAYER_PADDING;
    start_y = board.board[BOARD_SIZE >> 1][0].y + PLAYER_PADDING;

    player_red.draw(start_x, start_y);
    player_white.draw(start_x, MAX_Y - start_y - player_red.height);

    board.board[BOARD_SIZE >> 1][0].player_id = RED;
    board.board[BOARD_SIZE >> 1][BOARD_SIZE - 1].player_id = WHITE;
}

void refresh_walls(void)
{ // TODO: fix hard coded number with const
    uint16_t y, x;
    const uint16_t top = board.board[0][0].y - BLOCK_PADDING;
    const uint16_t bot = board.board[0][BOARD_SIZE - 1].y + 32 + BLOCK_PADDING;
    const uint16_t left = board.board[0][0].x - BLOCK_PADDING;
    const uint16_t right =
        board.board[BOARD_SIZE - 1][0].x + 32 + BLOCK_PADDING;

    for (y = top; y < bot; y += 32 + BLOCK_PADDING)
        LCD_draw_full_width_rectangle(y, y + 2, BOARD_COLOR);

    for (x = left; x < right; x += 32 + BLOCK_PADDING)
        LCD_draw_rectangle(x, top, x + 2, bot, BOARD_COLOR);

    for (x = 0; x < BOARD_SIZE; x++)
    {
        for (y = 0; y < BOARD_SIZE; y++)
        {
            if (board.board[x][y].walls.right == true)
                wall_vertical_half.draw(board.board[x][y].x + 32,
                                        board.board[x][y].y - 1);
            if (board.board[x][y].walls.left == true)
                wall_vertical_half.draw(board.board[x][y].x - 2,
                                        board.board[x][y].y - 1);
            if (board.board[x][y].walls.top == true)
                wall_horizontal_half.draw(board.board[x][y].x - 1,
                                          board.board[x][y].y - 2);
            if (board.board[x][y].walls.bottom == true)
                wall_horizontal_half.draw(board.board[x][y].x - 1,
                                          board.board[x][y].y + 32);
        }
    }
}

void calculate_possible_moves(void) // FIXME: bug, RED in player id for WHITE
                                    // move
{
    uint8_t i, x = current_player == RED ? red.x : white.x,
               y = current_player == RED ? red.y : white.y;
    union Move possible_moves[5] = {0}; // MAX number of possible moves

    for (i = 0; i < ARRAY_SIZE(possible_moves);
         possible_moves[++i].player_id = current_player)
        ;
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

    for (; i < ARRAY_SIZE(possible_moves);
         possible_moves[i++].as_uint32_t = UINT32_MAX)
        ;

    // TODO: not needed, just update directly current moves
    memcpy(current_possible_moves, possible_moves, sizeof(possible_moves));
}

void highlight_possible_moves(void)
{
    uint8_t i = 0;
    uint16_t start_x, start_y;
    const uint8_t HIGHLIGHT_PADDING =
        (empty_square.width - highlighted_square.width) >> 1;

    for (i = 0; i < 5; i++)
    {
        if (current_possible_moves[i].as_uint32_t == UINT32_MAX) continue;

        start_x =
            board
                .board[current_possible_moves[i].x][current_possible_moves[i].y]
                .x +
            HIGHLIGHT_PADDING;
        start_y =
            board
                .board[current_possible_moves[i].x][current_possible_moves[i].y]
                .y +
            HIGHLIGHT_PADDING;

        highlighted_square.draw(start_x, start_y);
    }
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

        // check winning condition // TODO: end game
        if (red.y == BOARD_SIZE - 1)
        {
            GUI_Text(2, 2, (uint8_t *)"RED wins", Black, TABLE_COLOR);
        }
        else if (white.y == 0)
        {
            GUI_Text(2, 2, (uint8_t *)"WHITE wins", Black, TABLE_COLOR);
        }

        return move;
    }

    move.as_uint32_t = UINT32_MAX;
    return move;
}

bool is_wall_between(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2)
{
    return (x1 == x2 && y1 < y2 && board.board[x1][y1].walls.right) ||
           (x1 == x2 && y1 > y2 && board.board[x1][y2].walls.right) ||
           (y1 == y2 && x1 < x2 && board.board[x1][y1].walls.bottom) ||
           (y1 == y2 && x1 > x2 && board.board[x2][y1].walls.bottom);
}

bool check_trapped(const enum Player player)
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

bool is_wall_valid(const uint8_t x, const uint8_t y, const enum Direction dir)
{
    if (x > BOARD_SIZE - 1 || y > BOARD_SIZE - 1 ||
        (x == BOARD_SIZE - 1 && dir == VERTICAL) || // outside right boundary
        (y == BOARD_SIZE - 1 && dir == HORIZONTAL)  // outside bottom boundary
    )
        return false;

    return check_trapped(RED) && check_trapped(WHITE);
}

union Move place_wall(const uint8_t x, const uint8_t y)
{
    union Move move = {0};
    const enum Direction dir = direction; // cache const for performance

    if (current_player == RED)
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

    move.direction = dir;
    move.type = WALL_PLACEMENT;
    move.x = x;
    move.y = y;
    move.player_id = current_player;

    // TODO: check if we can place walls on the outer borders, if so manage the
    // cases where we don't update the adjacent cells
    // FIXME this code sucks but it should work now
    if (dir == HORIZONTAL)
    {
        bool tmp1 = board.board[move.x][move.y].walls.bottom;
        bool tmp2 = board.board[move.x + 1][move.y].walls.bottom;
        bool tmp3 = board.board[move.x][move.y + 1].walls.top;
        bool tmp4 = board.board[move.x + 1][move.y + 1].walls.top;

        board.board[move.x][move.y].walls.bottom = true;
        board.board[move.x + 1][move.y].walls.bottom = true;
        board.board[move.x][move.y + 1].walls.top = true;
        board.board[move.x + 1][move.y + 1].walls.top = true;

        if (!is_wall_valid(move.x, move.y, dir))
        {
            GUI_Text(4, 4, (uint8_t *)"MOVE INVALID", Black, TABLE_COLOR);

            board.board[move.x][move.y].walls.bottom = tmp1;
            board.board[move.x + 1][move.y].walls.bottom = tmp2;
            board.board[move.x][move.y + 1].walls.top = tmp3;
            board.board[move.x + 1][move.y + 1].walls.top = tmp4;

            move.as_uint32_t = UINT32_MAX;
            return move;
        }

        wall_horizontal.draw(board.board[move.x][move.y].x,
                             board.board[move.x][move.y].y +
                                 empty_square.height); // add cell height offset
    }
    else
    {
        bool tmp1 = board.board[move.x][move.y].walls.right;
        bool tmp2 = board.board[move.x][move.y + 1].walls.right;
        bool tmp3 = board.board[move.x + 1][move.y].walls.left;
        bool tmp4 = board.board[move.x + 1][move.y + 1].walls.left;

        board.board[move.x][move.y].walls.right = true;
        board.board[move.x][move.y + 1].walls.right = true;
        board.board[move.x + 1][move.y].walls.left = true;
        board.board[move.x + 1][move.y + 1].walls.left = true;

        if (!is_wall_valid(move.x, move.y, dir))
        {
            GUI_Text(4, 4, (uint8_t *)"MOVE INVALID", Black, TABLE_COLOR);

            board.board[move.x][move.y].walls.right = tmp1;
            board.board[move.x][move.y + 1].walls.right = tmp2;
            board.board[move.x + 1][move.y].walls.left = tmp3;
            board.board[move.x + 1][move.y + 1].walls.left = tmp4;

            move.as_uint32_t = UINT32_MAX;
            return move;
        }

        wall_vertical.draw(board.board[move.x][move.y].x +
                               empty_square.width, // add cell width offset
                           board.board[move.x][move.y].y);
    }

    dyn_array_push(board.moves, move.as_uint32_t);
    return move;
}

void update_player_selector(const int8_t up, const int8_t right, bool show)
{
    static int16_t x = 0, y = 0;
    static bool flag_change_turn = true;
    static enum Player last_player = RED;

    uint16_t start_x, start_y;
    const struct Sprite *color;

    if (last_player != current_player) flag_change_turn = true;

    if (flag_change_turn)
    {
        last_player = current_player;

        x = current_player == RED ? red.x : white.x;
        y = current_player == RED ? red.y : white.y;

        flag_change_turn = false;
    }

    start_x = board.board[x][y].x + PLAYER_SELECTOR_PADDING;
    start_y = board.board[x][y].y + PLAYER_SELECTOR_PADDING;

    switch (board.board[x][y].player_id) // TODO: not needed if I save the
                                         // pixels with read, should also be
                                         // faster, remove hard coded colors
    {
    case NONE: color = &player_selector_cell_color; break;
    case RED: color = &player_selector_red_inner_color; break;
    case WHITE: color = &player_selector_white_inner_color; break;
    }

    color->draw(start_x, start_y);

    if (show == false) return; // return after clearing last selector

    x += right;
    y += up;

    CLAMP(x, 0, BOARD_SIZE - 1)
    CLAMP(y, 0, BOARD_SIZE - 1)

    start_x = board.board[x][y].x + PLAYER_SELECTOR_PADDING;
    start_y = board.board[x][y].y + PLAYER_SELECTOR_PADDING;

    player_selector.draw(start_x, start_y);
}

void update_wall_selector(const int8_t up, const int8_t right, bool show)
{
    static int16_t x = 0, y = 0;
    static bool flag_change_mode = true;
    static enum Mode last_mode = PLAYER_MOVE;

    uint16_t start_x, start_y;

    if (last_mode != mode) flag_change_mode = true;

    if (flag_change_mode)
    {
        last_mode = mode;

        /* place wall in the middle of the board */
        x = BOARD_SIZE >> 1;
        y = BOARD_SIZE >> 1;

        flag_change_mode = false;
    }

    refresh_walls();

    /* FIXME: this code is getting horrendous and breaks easily, refreshing the
     whole board is not too slow
    start_x = board.board[x][y].x;
    start_y = board.board[x][y].y;
    start_y += empty_square.width; // add vertical cell offset
    if (board.board[x][y].walls.bottom)
        wall_horizontal_half.draw(start_x, start_y);
    else
        wall_horizontal_board_color_half.draw(start_x, start_y);

    start_x = board.board[x + 1][y].x;
    start_y = board.board[x + 1][y].y;
    start_y += empty_square.width; // add vertical cell offset
    if (board.board[x + 1][y].walls.bottom)
        wall_horizontal_half.draw(start_x, start_y);
    else
        wall_horizontal_board_color_half.draw(start_x, start_y);
    start_y -= empty_square.width; // remove vertical cell offset

    start_x += empty_square.width; // add horizontal cell offset
    if (board.board[x][y].walls.right)
        wall_vertical.draw(start_x, start_y);
    else
        wall_vertical_board_color_half.draw(start_x, start_y);

    start_x = board.board[x][y + 1].x;
    start_y = board.board[x][y + 1].y;
    start_x += empty_square.width; // add horizontal cell offset
    if (board.board[x][y + 1].walls.right)
        wall_vertical.draw(start_x, start_y);
    else
        wall_vertical_board_color_half.draw(start_x, start_y);
    */

    if (show == false) return; // return after clearing last selector

    x += right;
    y += up;

    CLAMP(x, 0, BOARD_SIZE - 2) // wall is 2 cells wide
    CLAMP(y, 0, BOARD_SIZE - 2)

    start_x = board.board[x][y].x;
    start_y = board.board[x][y].y;

    if (direction == HORIZONTAL)
    {
        start_y += empty_square.width;
        wall_horizontal_selector.draw(start_x, start_y);
    }
    else
    {
        start_x += empty_square.width;
        wall_vertical_selector.draw(start_x, start_y);
    }
}

/**
 * @pre the move is valid
 *
 */
void update_player_sprite(const uint8_t new_x, const uint8_t new_y)
{
    const struct Sprite *player;
    uint16_t old_x, old_y;

    if (current_player == RED)
    {
        old_x = board.board[red.x][red.y].x;
        old_y = board.board[red.x][red.y].y;
        player = &player_red;
    }
    else
    {
        old_x = board.board[white.x][white.y].x;
        old_y = board.board[white.x][white.y].y;
        player = &player_white;
    }

    empty_square.draw(old_x, old_y);
    player->draw(board.board[new_x][new_y].x + PLAYER_PADDING,
                 board.board[new_x][new_y].y + PLAYER_PADDING);
}

#pragma once

#include "../common.h"
#include <stdint.h>

#define BLOCK_PADDING 2
#define TOP_PADDING 40
#define PLAYER_PADDING (((empty_square.width - player_red.width) >> 1))
#define PLAYER_SELECTOR_PADDING                                                \
    (((empty_square.width - player_selector.width) >> 1))

void game_init(void);

/**
 * @brief changes turn and updates the list of moves that are possible in the
 * current state and highlights them for the current player
 *
 */
void change_turn(void);

void calculate_possible_moves(void);

/**
 * @brief moves the player sprite, updates the current player position on the
 * board, calls the clear function on the highlighted moves, if the input move
 * is valid pushes it into the array in board, stops the game in case on of the
 * player wins
 *
 * @param x coordinate on board
 * @param y coordinate on board
 */
union Move move_player(const uint8_t x, const uint8_t y);

/**
 * @brief checks if the wall passed as input is not overlapping with another
 * wall or intersecting one
 * @pre the wall position is valid
 *
 * @param x x board coordinate of wall start
 * @param y y board coordinate of wall start
 * @param dir direction of the wall
 * @return true if it is clipping another wall
 * @return false otherwise
 */
bool is_wall_clipping(const uint8_t x,
                      const uint8_t y,
                      const enum Direction dir);

bool is_wall_valid(const uint8_t x, const uint8_t y, const enum Direction dir);

/**
 * @param x1 x board coordinate of first cell
 * @param y1 y board coordinate of first cell
 * @param x2 x board coordinate of second cell
 * @param y2 y board coordinate of second cell
 * @return true if there is a wall between the two cells
 * @return false otherwise
 */
bool is_wall_between(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2);

/**
 * @brief checks if placing a wall would cause the player to be trapped using
 * DFS on a matrix representation of the board
 *
 * @return true if player has a path to the winning coordinate, false otherwise
 */
bool is_not_trapped(const enum Player player);

/**
 * @pre position is valid
 *
 * @param x coordinate on board
 * @param y coordinate on board
 */
union Move place_wall(const uint8_t x, const uint8_t y);

bool can_wall_be_placed(const enum Player player,
                        const uint8_t x,
                        const uint8_t y);

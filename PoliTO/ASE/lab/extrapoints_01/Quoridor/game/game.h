#pragma once

#include "../common.h"
#include <stdint.h>

typedef void (*update_selector)(const int8_t up, const int8_t right, bool show);

void draw_board(void);
void game_init(void);

/**
 * @brief updates the list of moves that are possible in the current state and
 * highlights them for the current player
 *
 */
void manage_turn(void);

void update_player_sprite(const uint8_t new_x, const uint8_t new_y);

/**
 * @brief updates the sprite of the player move selector
 * @pre be in PLAYER_MOVE mode
 *
 * @param up offset up (negative for down)
 * @param right offset right (negative for left)
 * @param show if set to false the selector clears itself
 */
void update_player_selector(const int8_t up, const int8_t right, bool show);

/**
 * @brief updates the sprite of the wall selector
 * @pre be in WALL_PLACEMENT mode
 *
 * @param up offset up (negative for down)
 * @param right offset right (negative for left)
 * @param show if set to false the selector clears itself
 */
void update_wall_selector(const int8_t up, const int8_t right, bool show);

void calculate_possible_moves(void);

void highlight_possible_moves(void);

void clear_highlighted_moves(void);

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
 */
bool check_trapped(const enum Player player);

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

void refresh_walls(void);
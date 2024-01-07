#pragma once

#include "../common.h"
#include <stdint.h>

typedef void (*update_selector)(const int8_t up, const int8_t right);

void draw_board(void);
void game_init(struct Board *const board);

void update_player_sprite(const enum Player player,
                          const uint16_t old_x,
                          const uint16_t old_y,
                          const uint16_t new_x,
                          const uint16_t new_y);

/**
 * @brief updates the sprite of the player move selector
 * @pre be in PLAYER_MOVE mode
 *
 * @param up offset up (negative for down)
 * @param right offset right (negative for left)
 */
void update_player_selector(const int8_t up, const int8_t right);

/**
 * @brief updates the sprite of the wall selector
 * @pre be in WALL_PLACEMENT mode
 *
 * @param up offset up (negative for down)
 * @param right offset right (negative for left)
 */
void update_wall_selector(const int8_t up, const int8_t right);

void calculate_possible_moves(union Move *moves,
                              const enum Player player,
                              uint8_t x,
                              uint8_t y);

void highlight_possible_moves(const union Move *moves);

void clear_highlighted_moves(const union Move *moves);

union Move move_player(const enum Player player,
                       const uint8_t up,
                       const uint8_t down,
                       const uint8_t left,
                       const uint8_t right);

bool is_wall_valid(const uint8_t x, const uint8_t y, const enum Direction dir);

bool check_trapped(const enum Player player);

union Move place_wall(const enum Player player,
                      const uint8_t up,
                      const uint8_t down,
                      const uint8_t left,
                      const uint8_t right);

bool can_wall_be_placed(const enum Player player,
                        const uint8_t x,
                        const uint8_t y);

bool find_player(const enum Player player, uint8_t *const x, uint8_t *const y);

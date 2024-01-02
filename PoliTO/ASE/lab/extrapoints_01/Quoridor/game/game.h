#pragma once

#include "../common.h"
#include <stdint.h>

void draw_board(void);
void game_init(struct Board *const board);

void update_player_sprite(const uint8_t player_id,
                          const uint16_t old_x,
                          const uint16_t old_y,
                          const uint16_t new_x,
                          const uint16_t new_y);

void calculate_possible_moves(union Move *moves, const uint8_t player_id);

void highlight_possible_moves(const union Move *moves);

void clear_highlighted_moves(const union Move *moves);

union Move move_player(const uint8_t player_id,
                       const uint8_t up,
                       const uint8_t down,
                       const uint8_t left,
                       const uint8_t right);

union Move place_wall(const uint8_t player_id,
                      const uint8_t up,
                      const uint8_t down,
                      const uint8_t left,
                      const uint8_t right);

bool can_wall_be_placed(const enum Player player,
                        const uint8_t x,
                        const uint8_t y);

bool find_player(const uint8_t player_id, uint8_t *const x, uint8_t *const y);

#pragma once

#include <stdint.h>

struct Sprite
{
    const uint16_t *data;
    const uint16_t width;
    const uint16_t height;
};

extern const struct Sprite player_white;
extern const struct Sprite player_red;
extern const struct Sprite highlighted_square;
extern const struct Sprite empty_square;
extern const struct Sprite wall;
extern const struct Sprite wall_selector;
extern const struct Sprite player_selector;

extern const uint16_t player_white_data[22 * 22];
extern const uint16_t player_red_data[22 * 22];
extern const uint16_t highlighted_square_data[28 * 28];
extern const uint16_t empty_square_data[32 * 32];
extern const uint16_t wall_data[2 * 32];
extern const uint16_t wall_selector_data[2 * 32];
extern const uint16_t player_selector_data[18 * 18];

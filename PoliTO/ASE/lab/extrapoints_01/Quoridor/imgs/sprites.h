#pragma once

#include <stdint.h>

#define RED_PLAYER_COLOR 0xd105
#define RED_PLAYER_COLOR_INNER 0x5883

#define WHITE_PLAYER_COLOR 0xdefb
#define WHITE_PLAYER_COLOR_INNER 0x7bef

#define HIGHLIGHT_COLOR 0xfee0

#define WALL_COLOR 0x3b5c
#define WALL_SELECTOR_COLOR 0x07ff

#define CELL_COLOR 0x18c2
#define BOARD_COLOR 0x6a67
#define TABLE_COLOR 0x9c0e

typedef void (*draw)(uint16_t x, uint16_t y);

struct Sprite
{
    const draw draw;
    const uint16_t width;
    const uint16_t height;
};

extern const struct Sprite empty_square;
extern const struct Sprite empty_square_transparent;
extern const struct Sprite highlighted_square;
extern const struct Sprite highlighted_square_cell_color;
extern const struct Sprite highlighted_square_red_color;
extern const struct Sprite highlighted_square_white_color;

extern const struct Sprite wall_vertical;
extern const struct Sprite wall_horizontal;
extern const struct Sprite wall_vertical_half;
extern const struct Sprite wall_horizontal_half;
extern const struct Sprite wall_vertical_selector;
extern const struct Sprite wall_horizontal_selector;
extern const struct Sprite wall_vertical_board_color_half;
extern const struct Sprite wall_horizontal_board_color_half;

extern const struct Sprite player_white;
extern const struct Sprite player_red;
extern const struct Sprite player_selector;
extern const struct Sprite player_selector_cell_color;
extern const struct Sprite player_selector_red_inner_color;
extern const struct Sprite player_selector_white_inner_color;

// extern const uint16_t player_white_data[22 * 22];
// extern const uint16_t player_red_data[22 * 22];
// extern const uint16_t highlighted_square_data[28 * 28];
// extern const uint16_t empty_square_data[32 * 32];
// extern const uint16_t wall_data[2 * 32];
// extern const uint16_t wall_selector_data[2 * 32];
// extern const uint16_t player_selector_data[18 * 18];

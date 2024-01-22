#include "../GLCD/GLCD.h"
#include "sprites.h"

static void draw_wall_vertical(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 2, y + 66, WALL_COLOR);
}

static void draw_wall_horizontal(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 66, y + 2, WALL_COLOR);
}

static void draw_wall_vertical_half(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 2, y + 34, WALL_COLOR);
}

static void draw_wall_horizontal_half(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 34, y + 2, WALL_COLOR);
}

static void draw_wall_vertical_selector(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 2, y + 64, WALL_SELECTOR_COLOR);
}

static void draw_wall_horizontal_selector(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 64, y + 2, WALL_SELECTOR_COLOR);
}

static void draw_wall_vertical_board_color_half(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 2, y + 34, BOARD_COLOR);
}

static void draw_wall_horizontal_board_color_half(uint16_t x, uint16_t y)
{
    LCD_draw_rectangle(x, y, x + 34, y + 2, BOARD_COLOR);
}

const struct Sprite wall_vertical = {
    .draw = draw_wall_vertical,
    .width = 2,
    .height = 66,
};

const struct Sprite wall_horizontal = {
    .draw = draw_wall_horizontal,
    .width = 66,
    .height = 2,
};

const struct Sprite wall_vertical_half = {
    .draw = draw_wall_vertical_half,
    .width = 2,
    .height = 34,
};

const struct Sprite wall_horizontal_half = {
    .draw = draw_wall_horizontal_half,
    .width = 34,
    .height = 2,
};

const struct Sprite wall_vertical_selector = {
    .draw = draw_wall_vertical_selector,
    .width = 2,
    .height = 64,
};

const struct Sprite wall_horizontal_selector = {
    .draw = draw_wall_horizontal_selector,
    .width = 64,
    .height = 2,
};

const struct Sprite wall_vertical_board_color_half = {
    .draw = draw_wall_vertical_board_color_half,
    .width = 2,
    .height = 34,
};

const struct Sprite wall_horizontal_board_color_half = {
    .draw = draw_wall_horizontal_board_color_half,
    .width = 34,
    .height = 2,
};

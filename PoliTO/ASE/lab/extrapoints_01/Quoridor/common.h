#pragma once
#pragma anon_unions

#include "utils/dynarray.h"
#include <stdbool.h>
#include <stdint.h>

#ifndef NULL
#define NULL 0
#endif

#define SIMULATOR

#define BOARD_SIZE 7
#define BOARD_TIMER 20 // timer in seconds
#define WALL_COUNT 8

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#define CLAMP(n, min, max)                                                     \
    do                                                                         \
    {                                                                          \
        n = n < min ? min : n;                                                 \
        n = n > max ? max : n;                                                 \
    } while (0);

enum Player
{
    RED = 0,
    WHITE = 1,
    NONE = UINT8_MAX
};

struct PlayerInfo
{
    enum Player player_id;
    uint8_t x;
    uint8_t y;
    uint8_t wall_count;
};

struct Coordinate
{
    uint8_t x;
    uint8_t y;
};

enum Mode
{
    PLAYER_MOVE = 0,
    WALL_PLACEMENT = 1
};

enum Direction
{
    VERTICAL = 0,
    HORIZONTAL = 1
};

struct Cell
{
    enum Player player_id;

    union {
        struct
        {
            bool left   : 2;
            bool right  : 2;
            bool top    : 2;
            bool bottom : 2;
        };

        uint8_t as_uint8_t;
    } walls;

    uint8_t x; // absolute position in pixel
    uint8_t y; // absolute position in pixel
};

struct Board
{
    struct DynArray *moves;
    uint16_t timer; // NOTE: cannot initialize default value in C99
    struct Cell board[BOARD_SIZE][BOARD_SIZE];
};

union Move { // 32 bit integer representing a move
    struct
    {
        uint8_t x                : 8;
        uint8_t y                : 8;
        enum Direction direction : 4;
        enum Mode type           : 4;
        enum Player player_id    : 8;
    };

    uint32_t as_uint32_t;
};

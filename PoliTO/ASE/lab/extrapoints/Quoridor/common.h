#pragma once

#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION < 6000000)
#pragma anon_unions // needed for compiler v5
#endif

#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6000000)
// padding size of 'struct Board' with 2 bytes to alignment boundary
#pragma clang diagnostic ignored "-Wpadded"
#endif

#include "utils/dynarray.h"
#include <stdbool.h>
#include <stdint.h>

#ifndef NULL
#define NULL 0
#endif

#define RIT_MS 50
#define RIT_TIME 0x004C4B40 // 50ms polling

#define SIMULATOR 1

#define BOARD_SIZE 7
#define BOARD_TIMER 20 // timer in seconds
#define WALL_COUNT 8

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#define RAND(min, max) ((rand() % (max - min + 1)) + min)

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
    uint16_t x;
    uint16_t y;
};

enum Mode
{
    PLAYER_MOVE = 0,
    WALL_PLACEMENT = 1,
    GAME_MODE_SELECTION = 2,
    SINGLE_BOARD_MENU = 3,
    TWO_BOARDS_MENU = 4,
    COLOR_SELECTION_MENU = 5
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
            bool left       : 1;
            bool right      : 1;
            bool top        : 1;
            bool bottom     : 1;
            uint8_t padding : 4; // otherwise the behaviour is not defined
        };

        uint8_t as_uint8_t;
    } walls;

    uint16_t x; // absolute position in pixel
    uint16_t y; // absolute position in pixel
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

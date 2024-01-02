#pragma once
#pragma anon_unions

#include "utils/dynarray.h"
#include <stdbool.h>
#include <stdint.h>

#ifndef NULL
#define NULL 0
#endif

#define BOARD_SIZE 7
#define BOARD_TIMER 20 // timer in seconds
#define WALL_COUNT 8

enum Player
{
    RED = 0,
    WHITE = 1,
    NONE = UINT8_MAX
};

struct Coordinate // TODO: remove if only used in struct Cell
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

    struct
    {
        bool left;
        bool right;
        bool top;
        bool bottom;
    } walls;

    struct Coordinate position; // starting pixel of the cell
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
        uint32_t X                           : 8;
        uint32_t Y                           : 8;
        uint32_t Vertical_or_Horizontal      : 4;
        uint32_t PlayerMove_or_WallPlacement : 4;
        uint32_t PlayerID                    : 8; // 0: RED, 1: WHITE
    };

    uint32_t as_uint32_t;
};

union Move2 { // 32 bit integer representing a move
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

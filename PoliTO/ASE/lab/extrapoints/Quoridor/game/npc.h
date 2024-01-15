#pragma once

#include "../common.h"

struct _Tuple
{
    struct Coordinate co;
    enum Direction dir;
    uint32_t it;
};

void AI_move(void);

struct Coordinate choose_move(void);

struct Coordinate calculate_best_move(const enum Player player, uint32_t *it);

struct _Tuple choose_wall(void);

void update_choice_weight(float *move_choice_weight, const float eta);

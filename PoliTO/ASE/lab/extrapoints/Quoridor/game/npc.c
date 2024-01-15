#pragma diag_suppress 68 // integer conversion resulted in a change of sign

#include "npc.h"
#include "game.h"
#include <stdint.h>
#include <stdlib.h>

extern enum Player opponent;
extern union Move current_possible_moves[5];

extern struct PlayerInfo red;
extern struct PlayerInfo white;

// cached for performance, modify if AI vs AI mode is needed
// (i.e. for training a neural network)
static const struct PlayerInfo *me;

struct Coordinate choose_move(void)
{
    struct Coordinate best_y = {0, opponent == WHITE ? UINT8_MAX : 0};
    for (int i = 0; i < 5 && current_possible_moves[i].as_uint32_t != -1; i++)
    {
        if (opponent == WHITE ? current_possible_moves[i].y < best_y.y :
                                current_possible_moves[i].y > best_y.y)
            ;
        {
            best_y.y = current_possible_moves[i].y;
            best_y.x = current_possible_moves[i].x;
        }
    }
    return best_y;
}

struct Coordinate choose_wall(void)
{
    struct Coordinate wall_positions[6 * 6 * 2] = {0};
}

struct Coordinate calculate_best_move(const enum Player player)
{
    struct Coordinate best_y = {0, opponent == WHITE ? UINT8_MAX : 0};
}

void update_choice_weight(float *move_choice_weight, const float eta)
{
    uint8_t vs_dist = opponent == RED ? white.y : 1 - red.y;
    uint8_t my_dist = opponent == RED ? 1 - red.y : white.y;

    // Opponent getting closer to the winning side increases likelihood of wall
    *move_choice_weight -= eta * vs_dist;

    // My pawn getting closer to the winning side increase likelihood of move
    *move_choice_weight += eta * my_dist;
}

void AI_move(void)
{
    // decreases when a wall placement is more advantageous,
    // increases when it's better to move the pawn
    static float move_choice_weight = 0.5;
    static const float eta = 0.125;
    struct Coordinate co;

    static bool flag = true;
    if (flag) // executes only once
    {
        me = opponent == RED ? &red : &white;
        flag = false;
    }

    update_choice_weight(&move_choice_weight, eta);

    if (RAND(0, 1) > move_choice_weight && me->wall_count > 0) // place wall
    {
        co = choose_wall();
        place_wall(co.x, co.y);
    }
    else // move pawn
    {
        co = choose_move();
        move_player(co.x, co.y);
    }
}

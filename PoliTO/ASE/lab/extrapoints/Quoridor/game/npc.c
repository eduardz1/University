#include <cstdint>
#pragma diag_suppress 68 // integer conversion resulted in a change of sign

#include "game.h"
#include "npc.h"
#include <stdint.h>
#include <stdlib.h>

extern enum Player opponent; // I AM THE OPPONENT!
extern union Move current_possible_moves[5];

extern struct PlayerInfo red;
extern struct PlayerInfo white;

extern enum Direction direction;

// cached for performance, modify if AI vs AI mode is needed
// (i.e. for training a neural network)
static const struct PlayerInfo *me;

struct Coordinate choose_move(void)
{
    uint32_t it = 0; // UNUSED
    return calculate_best_move(opponent, &it);
}

struct _Tuple choose_wall(void)
{
    uint32_t it;
    uint32_t last_it = 0;
    struct _Tuple random_wall;

    uint8_t size = 0;
    struct Coordinate wall_positions[(BOARD_SIZE - 2) * (BOARD_SIZE - 2)];
    for (uint8_t x = 0; x < BOARD_SIZE - 2; x++)
    {
        for (uint8_t y = 0; y < BOARD_SIZE - 2; y++)
        {
            wall_positions[size].x = x;
            wall_positions[size++].y = y;
        }
    }

    struct _Tuple best_walls[size];
    uint8_t size_walls = 0;
    // wall placement affects 4 cells
    const struct Coordinate neighbors[] = {
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    uint8_t walls_backup[ARRAY_SIZE(neighbors)];

    // choose wall that makes the opponent's opponent best path longer
    for (uint8_t i = 0; i < size; i++)
    {
        struct Coordinate co = wall_positions[i];

        if (is_wall_valid(co.x, co.y, VERTICAL))
        {
            random_wall = (struct _Tuple){co, VERTICAL, it};
            calculate_best_move(opponent == RED ? WHITE : RED, &it);
            last_it = it;

            backup_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

            place_wall(co.x, co.y);
            calculate_best_move(opponent == RED ? WHITE : RED, &it);

            if (last_it < it) // if it takes longer for the opponent's opponent
                best_walls[size_walls++] =
                    (struct _Tuple){.co = co, .dir = VERTICAL, .it = it};

            rollback_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
        }

        if (is_wall_valid(co.x, co.y, HORIZONTAL))
        {
            random_wall = (struct _Tuple){co, HORIZONTAL, it};
            calculate_best_move(opponent == RED ? WHITE : RED, &it);
            last_it = it;

            backup_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

            place_wall(co.x, co.y);
            calculate_best_move(opponent == RED ? WHITE : RED, &it);

            if (last_it < it) // if it takes longer for the opponent's opponent
                best_walls[size_walls++] =
                    (struct _Tuple){.co = co, .dir = HORIZONTAL, .it = it};

            rollback_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
        }
    }

    if (size_walls == 0) return random_wall;

    struct _Tuple best_walls2[size_walls];
    uint8_t size_walls2 = 0;

    // choose wall that does not make my path longer
    for (uint8_t i = 0; i < size_walls; i++)
    {
        struct Coordinate co = best_walls[i].co;
        enum Direction dir = best_walls[i].dir;
        uint32_t curr_it = best_walls[i].it;

        if (is_wall_valid(co.x, co.y, dir))
        {
            calculate_best_move(opponent, &it);
            last_it = it;

            backup_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

            place_wall(co.x, co.y);
            calculate_best_move(opponent, &it);

            if (last_it >= it) // if it does not take longer for the opponent
                best_walls2[size_walls2++] =
                    (struct _Tuple){.co = co, .dir = dir, .it = it};

            rollback_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
        }
    }

    if (size_walls2 == 0)
        return (struct _Tuple){
            best_walls[0].co, best_walls[0].dir, best_walls[0].it};

    struct _Tuple best_wall = best_walls2[0];
    last_it = best_walls2[0].it;

    for (int i = 0; i < size_walls2; i++)
    {
        if (best_walls2[i].it > last_it) best_wall = best_walls2[i];
    }

    return best_wall;
}

// Can also be used for the opponent's opponent to calculate better heuristics
// for wall placement
struct Coordinate calculate_best_move(const enum Player player, uint32_t *it)
{
    const uint8_t winning_y = player == RED ? BOARD_SIZE - 1 : 0;
    struct Coordinate best_move = {0};
    uint32_t last_it = UINT32_MAX;

    // iterates over all the possible moves and selects the one that takes less
    // iterations of the path-finding algorithm
    for (int i = 0; i < 5 && current_possible_moves[i].as_uint32_t != -1; i++)
    {
        *it = 0;
        // TODO: can be improved with a shortest path algorithm i.e. A*,
        // Dijkstra ecc...
        if (find_path(current_possible_moves[i].x,
                      current_possible_moves[i].y,
                      it,
                      winning_y) &&
            *it < last_it)
        {
            best_move.x = current_possible_moves[i].x;
            best_move.y = current_possible_moves[i].y;

            last_it = *it;
        }
    }

    *it = last_it;
    return best_move;
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
        struct _Tuple tu = choose_wall();
        direction = tu.dir;
        co = tu.co;
        place_wall(co.x, co.y);
    }
    else // move pawn
    {
        co = choose_move();
        move_player(co.x, co.y);
    }
}

#include <string.h>
#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION < 6000000)
#pragma diag_suppress 68 // integer conversion resulted in a change of sign
#pragma anon_structs
#endif

#include "../game/graphics.h"
#include "../utils/headers/astar.h"
#include "../utils/headers/sort.h"
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

static uint8_t heuristic(uint8_t x, uint8_t y, uint8_t goal)
{
    return goal == BOARD_SIZE - 1 ? BOARD_SIZE - 1 - y : y;
}

struct Coordinate
calculate_best_move(const struct PlayerInfo *player, uint8_t *path_length)
{
    struct Coordinate best_move;
    struct Node start = (struct Node){player->x, player->y, 0, 0};

    calculate_possible_moves(player->player_id); // TODO: can be optimized

    struct Coordinate starter_neighbors[5];
    uint8_t starter_neighbors_length = 0;
    for (uint8_t i = 0; i < 5; i++)
    {
        if (current_possible_moves[i].as_uint32_t != -1)
        {
            starter_neighbors[starter_neighbors_length++] = (struct Coordinate){
                current_possible_moves[i].x, current_possible_moves[i].y};
        }
    }

    struct Node **path = astar(&start,
                               player->player_id == RED ? BOARD_SIZE - 1 : 0,
                               heuristic,
                               starter_neighbors,
                               starter_neighbors_length,
                               path_length);

    best_move = (struct Coordinate){path[1]->x, path[1]->y};

    for (uint8_t i = 0; i < *path_length; free(path[i++]))
        ;
    free(path);

    calculate_possible_moves(me->player_id); // reset current moves

    return best_move;
}

struct Coordinate choose_move(void)
{
    uint8_t path_length = 0; // UNUSED
    return calculate_best_move(me, &path_length);
}

struct _Tuple choose_random_valid_wall()
{
    static const struct Coordinate neighbors[] = {
  // wall placement affects 4 cells
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    struct _Tuple valid_walls[(BOARD_SIZE - 1) * (BOARD_SIZE - 1) * 2] = {0};
    uint8_t valid_walls_size = 0;
    uint8_t walls_backup[ARRAY_SIZE(neighbors)];

    for (uint8_t i = 0; i < (BOARD_SIZE - 1) * (BOARD_SIZE - 1); i++)
    {
        // initializing coordinate like this ensures we are iterating over all
        // of the possible coordinates. For example with BOARD_SIZE equal to 5
        // the first iterations will be: (0,0) (1,0) (2,0) (0,1) (1,1) (2,1) ..
        struct Coordinate co = {i % (BOARD_SIZE - 1), i / (BOARD_SIZE - 1)};

        for (enum Direction dir = VERTICAL; dir <= HORIZONTAL; dir++)
        {
            if (is_wall_clipping(co.x, co.y, dir)) continue;

            backup_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

            place_tmp_wall(dir, co.x, co.y);

            if (is_wall_valid(co.x, co.y, dir))
                valid_walls[valid_walls_size++] = (struct _Tuple){co, dir, 0};

            rollback_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
        }
    }

    return valid_walls[RAND(0, valid_walls_size - 1)];
}

struct _Tuple choose_defensive_wall(const uint8_t path)
{
    static const struct Coordinate neighbors[] = {
  // wall placement affects 4 cells
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    uint8_t last_path_length;
    struct PlayerInfo opponent = me->player_id == RED ? white : red;

    struct Cell board_backup[BOARD_SIZE][BOARD_SIZE];
    memcpy(board_backup, board.board, sizeof(board.board));
    struct _Tuple good_walls[(BOARD_SIZE - 1) * (BOARD_SIZE - 1) * 2] = {0};
    uint16_t good_walls_size = 0;

    struct _Tuple tu = choose_wall(opponent.player_id);
    last_path_length = tu.path;

    // CHOOSE A WALL THAT MAKES THE MAIN CHARACTER's PATH LONGER
    for (uint8_t i = 0; i < (BOARD_SIZE - 1) * (BOARD_SIZE - 1); i++)
    {
        // initializing coordinate like this ensures we are iterating over all
        // of the possible coordinates. For example with BOARD_SIZE equal to 5
        // the first iterations will be: (0,0) (1,0) (2,0) (0,1) (1,1) (2,1) ...
        struct Coordinate co = {i % (BOARD_SIZE - 1), i / (BOARD_SIZE - 1)};

        for (enum Direction dir = VERTICAL; dir <= HORIZONTAL; dir++)
        {
            if (is_wall_clipping(co.x, co.y, dir)) continue;

            place_tmp_wall(dir, co.x, co.y);

            if (is_wall_valid(co.x, co.y, dir))
            {
                tu = choose_wall(opponent.player_id);

                if (last_path_length >= tu.path)
                {
                    good_walls[good_walls_size++] =
                        (struct _Tuple){co, dir, tu.path};
                }

                last_path_length = tu.path;
            }

            for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
            { // TODO: analyze if it's faster to only restore .walls
                board.board[co.x + neighbors[i].x][co.y + neighbors[i].y] =
                    board_backup[co.x + neighbors[i].x][co.y + neighbors[i].y];
            }
        }
    }

    // no walls that can defend the NPC
    if (good_walls_size == 0) return (struct _Tuple){0};

    sort(good_walls, sizeof(struct _Tuple), good_walls_size, compare_tuple);

    struct _Tuple best_wall = good_walls[0];
    uint8_t path_length = 0;

    // FILTER OUT WALL MOVES THAT MAKE MY PATH LONGER
    for (uint8_t i = 0; i < good_walls_size; i++)
    {
        struct Coordinate co = good_walls[i].co;

        place_tmp_wall(good_walls[i].dir, co.x, co.y);

        calculate_best_move(opponent.player_id == RED ? &white : &red,
                            &path_length);

        // can even shorten the path when placing a wall enables a diagonal
        // movement, take it with the equal because the last walls in the list
        // are the better ones
        if (last_path_length >= path_length)
        {
            last_path_length = path_length;
            best_wall = good_walls[i];
        }

        for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
        { // TODO: analyze if it's faster to only restore .walls
            board.board[co.x + neighbors[i].x][co.y + neighbors[i].y] =
                board_backup[co.x + neighbors[i].x][co.y + neighbors[i].y];
        }
    }

    return best_wall;
}

struct Coordinate choose_random_valid_move()
{
    uint8_t valid_moves = 0;
    for (uint8_t i = 0; i < 5; i++)
    {
        if (current_possible_moves[i].as_uint32_t != (uint32_t)-1)
            valid_moves++;
    }

    uint8_t index = RAND(0, valid_moves);
    return (struct Coordinate){current_possible_moves[index].x,
                               current_possible_moves[index].y};
}

struct _Tuple choose_wall(enum Player player)

{
    static const struct Coordinate neighbors[] = {
  // wall placement affects 4 cells
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    uint8_t path_length;
    uint8_t last_path_length;
    struct PlayerInfo opponent = player == RED ? white : red;
    struct Cell board_backup[BOARD_SIZE][BOARD_SIZE];
    memcpy(board_backup, board.board, sizeof(board.board));

    struct _Tuple good_walls[(BOARD_SIZE - 1) * (BOARD_SIZE - 1) * 2] = {0};
    uint16_t good_walls_size = 0;

    calculate_best_move(&opponent, &path_length);
    last_path_length = path_length;

    // CHOOSE A WALL THAT MAKES THE MAIN CHARACTER's PATH LONGER
    for (uint8_t i = 0; i < (BOARD_SIZE - 1) * (BOARD_SIZE - 1); i++)
    {
        // initializing coordinate like this ensures we are iterating over all
        // of the possible coordinates. For example with BOARD_SIZE equal to 5
        // the first iterations will be: (0,0) (1,0) (2,0) (0,1) (1,1) (2,1) ...
        struct Coordinate co = {i % (BOARD_SIZE - 1), i / (BOARD_SIZE - 1)};

        for (enum Direction dir = VERTICAL; dir <= HORIZONTAL; dir++)
        {
            if (is_wall_clipping(co.x, co.y, dir)) continue;

            place_tmp_wall(dir, co.x, co.y);

            if (is_wall_valid(co.x, co.y, dir))
            {
                calculate_best_move(&opponent, &path_length);

                if (last_path_length < path_length)
                {
                    good_walls[good_walls_size++] =
                        (struct _Tuple){co, dir, path_length};
                }
            }

            for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
            { // TODO: analyze if it's faster to only restore .walls
                board.board[co.x + neighbors[i].x][co.y + neighbors[i].y] =
                    board_backup[co.x + neighbors[i].x][co.y + neighbors[i].y];
            }
        }
    }

    // no walls that can impede the main character
    if (good_walls_size == 0) return (struct _Tuple){0};

    // sort so that the walls that better block the player's movement
    //  are last in the array
    sort(good_walls, sizeof(struct _Tuple), good_walls_size, compare_tuple);

    // worst cane scenario: no wall exists that does not sabotage me, take the
    // last good one that still slows the main character down
    struct _Tuple best_wall = good_walls[good_walls_size - 1];
    calculate_best_move(opponent.player_id == RED ? &white : &red,
                        &path_length);
    last_path_length = path_length;

    // FILTER OUT WALL MOVES THAT MAKE MY PATH LONGER
    for (uint8_t i = 0; i < good_walls_size; i++)
    {
        struct Coordinate co = good_walls[i].co;

        place_tmp_wall(good_walls[i].dir, co.x, co.y);

        calculate_best_move(opponent.player_id == RED ? &white : &red,
                            &path_length);

        // can even shorten the path when placing a wall enables a diagonal
        // movement, take it with the equal because the last walls in the list
        // are the better ones
        if (last_path_length >= path_length)
        {
            last_path_length = path_length;
            best_wall = good_walls[i];
        }

        for (uint8_t i = 0; i < ARRAY_SIZE(neighbors); i++)
        { // TODO: analyze if it's faster to only restore .walls
            board.board[co.x + neighbors[i].x][co.y + neighbors[i].y] =
                board_backup[co.x + neighbors[i].x][co.y + neighbors[i].y];
        }
    }

    return best_wall;
}

bool can_make_winning_move(enum Player player)
{
    bool flag = false;
    uint8_t winning_y = player == RED ? BOARD_SIZE - 1 : 0;
    calculate_possible_moves(player);
    for (uint8_t i = 0; i < 5; i++)
    {
        if (current_possible_moves[i].y == winning_y) flag = true;
    }
    calculate_possible_moves(me->player_id); // TODO make possible moves return
                                             // instead of always acting on
                                             // global variables
    return flag;
}

bool try_make_winning_move(bool *has_walls)
{
    if (can_make_winning_move(me->player_id))
    {
        move_player(me->x, me->player_id == RED ? BOARD_SIZE - 1 : 0);
        return true;
    }
    return false;
}

bool try_place_blocking_wall(bool *has_walls)
{
    if (*has_walls && can_make_winning_move(me->player_id == RED ? WHITE : RED))
    {
        clear_highlighted_moves();

        struct _Tuple tu = choose_wall(me->player_id);

        if (tu.path != 0)
        {
            direction = tu.dir;
            place_wall(tu.co.x, tu.co.y);
            return true;
        }
    }
    return false;
}

bool try_place_random_wall(bool *has_walls)
{
    if (*has_walls)
    {
        clear_highlighted_moves();

        struct _Tuple tu = choose_random_valid_wall();
        direction = tu.dir;
        place_wall(tu.co.x, tu.co.y);
        return true;
    }
    return false;
}

bool try_make_random_move(bool *has_walls)
{
    struct Coordinate co = choose_random_valid_move();
    move_player(co.x, co.y);
    return true;
}

bool try_place_offensive_wall(bool *has_walls)
{
    if (*has_walls)
    {
        clear_highlighted_moves();

        struct _Tuple tu = choose_wall(me->player_id);

        if (tu.path != 0)
        {
            direction = tu.dir;
            place_wall(tu.co.x, tu.co.y);
            return true;
        }
    }
    return false;
}

bool try_place_defensive_wall(bool *has_walls)
{
    if (*has_walls)
    {
        clear_highlighted_moves();

        struct _Tuple tu = choose_wall(me->player_id == RED ? WHITE : RED);

        if (tu.path == 0) return false;

        tu = choose_defensive_wall(tu.path);
        if (tu.path == 0) return false;

        direction = tu.dir;
        place_wall(tu.co.x, tu.co.y);
        return true;
    }
    return false;
}

bool try_make_move(bool *has_walls)
{
    struct Coordinate co = choose_move();

    for (uint8_t i = 0; i < 5; i++) // check if the move is valid
    {
        if (current_possible_moves[i].x == co.x &&
            current_possible_moves[i].x == co.x)
        {
            move_player(co.x, co.y);
            return true;
        }
    }
    return false;
}

void AI_move(void)
{
    // action strategies with cumulative probability of being chosen
    static struct
    {
        uint8_t probability;
        bool (*strategy)(bool *);
    } strategies[] = {
  // unconditional
        {100,    try_make_winning_move},
        {100,  try_place_blocking_wall},
 // explore
        {  2,    try_place_random_wall},
        {  4,     try_make_random_move},
 // exploit
        { 19, try_place_defensive_wall},
        { 54, try_place_offensive_wall},
        {100,            try_make_move}
    };

    static bool flag = true;
    if (flag) // executes only once
    {
        me = opponent == RED ? &red : &white;
        flag = false;
    }
    bool has_walls = me->wall_count > 0;

    uint8_t extracted = RAND(0, 100);

    // select strategy base on probability and wether or not last strategy
    // succeeded
    for (uint8_t i = 0; i < ARRAY_SIZE(strategies); i++)
    {
        if (extracted <= strategies[i].probability &&
            strategies[i].strategy(&has_walls))
            return;
    }

    // if everything else fails, select first of the possible moves
    move_player(current_possible_moves[0].x, current_possible_moves[0].y);
}

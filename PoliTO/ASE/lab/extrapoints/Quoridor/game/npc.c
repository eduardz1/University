#include <string.h>
#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION < 6000000)
#pragma diag_suppress 68 // integer conversion resulted in a change of sign
#endif

#include "../game/graphics.h"
#include "../utils/headers/astar.h"
#include "../utils/headers/insert_sort.h"
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

static uint8_t heuristic(struct Coordinate *node, struct Coordinate *winning)
{
    return abs(node->y - winning->y);
}

static struct Coordinate
_calculate_best_move(const struct PlayerInfo *player, uint8_t *path_length)
{
    struct Coordinate best_move;
    struct Node *start = node_new(player->x, player->y, 0, 0);
    if (start == NULL) exit(1); // out of memory

    calculate_possible_moves(player->player_id); // TODO: can be optimized

    struct Coordinate starter_neighbors[5];
    for (uint8_t i = 0; i < 5; i++)
    {
        struct Coordinate neigh = {UINT8_MAX, UINT8_MAX};
        if (current_possible_moves[i].as_uint32_t != -1)
        {
            neigh.x = current_possible_moves[i].x;
            neigh.y = current_possible_moves[i].y;
        }
        starter_neighbors[i] = neigh;
    }

    struct Coordinate co = astar(start,
                                 player->player_id == RED ? BOARD_SIZE - 1 : 0,
                                 heuristic,
                                 starter_neighbors,
                                 path_length);

    free(start);
    best_move = (struct Coordinate){co.x, co.y};

    calculate_possible_moves(me->player_id); // reset current moves

    return best_move;
}

struct Coordinate choose_move(void)
{
    return (struct Coordinate){0, 0};
    uint8_t path_length = 0; // UNUSED
    return _calculate_best_move(me, &path_length);
}

// TODO: no use right now
// void update_choice_weight(float *move_choice_weight, const float eta)
// {
//     uint8_t vs_dist = opponent == RED ? white.y : 1 - red.y;
//     uint8_t my_dist = opponent == RED ? 1 - red.y : white.y;

//     // Opponent getting closer to the winning side increases likelihood of
//     wall *move_choice_weight -= eta * vs_dist;

//     // My pawn getting closer to the winning side increase likelihood of move
//     *move_choice_weight += eta * my_dist;
// }

struct _Tuple choose_random_valid_wall()
{
    struct _Tuple valid_walls[(BOARD_SIZE - 2) * (BOARD_SIZE - 2) * 2] = {0};
    uint8_t valid_walls_size = 0;
    // wall placement affects 4 cells
    const struct Coordinate neighbors[] = {
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    uint8_t walls_backup[ARRAY_SIZE(neighbors)];

    for (uint8_t i = 0; i < (BOARD_SIZE - 2) * (BOARD_SIZE - 2); i++)
    {
        // initializing coordinate like this ensures we are iterating over all
        // of the possible coordinates. For example with BOARD_SIZE equal to 5
        // the first iterations will be: (0,0) (1,0) (2,0) (0,1) (1,1) (2,1) ..
        struct Coordinate co = {i % (BOARD_SIZE - 2), i / (BOARD_SIZE - 2)};

        for (enum Direction dir = VERTICAL; dir <= HORIZONTAL; dir++)
        {
            if (is_wall_clipping(co.x, co.y, dir)) continue;

            backup_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

            switch (dir)
            {
            case HORIZONTAL:
                board.board[co.x][co.y].walls.bottom = true;
                board.board[co.x + 1][co.y].walls.bottom = true;
                board.board[co.x][co.y + 1].walls.top = true;
                board.board[co.x + 1][co.y + 1].walls.top = true;
                break;
            case VERTICAL:
                board.board[co.x][co.y].walls.right = true;
                board.board[co.x + 1][co.y].walls.left = true;
                board.board[co.x][co.y + 1].walls.right = true;
                board.board[co.x + 1][co.y + 1].walls.left = true;
                break;
            }

            if (is_wall_valid(co.x, co.y, dir))
                valid_walls[valid_walls_size++] = (struct _Tuple){co, dir, 0};

            rollback_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
        }
    }

    return valid_walls[RAND(0, valid_walls_size - 1)];
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

struct _Tuple choose_wall() // can self-sabotage
{
    uint8_t path_length;
    uint8_t last_path_length;
    struct PlayerInfo main_character = me->player_id == RED ? white : red;

    // wall placement affects 4 cells
    const struct Coordinate neighbors[] = {
        {0, 0},
        {1, 0},
        {0, 1},
        {1, 1}
    };
    uint8_t walls_backup[ARRAY_SIZE(neighbors)];
    struct _Tuple good_walls[(BOARD_SIZE - 2) * (BOARD_SIZE - 2) * 2] = {0};
    uint16_t good_walls_size = 0;

    _calculate_best_move(&main_character, &path_length);
    last_path_length = path_length;

    // CHOOSE A WALL THAT MAKES THE MAIN CHARACTER's PATH LONGER
    for (uint8_t i = 0; i < (BOARD_SIZE - 2) * (BOARD_SIZE - 2); i++)
    {
        // initializing coordinate like this ensures we are iterating over all
        // of the possible coordinates. For example with BOARD_SIZE equal to 5
        // the first iterations will be: (0,0) (1,0) (2,0) (0,1) (1,1) (2,1) ...
        struct Coordinate co = {i % (BOARD_SIZE - 2), i / (BOARD_SIZE - 2)};

        for (enum Direction dir = VERTICAL; dir <= HORIZONTAL; dir++)
        {
            if (is_wall_clipping(co.x, co.y, dir)) continue;

            backup_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

            switch (dir)
            {
            case HORIZONTAL:
                board.board[co.x][co.y].walls.bottom = true;
                board.board[co.x + 1][co.y].walls.bottom = true;
                board.board[co.x][co.y + 1].walls.top = true;
                board.board[co.x + 1][co.y + 1].walls.top = true;
                break;
            case VERTICAL:
                board.board[co.x][co.y].walls.right = true;
                board.board[co.x + 1][co.y].walls.left = true;
                board.board[co.x][co.y + 1].walls.right = true;
                board.board[co.x + 1][co.y + 1].walls.left = true;
                break;
            }

            if (is_wall_valid(co.x, co.y, dir))
            {
                _calculate_best_move(&main_character, &path_length);

                if (last_path_length < path_length)
                {
                    good_walls[good_walls_size++] =
                        (struct _Tuple){co, dir, path_length};
                }
            }

            rollback_walls(
                co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
        }
    }

    if (good_walls_size == 0) // no walls that can impede the main character
        return (struct _Tuple){
            {0, 0},
            0, UINT8_MAX  // TODO: document error
        };

    // sort so that the walls that better block the player's movement
    //  are last in the array
    insert_sort(
        good_walls, sizeof(struct _Tuple), good_walls_size, compare_tuple);

    // worst cane scenario: no wall exists that does not sabotage me, take the
    // last good one that still slows the main character down
    struct _Tuple best_wall = good_walls[good_walls_size - 1];
    _calculate_best_move(me, &path_length);
    last_path_length = path_length;

    // FILTER OUT WALL MOVES THAT MAKE MY PATH LONGER
    for (uint8_t i = 0; i < good_walls_size; i++)
    {
        struct Coordinate co = good_walls[i].co;

        backup_walls(
            co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));

        switch (good_walls[i].dir)
        {
        case HORIZONTAL:
            board.board[co.x][co.y].walls.bottom = true;
            board.board[co.x + 1][co.y].walls.bottom = true;
            board.board[co.x][co.y + 1].walls.top = true;
            board.board[co.x + 1][co.y + 1].walls.top = true;
            break;
        case VERTICAL:
            board.board[co.x][co.y].walls.right = true;
            board.board[co.x + 1][co.y].walls.left = true;
            board.board[co.x][co.y + 1].walls.right = true;
            board.board[co.x + 1][co.y + 1].walls.left = true;
            break;
        }

        _calculate_best_move(me, &path_length);

        // can even shorten the path when placing a wall enables a diagonal
        // movement, take it with the equal because the last walls in the list
        // are the better ones
        if (last_path_length >= path_length)
        {
            last_path_length = path_length;
            best_wall = good_walls[i];
        }

        rollback_walls(
            co.x, co.y, walls_backup, neighbors, ARRAY_SIZE(neighbors));
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

void AI_move(void)
{
    struct Coordinate co;
    bool has_walls = me->wall_count > 0;

    static bool flag = true;
    if (flag) // executes only once
    {
        me = opponent == RED ? &red : &white;
        flag = false;
    }

    // move unconditionally if I can win
    if (can_make_winning_move(me->player_id))
    {
        move_player(me->x, me->player_id == RED ? BOARD_SIZE - 1 : 0);
        return;
    }

    // place wall unconditionally to try to stop the main character if he is
    // about to win
    if (has_walls && can_make_winning_move(me->player_id == RED ? WHITE : RED))
    {
        clear_highlighted_moves();

        struct _Tuple tu = choose_wall();

        if (tu.path != UINT8_MAX)
        {
            direction = tu.dir;
            co = tu.co;
            place_wall(co.x, co.y);
            return;
        }

        // LOST :(
    }

    /* POLICY:
     *
     * -  2% of the time place a random wall  | <-- (explore)
     * -  2% of the time choose a random move |
     *
     * - 40% of the time place a wall that would best slow | <- (exploit)
     *       down the main character's path, computed by   |
     *       calculating its respective optimal, without   |
     *       slowing ourselves down, if possible. If no    |
     *       wall exists that can at least slow the main   |
     *       character down, then move instead             |
     * - 56% of the time move to the best cell, calculated |
     *       with a shortest path algorithm (A*)           |
     */
    float extracted = RAND(0, 100);

    if (extracted < 2 && has_walls) // random wall
    {
        clear_highlighted_moves();

        struct _Tuple tu = choose_random_valid_wall();
        direction = tu.dir;
        co = tu.co;
        place_wall(co.x, co.y);
        return;
    }
    else if (extracted >= 2 && extracted < 4) // random move
    {
        co = choose_random_valid_move();
        move_player(co.x, co.y);
        return;
    }
    else
    {
        if (extracted >= 4 && extracted < 44 && has_walls) // wall
        {
            clear_highlighted_moves();

            struct _Tuple tu = choose_wall();

            if (tu.path == UINT8_MAX)
            {
                extracted = 44;
            }
            else
            {
                direction = tu.dir;
                co = tu.co;
                place_wall(co.x, co.y);
                return;
            }
        }

        if (extracted >= 44 || !has_walls) // move pawn
        {
            co = choose_move();

            for (uint8_t i = 0; i < 5; i++) // check if the move is valid
            {
                if (current_possible_moves[i].x == co.x &&
                    current_possible_moves[i].x == co.x)
                {
                    move_player(co.x, co.y);
                    return;
                }
            }

            move_player(current_possible_moves[0].x,
                        current_possible_moves[0].y);

            return;
        }
    }

    exit(1); // TODO: cleanup these returns everywhere but check that logically
             // the NPC makes a move for every turn
}

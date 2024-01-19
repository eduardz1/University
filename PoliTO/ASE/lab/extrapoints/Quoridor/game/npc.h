#pragma once

#include "../common.h"

struct _Tuple
{
    struct Coordinate co;
    enum Direction dir;
    uint8_t path;
};

void AI_move(void);

/**
 * @param player the player for which to check if a winning move can be made
 * @return true if a winning move can be made, false otherwise
 */
bool can_make_winning_move(enum Player player);

/**
 * @brief chooses the next move for the AI based on #_calculate_best_move
 *
 * @return struct Coordinate {x, y} on the board of the chosen move
 */
struct Coordinate choose_move(void);

/**
 * @brief calculates the best move for the #player using the A* algorithm.
 *
 * @param player the player for which to calculate the best move
 * @param path_length the length of the path to the best move
 * @return struct Coordinate {x, y} on the board of the best move
 */
struct Coordinate
calculate_best_move(const struct PlayerInfo *player, uint8_t *path_length);

/**
 * @brief choose a wall that best slows down the main character's path without
 * making our path longer
 *
 * @return struct _Tuple containing the coordinates of the wall and its
 * direction, if no wall exists that can at least slow the main character down,
 * then path length is set to UINT8_MAX. If no wall exists that can be placed
 * without sabotaging our path, returns a wall that can at least slow the main
 * character down
 */
struct _Tuple choose_wall(void);

/**
 * @brief chooses a random wall from the set of valid walls
 *
 * @return struct _Tuple containing the coordinates of the wall and its
 * direction, path length is set to 0
 */
struct _Tuple choose_random_valid_wall();

/**
 * @brief chooses a move randomly from the set of current possible moves
 *
 * @return struct Coordinate {x, y} on the board of the chosen move
 */
struct Coordinate choose_random_valid_move();

/********************************* STRATEGIES *********************************/

/**
 * @brief tries to make a winning move based on #can_make_winning_move on NPC
 *
 * @param has_walls UNUSED
 * @return true if a winning move was made
 * @return false otherwise
 */
bool try_make_winning_move(bool *has_walls);

/**
 * @brief tries to place a blocking wall that prevents the main character from
 * reaching the winning row
 *
 * @param has_walls whether or not the player has walls
 * @return true if a wall was placed
 * @return false otherwise
 */
bool try_place_blocking_wall(bool *has_walls);

/**
 * @brief tries to place a random wall based on #choose_random_valid_wall
 *
 * @param has_walls whether or not the player has walls
 * @return true if a wall was placed
 * @return false otherwise
 */
bool try_place_random_wall(bool *has_walls);

/**
 * @brief tries to make a random move based on #choose_random_valid_move
 *
 * @param has_walls UNUSED
 * @return true if a move was made
 * @return false otherwise
 */
bool try_make_random_move(bool *has_walls);

/**
 * @brief tries to place a wall based on #choose_wall 's policy
 *
 * @param has_walls whether or not the player has walls
 * @return true if a wall was placed
 * @return false otherwise
 */
bool try_place_wall(bool *has_walls);

/**
 * @brief tries to make a move based on #choose_move 's policy
 *
 * @param has_walls UNUSED
 * @return true if a move was made
 * @return false otherwise
 */
bool try_make_move(bool *has_walls);

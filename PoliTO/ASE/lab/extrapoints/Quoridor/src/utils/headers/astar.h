#pragma once

#include "../../common.h"
#include "../../game/game.h"
#include <stdint.h>

#define ONLY_NEXT_MOVE // not necessary to compute the whole path

struct Node
{
    uint8_t x;
    uint8_t y;
    uint8_t g; // cost from start to current node
    uint8_t h; // heuristic
    uint8_t f; // total cost (g + h)
    struct Node *parent;
};

// typedef uint8_t (*Heuristic)(const uint8_t y, const uint8_t goal);

struct Node *
node_new(const uint8_t x, const uint8_t y, const uint8_t g, const uint8_t h);

#ifdef ONLY_NEXT_MOVE
uint16_t
#else
struct Node **
#endif
reconstruct_path(const struct Node *start,
                 struct Node *goal,
                 uint8_t *path_length);

/**
 * @brief A* search over the board, checking only if the winning row is reached
 *
 * @param start_x starting x
 * @param start_y starting y
 * @param goal winning y coordinate
 * @param heuristic (hard-coded) function that computes the heuristic for the
 * nodes
 * @param starter_neighbors array representing the neighbors of the starter
 * node, given that there are situations where the pawn can also move
 * diagonally, we can pre-compute these cases to improve the accuracy. Must
 * indicate its termination with a {UINT8_MAX, UINT8_MAX} value
 * @param path_length saves the length of the path
 * @return struct Node** the path from #start to #goal or NULL if no path is
 * found
 */
#ifdef ONLY_NEXT_MOVE
uint16_t
#else
struct Node **
#endif
astar(const uint8_t start_x,
      const uint8_t start_y,
      const uint8_t goal,
      const uint8_t starter_neighbors[MAX_NEIGHBORS][2],
      const uint8_t starter_neighbors_length,
      uint8_t *path_length);

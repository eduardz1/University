#pragma once

#include "../../common.h"
#include <stdint.h>

struct Node
{
    uint8_t x;
    uint8_t y;
    uint8_t g; // cost from start to current node
    uint8_t h; // heuristic
    uint8_t f; // total cost (g + h)
    struct Node *parent;
};

typedef uint8_t (*Heuristic)(struct Coordinate *, struct Coordinate *);

struct Node *
node_new(const uint8_t x, const uint8_t y, const uint8_t g, const uint8_t h);

void node_free(struct Node *node);

struct Node **
reconstruct_path(struct Node *start, struct Node *goal, uint8_t *path_length);

/**
 * @brief A* search over the board, checking only if the winning row is reached
 *
 * @param start starting Node
 * @param goal winning y coordinate
 * @param heuristic function that computes the heuristic for the nodes
 * @param starter_neighbors array representing the neighbors of the starter
 * node, given that there are situations where the pawn can also move
 * diagonally, we can pre-compute these cases to improve the accuracy. Must
 * indicate its termination with a {UINT8_MAX, UINT8_MAX} value
 * @param path_length saves the length of the path
 * @return struct Node** the path from #start to #goal or NULL if no path is
 * found
 */
struct Node **astar(struct Node *start,
                    uint8_t goal,
                    Heuristic heuristic,
                    struct Coordinate *starter_neighbors,
                    uint8_t *path_length);

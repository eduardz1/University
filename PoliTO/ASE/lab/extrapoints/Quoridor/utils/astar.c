#include "astar.h"
#include "../game/game.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

struct Node *
node_new(const uint8_t x, const uint8_t y, const uint8_t g, const uint8_t h)
{
    struct Node *node = malloc(sizeof(struct Node));
    if (node != NULL)
    {
        node->x = x;
        node->y = y;
        node->g = g;
        node->h = h;
        node->f = g + h;
        node->parent = NULL;
    }
    return node;
}

void node_free(struct Node *node)
{
    if (node != NULL)
    {
        node_free(node->parent); // recursively free the linked list
        free(node);
    }
}

struct Node **
reconstruct_path(struct Node *start, struct Node *goal, uint8_t *path_length)
{
    struct Node **path =
        (struct Node **)malloc(sizeof(struct Node *) * (goal->g + 1));
    if (path == NULL) return NULL;

    uint8_t path_i = goal->g;
    *path_length = path_i;
    path[path_i] = goal;

    while (goal->y != start->y || goal->x != start->x)
    {
        path[--path_i] = goal->parent;
        goal = goal->parent;
    }

    return path;
}

struct Node **astar(struct Node *start,
                    uint8_t goal,
                    Heuristic heuristic,
                    struct Coordinate *starter_neighbors,
                    uint8_t *path_length)
{
    bool visited[BOARD_SIZE][BOARD_SIZE] = {false};

    struct Node **path;
    *path_length = 0;

    // init set of discovered nodes as array of pointers,
    // small size means it's unefficient to use a priority queue
    struct Node *open_set[BOARD_SIZE * BOARD_SIZE];
    int8_t open_set_size = 1;
    open_set[0] = start;

    // neighboring cells as x and y offset, will replace starter_neighbors after
    // the first pass with the 4 adjacent cells
    struct Coordinate *neigh = starter_neighbors;

    while (open_set_size > 0)
    {
        uint8_t curr_i = 0;
        for (uint8_t i = 1; i < open_set_size; i++)
        { // find the node with the smallest f-value
            if (open_set[i]->f < open_set[curr_i]->f) curr_i = i;
        }

        struct Node *curr = open_set[curr_i];
        if (curr == NULL) return NULL;

        if (curr != start) // defaults to explore the 4 adjacent cells
            neigh = (struct Coordinate[]){
                {curr->x - 1, curr->y + 0},
                {curr->x + 1, curr->y + 0},
                {curr->x + 0, curr->y - 1},
                {curr->x + 0, curr->y + 1},
                {UINT8_MAX,   UINT8_MAX  }
            };

        if (curr->y == goal) // check if we reached the goal
        {
            path = reconstruct_path(start, curr, path_length);
            break;
        }

        // pop the current node from the open set and mark as visited
        open_set[curr_i] = open_set[--open_set_size];
        visited[curr->x][curr->y] = true;

        // iterate over the neighboring cells
        for (uint8_t i = 0; neigh[i].x != UINT8_MAX; i++)
        {
            uint8_t next_x = (uint8_t)neigh[i].x;
            uint8_t next_y = (uint8_t)neigh[i].y;

            // check if the neighbor is within the board boundaries
            if (next_x < 0 || next_x >= BOARD_SIZE || next_y < 0 ||
                next_y >= BOARD_SIZE || visited[next_x][next_y])
                continue;

            if (is_wall_between(curr->x, curr->y, next_x, next_y)) continue;

            // update the tentative g score
            uint8_t tentative_g = curr->g + 1;

            // check if the neighbor is not in the open_set or has a lower g
            bool in_open_set = false;
            int8_t open_set_i = -1;
            for (uint8_t j = 0; j < open_set_size; j++)
            {
                if (open_set[j]->x != next_x || open_set[j]->y != next_y)
                    continue;

                in_open_set = true;
                open_set_i = j;
                break;
            }

            if (in_open_set && tentative_g >= open_set[open_set_i]->g) continue;

            struct Node *neighbor = // push the neighbor into the open set
                node_new(next_x,
                         next_y,
                         tentative_g,
                         heuristic(&(struct Coordinate){next_x, next_y},
                                   &(struct Coordinate){0, goal}));

            neighbor->parent = curr;

            // push neighbor into the open set if not already there
            if (!in_open_set) open_set[open_set_size++] = neighbor;
        }
    }

    return path;
}

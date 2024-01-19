#include "headers/astar.h"
#include "../game/game.h"
#include "headers/comparable.h"
#include "headers/min_heap.h"
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

// struct Coordinate
// reconstruct_path(struct Node *start, struct Node *goal, uint8_t *path_length)
// {
//     struct Node *tmp;

//     *path_length = goal->g;

//     while (goal->y != start->y || goal->x != start->x)
//     {
//         tmp = goal;
//         goal = goal->parent;
//     }

//     return (struct Coordinate){tmp->x, tmp->y};
// }

struct Node **
reconstruct_path(struct Node *start, struct Node *goal, uint8_t *path_length)
{
    struct Node **path = malloc(sizeof(struct Node *) * (goal->g + 1));
    if (path == NULL) return NULL;

    *path_length = goal->g + 1;

    struct Node *tmp = goal;
    for (uint8_t i = goal->g; i > 0; i--)
    {
        path[i] = node_new(tmp->x, tmp->y, tmp->g, tmp->h);
        tmp = tmp->parent;
    }

    path[0] = node_new(start->x, start->y, start->g, start->h);

    return path;
}

static bool
is_node_in_open_set(struct MinHeap *heap, uint8_t x, uint8_t y, uint8_t *i)
{
    for (uint8_t j = 0; j < heap->size; j++)
    {
        struct Node *node = heap->data[j];
        if (node->x == x && node->y == y)
        {
            *i = j;
            return true;
        }
    }
    return false;
}

struct Node **astar(struct Node *start,
                    uint8_t goal,
                    Heuristic heuristic,
                    struct Coordinate *starter_neighbors,
                    uint8_t *path_length)
{
    bool visited[BOARD_SIZE][BOARD_SIZE] = {false};

    // keep track of nodes that have been allocated to free them afterwards
    struct Node *allocated_nodes[BOARD_SIZE * BOARD_SIZE];
    uint16_t allocated_nodes_size = 0;

    struct Node **res;
    *path_length = 0;

    struct MinHeap *open_set =
        new_min_heap(BOARD_SIZE * BOARD_SIZE, compare_nodes);
    min_heap_insert(open_set, start);

    // neighboring cells as x and y offset, will replace starter_neighbors after
    // the first pass with the 4 adjacent cells
    struct Coordinate *neigh = starter_neighbors;

    while (open_set->size > 0)
    {
        struct Node *curr = min_heap_extract(open_set);

        if (curr == NULL) return NULL;
        visited[curr->x][curr->y] = true;

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
            res = reconstruct_path(start, curr, path_length);
            break;
        }

        // iterate over the neighboring cells
        for (uint8_t i = 0; neigh[i].x != UINT8_MAX && i < 5; i++)
        {
            uint8_t next_x = (uint8_t)neigh[i].x;
            uint8_t next_y = (uint8_t)neigh[i].y;

            if (next_x >= BOARD_SIZE || next_y >= BOARD_SIZE ||
                visited[next_x][next_y] ||
                is_wall_between(curr->x, curr->y, next_x, next_y))
                continue;

            // update the tentative g score
            uint8_t tentative_g = curr->g + 1;

            // check if the neighbor is in open set and if the tentative g score
            // is higher than the current g score discard the neighbor
            uint8_t open_set_i;
            bool in_open_set =
                is_node_in_open_set(open_set, next_x, next_y, &open_set_i);
            if (in_open_set &&
                tentative_g >= ((struct Node *)open_set->data[open_set_i])->g)
                continue;

            // link the neighbor to the current node
            struct Node *neighbor =
                node_new(next_x,
                         next_y,
                         tentative_g,
                         heuristic(&(struct Coordinate){next_x, next_y},
                                   &(struct Coordinate){0, goal}));
            allocated_nodes[allocated_nodes_size++] = neighbor;
            neighbor->parent = curr;

            // push neighbor into the open set if not already there
            if (!in_open_set) min_heap_insert(open_set, neighbor);
        }
    }

    min_heap_free(open_set);
    for (uint16_t i = 0; i < allocated_nodes_size; free(allocated_nodes[i++]))
        ;

    return res;
}

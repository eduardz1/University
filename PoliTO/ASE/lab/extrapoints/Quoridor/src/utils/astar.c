#include "headers/astar.h"
#include "../game/game.h"
#include "headers/comparable.h"
#include "headers/min_heap.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_NODES ((BOARD_SIZE) * (BOARD_SIZE))

struct Node node_pool[MAX_NODES] = {0};
uint8_t node_pool_size = 0;

struct Node *
node_new(const uint8_t x, const uint8_t y, const uint8_t g, const uint8_t h)
{
    if (node_pool_size >= MAX_NODES) return NULL;

    struct Node *node = &node_pool[node_pool_size++];
    node->x = x;
    node->y = y;
    node->g = g;
    node->h = h;
    node->f = g + h;
    node->parent = NULL;

    return node;
}

struct Node *node_new_dynamic(const uint8_t x,
                              const uint8_t y,
                              const uint8_t g,
                              const uint8_t h)
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

#ifdef ONLY_NEXT_MOVE
uint16_t
#else
struct Node **
#endif
reconstruct_path(const struct Node *start,
                 struct Node *goal,
                 uint8_t *path_length)
{
#ifdef ONLY_NEXT_MOVE
    union {
        struct
        {
            uint8_t x;
            uint8_t y;
        } coordinates;
        uint16_t as_uint16_t;
    } next_move;

    *path_length = goal->g + 1;

    struct Node *tmp = goal;
    for (uint8_t i = goal->g; i > 1; i--)
    {
        tmp = tmp->parent;
    }

    next_move.coordinates.x = tmp->x;
    next_move.coordinates.y = tmp->y;

    return next_move.as_uint16_t;
#else
    struct Node **path = malloc(sizeof(struct Node *) * (goal->g + 1));
    if (path == NULL) return NULL;

    *path_length = goal->g + 1;

    struct Node *tmp = goal;
    for (uint8_t i = goal->g; i > 0; i--)
    {
        path[i] = node_new_dynamic(tmp->x, tmp->y, tmp->g, tmp->h);
        tmp = tmp->parent;
    }

    path[0] = node_new_dynamic(start->x, start->y, start->g, start->h);

    return path;
#endif
}

static uint8_t
find_in_open_set(const struct MinHeap *heap, const uint8_t x, const uint8_t y)
{
    for (uint8_t i = 0; i < heap->size; i++)
    {
        struct Node *node = heap->data[i];
        if (node->x == x && node->y == y) return i;
    }
    return 0;
}

static void update_neighbors(uint8_t data[][2],
                             uint8_t *size,
                             const uint8_t x,
                             const uint8_t y)
{
    *size = 0;

    if (!board.board[x][y].walls.left && x > 0)
    {
        data[*size][0] = x - 1;
        data[*size][1] = y;
        (*size)++;
    }

    if (!board.board[x][y].walls.right && x < BOARD_SIZE - 1)
    {
        data[*size][0] = x + 1;
        data[*size][1] = y;
        (*size)++;
    }

    if (!board.board[x][y].walls.top && y > 0)
    {
        data[*size][0] = x;
        data[*size][1] = y - 1;
        (*size)++;
    }

    if (!board.board[x][y].walls.bottom && y < BOARD_SIZE - 1)
    {
        data[*size][0] = x;
        data[*size][1] = y + 1;
        (*size)++;
    }
}

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
      uint8_t *path_length)
{
    struct Node *start_l = node_new(start_x, start_y, 0, 0);
#ifdef ONLY_NEXT_MOVE
    uint16_t res;
#else
    struct Node **res;
#endif

    bool closed_set[BOARD_SIZE][BOARD_SIZE] = {false};
    closed_set[start_l->x][start_l->y] = true;

    struct
    {
        struct MinHeap *heap;              // priority queue on f-score
        bool hash[BOARD_SIZE][BOARD_SIZE]; // keeps track of nodes in the heap
    } open_set = {.heap = new_min_heap(BOARD_SIZE * BOARD_SIZE, compare_nodes),
                  .hash = {false}};
    struct
    {
        uint8_t size;
        uint8_t data[4][2];
    } neighbors = {0};

    uint8_t tent_g = 1;
    for (uint8_t i = 0; i < starter_neighbors_length; i++)
    { // use the starter neighbors as the initial set of cells to visit
        uint8_t x = starter_neighbors[i][0];
        uint8_t y = starter_neighbors[i][1];

        struct Node *neighbor = node_new(x, y, tent_g, abs(y - goal));
        neighbor->parent = start_l;
        min_heap_insert(open_set.heap, neighbor);
        open_set.hash[x][y] = true;
    }

    while (open_set.heap->size > 0)
    {
        struct Node *curr = min_heap_extract(open_set.heap);
        open_set.hash[curr->x][curr->y] = false;

        if (curr->y == goal) // check if we reached the goal
        {
            res = reconstruct_path(start_l, curr, path_length);
            break;
        }

        closed_set[curr->x][curr->y] = true;
        update_neighbors(neighbors.data, &neighbors.size, curr->x, curr->y);

        tent_g = curr->g + 1; // distance curr -> neighbor is constant

        for (uint8_t i = 0; i < neighbors.size; i++)
        {
            uint8_t x = neighbors.data[i][0];
            uint8_t y = neighbors.data[i][1];

            if (closed_set[x][y]) continue;

            if (open_set.hash[x][y]) // already in the open set
            {
                uint8_t j = find_in_open_set(open_set.heap, x, y);
                struct Node *neighbor = open_set.heap->data[j];
                if (tent_g < neighbor->g)
                { // shorter path found
                    neighbor->g = tent_g;
                    neighbor->f = tent_g + neighbor->h;
                    neighbor->parent = curr;
                    bottom_heapify(open_set.heap, j); // we know that old_f > f
                }
            }
            else
            { // new node
                struct Node *neighbor = node_new(x, y, tent_g, abs(y - goal));
                neighbor->parent = curr;
                min_heap_insert(open_set.heap, neighbor);
                open_set.hash[x][y] = true;
            }
        }
    }

    min_heap_free(open_set.heap);
    node_pool_size = 0;
    return res;
}

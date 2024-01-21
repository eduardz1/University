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

struct Node **
reconstruct_path(struct Node *start, struct Node *goal, uint8_t *path_length)
{
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
}

static bool
find_in_open_set(struct MinHeap *heap, uint8_t x, uint8_t y, uint8_t *index)
{
    for (uint8_t i = 0; i < heap->size; i++)
    {
        struct Node *node = heap->data[i];
        if (node->x == x && node->y == y)
        {
            *index = i;
            return true;
        }
    }
    return false;
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

struct Node **astar(struct Node *start,
                    uint8_t goal,
                    Heuristic heuristic,
                    struct Coordinate *starter_neighbors,
                    uint8_t starter_neighbors_length,
                    uint8_t *path_length)
{
    struct Node *start_l = node_new(start->x, start->y, 0, 0);
    struct Node **res;

    bool visited[BOARD_SIZE][BOARD_SIZE] = {false};
    struct MinHeap *open_set =
        new_min_heap(BOARD_SIZE * BOARD_SIZE, compare_nodes);
    min_heap_insert(open_set, start_l);

    struct
    {
        uint8_t size;
        uint8_t data[5][2];
    } neighbors = {.size = starter_neighbors_length};
    for (uint8_t i = 0; i < neighbors.size; i++)
    { // use the starter neighbors as the initial set of cells to visit
        neighbors.data[i][0] = (uint8_t)starter_neighbors[i].x;
        neighbors.data[i][1] = (uint8_t)starter_neighbors[i].y;
    }

    while (open_set->size > 0)
    {
        struct Node *curr = min_heap_extract(open_set);
        if (curr->y == goal) // check if we reached the goal
        {
            res = reconstruct_path(start_l, curr, path_length);
            break;
        }
        visited[curr->x][curr->y] = true;
        if (curr != start_l) // starting neighbors can have special values
            update_neighbors(neighbors.data, &neighbors.size, curr->x, curr->y);

        uint8_t tentative_g = curr->g + 1;

        for (uint8_t i = 0; i < neighbors.size; i++)
        {
            uint8_t x = neighbors.data[i][0];
            uint8_t y = neighbors.data[i][1];

            if (visited[x][y]) continue;

            uint8_t j;
            if (find_in_open_set(open_set, x, y, &j))
            {
                struct Node *neighbor = open_set->data[j];
                if (tentative_g < neighbor->g)
                { // shorter path found
                    neighbor->g = tentative_g;
                    neighbor->f = tentative_g + neighbor->h;
                    neighbor->parent = curr;
                    bottom_heapify(open_set, j); // we already know it's lower
                }
            }
            else
            { // new node
                struct Node *neighbor =
                    node_new(x, y, tentative_g, heuristic(x, y, goal));
                neighbor->parent = curr;
                min_heap_insert(open_set, neighbor);
            }
        }
    }

    min_heap_free(open_set);
    node_pool_size = 0;
    return res;
}

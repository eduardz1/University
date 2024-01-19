#pragma once

#include "comparable.h"
#include <stdint.h>

#define PARENT(i) ((i - 1) / 2)
#define LEFT(i) (2 * i + 1)
#define RIGHT(i) (2 * i + 2)

#define SWAP(a, b, size)                                                       \
    do                                                                         \
    {                                                                          \
        size_t _size = (size);                                                 \
        char *_a = (a), *_b = (b);                                             \
        while (_size-- > 0)                                                    \
        {                                                                      \
            char _tmp = *_a;                                                   \
            *_a++ = *_b;                                                       \
            *_b++ = _tmp;                                                      \
        }                                                                      \
    } while (0)

struct MinHeap
{
    void **data;
    uint8_t size;
    uint8_t capacity;
    Comp comp;
};

struct MinHeap *new_min_heap(const uint8_t capacity, const Comp comp);

void min_heap_insert(struct MinHeap *heap, void *value);

void *min_heap_extract(struct MinHeap *heap);

void min_heap_free(struct MinHeap *heap);

#pragma once

#include "comparable.h"
#include <stdint.h>

#define PARENT(i) ((i - 1) / 2)
#define LEFT(i) (2 * i + 1)
#define RIGHT(i) (2 * i + 2)

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

void min_heap_update(struct MinHeap *heap, const uint8_t i, void *value);

void bottom_heapify(struct MinHeap *heap, uint8_t i);

void top_heapify(struct MinHeap *heap, uint8_t i);

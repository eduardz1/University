#include "headers/min_heap.h"
#include <stdint.h>
#include <stdlib.h>

static void top_heapify(struct MinHeap *heap, uint8_t i)
{
    uint8_t l = LEFT(i);
    uint8_t r = RIGHT(i);
    uint8_t smallest = i;

    if (l < heap->size && heap->comp(heap->data[l], heap->data[smallest]) < 0)
        smallest = l;
    if (r < heap->size && heap->comp(heap->data[r], heap->data[smallest]) < 0)
        smallest = r;

    if (smallest != i)
    {
        void *tmp = heap->data[i];
        heap->data[i] = heap->data[smallest];
        heap->data[smallest] = tmp;
        top_heapify(heap, smallest);
    }
}

static void bottom_heapify(struct MinHeap *heap, uint8_t i)
{
    void *a = heap->data[i];
    void *b = heap->data[PARENT(i)];
    while (i != 0 && heap->comp(a, b) < 0)
    {
        void *tmp = heap->data[i];
        heap->data[i] = heap->data[PARENT(i)];
        heap->data[PARENT(i)] = tmp;
        i = PARENT(i);
    }
}

struct MinHeap *new_min_heap(const uint8_t capacity, const Comp comp)
{
    struct MinHeap *heap = malloc(sizeof(struct MinHeap));
    if (heap == NULL) exit(1); // out of memory

    heap->capacity = capacity;
    heap->size = 0;
    heap->comp = comp;

    heap->data = malloc(capacity * sizeof(void *));
    if (heap->data == NULL) exit(1); // out of memory

    return heap;
}

void min_heap_free(struct MinHeap *heap)
{
    if (heap == NULL) return;

    free(heap->data);
    free(heap);
}

void min_heap_insert(struct MinHeap *heap, void *value)
{
    if (heap->size == heap->capacity)
    {
        heap->capacity *= 2;
        heap->data = realloc(heap->data, heap->capacity * sizeof(void *));
        if (heap->data == NULL) exit(1); // out of memory
    }

    heap->data[heap->size] = value;
    bottom_heapify(heap, heap->size);
    heap->size++;
}

void *min_heap_extract(struct MinHeap *heap)
{
    if (heap->size == 0) return NULL;

    void *value = heap->data[0];
    heap->data[0] = heap->data[heap->size - 1];
    heap->size--;
    top_heapify(heap, 0);

    return value;
}

void *min_heap_peek(struct MinHeap *heap)
{
    if (heap->size == 0) return NULL;

    return heap->data[0];
}

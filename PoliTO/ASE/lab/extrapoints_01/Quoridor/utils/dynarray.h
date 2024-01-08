#pragma once

#include <stdint.h>
#ifndef DYN_ARRAY_INITIAL_SIZE
#define DYN_ARRAY_INITIAL_SIZE 16
#endif

#ifndef DYN_ARRAY_TYPE // ugly implementation but works in this limited scope
#define DYN_ARRAY_TYPE uint32_t
#endif

struct DynArray
{
    DYN_ARRAY_TYPE *data;
    unsigned int size;
    unsigned int _allocated;
};

static int dyn_array_resize(struct DynArray *array);
struct DynArray *dyn_array_new(const unsigned int size);
void dyn_array_free(struct DynArray *array);
int dyn_array_insert(struct DynArray *array,
                     const unsigned int index,
                     const DYN_ARRAY_TYPE value);
int dyn_array_push(struct DynArray *array, const DYN_ARRAY_TYPE value);

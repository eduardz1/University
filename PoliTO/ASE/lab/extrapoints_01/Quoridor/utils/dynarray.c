#include "dynarray.h"
#include "../common.h"

#include <stdlib.h>
#include <string.h>

struct DynArray *dyn_array_new(const unsigned int size)
{
    struct DynArray *new = malloc(sizeof(struct DynArray));
    if (new == NULL) return NULL;

    new->_allocated = size ? size : DYN_ARRAY_INITIAL_SIZE;
    new->size = 0;
    new->data = malloc(size ? size * sizeof(DYN_ARRAY_TYPE) :
                              DYN_ARRAY_INITIAL_SIZE * sizeof(DYN_ARRAY_TYPE));
    if (new->data == NULL)
    {
        free(new);
        return NULL;
    }

    return new;
}

void dyn_array_free(struct DynArray *array)
{
    if (array == NULL) return;

    free(array->data);
    free(array);
}

static int dyn_array_resize(struct DynArray *array)
{
    unsigned int new_size = array->_allocated * 2;

    DYN_ARRAY_TYPE *new_data =
        realloc(array->data, new_size * sizeof(DYN_ARRAY_TYPE));
    if (new_data == NULL) return 0;

    array->data = new_data;
    array->_allocated = new_size;
    return 1;
}

int dyn_array_insert(struct DynArray *array,
                     const unsigned int index,
                     const DYN_ARRAY_TYPE value)
{
    if (array == NULL || index > array->size) return 0;

    /* increase size if necessary */
    if (array->size == array->_allocated && !dyn_array_resize(array)) return 0;

    memmove(array->data + index + 1,
            array->data + index,
            (array->size - index) * sizeof(DYN_ARRAY_TYPE));

    array->data[index] = value;
    array->size++;
    return 1;
}

int dyn_array_push(struct DynArray *array, const DYN_ARRAY_TYPE value)
{
    return dyn_array_insert(array, array->size, value);
}

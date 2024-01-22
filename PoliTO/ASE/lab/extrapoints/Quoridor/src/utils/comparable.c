#include "headers/comparable.h"
#include "../common.h"
#include "../game/npc.h"
#include <stdint.h>

int8_t compare_tuple(const void *a, const void *b)
{
    struct _Tuple tuple_a = *(struct _Tuple *)a;
    struct _Tuple tuple_b = *(struct _Tuple *)b;
    return tuple_a.path - tuple_b.path;
}

int8_t compare_nodes(const void *a, const void *b)
{
    struct Node node_a = *(struct Node *)a;
    struct Node node_b = *(struct Node *)b;
    return node_a.f - node_b.f;
}

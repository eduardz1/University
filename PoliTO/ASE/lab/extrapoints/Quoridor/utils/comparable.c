#include "headers/comparable.h"
#include "../common.h"
#include "../game/npc.h"

int compare_tuple(const void *a, const void *b)
{
    int res;
    if (is_null(a, b, &res)) return res;

    struct _Tuple tuple_a = *(struct _Tuple *)a;
    struct _Tuple tuple_b = *(struct _Tuple *)b;
    return tuple_a.path - tuple_b.path;
}

int compare_nodes(const void *a, const void *b)
{
    int res;
    if (is_null(a, b, &res)) return res;

    struct Node node_a = *(struct Node *)a;
    struct Node node_b = *(struct Node *)b;
    return node_a.f - node_b.f;
}

int is_null(const void *a, const void *b, int *res)
{
    if (a != NULL && b != NULL) return 0;
    if (a == NULL && b == NULL) *res = 0;
    *res = a == NULL ? -1 : 1;
    return 1;
}

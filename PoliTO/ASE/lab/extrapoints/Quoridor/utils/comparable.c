#include "headers/comparable.h"
#include "../common.h"
#include "../game/npc.h"

int compare_tuple(const void *a, const void *b)
{
    int res;
    if (is_null(a, b, &res)) return res;

    struct _Tuple v1 = *(struct _Tuple *)a;
    struct _Tuple v2 = *(struct _Tuple *)b;
    if (v1.path < v2.path) return -1;
    if (v1.path > v2.path) return 1;
    return 0;
}

int is_null(const void *a, const void *b, int *res)
{
    if (a != NULL && b != NULL) return 0;
    if (a == NULL && b == NULL) *res = 0;
    *res = a == NULL ? -1 : 1;
    return 1;
}

#pragma once

#include "astar.h"
#include <stddef.h>
#include <string.h>

typedef int (*Comp)(const void *, const void *);

/**
 * @brief compare two struct _Tuple
 *
 * @param a first element of comparison
 * @param b second element of comparison
 * @return negative if a < b, 0 if a == b, positive if a > b
 */
int compare_tuple(const void *a, const void *b);

/**
 * @brief compare two struct Node
 *
 * @param a first element of comparison
 * @param b second element of comparison
 * @return -1 if f-score of a < f-score of b, 0 if f-score of a == f-score of b,
 * 1 if f-score of a > f-score of b
 */
int compare_nodes(const void *a, const void *b);

/**
 * @brief checks if two pointer have value null and sets res accordingly
 *
 * @param a first element of comparison
 * @param b second element of comparison
 * @param res set to -1 if a is null, 1 if b is null, 0 if both are null
 * @return 1 if a or b are null, 0 otherwise
 */
int is_null(const void *a, const void *b, int *res);

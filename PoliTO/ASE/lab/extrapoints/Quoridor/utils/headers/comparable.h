#pragma once

#include "astar.h"
#include <stddef.h>
#include <stdint.h>
#include <string.h>

typedef int8_t (*Comp)(const void *, const void *);

/**
 * @brief compare two struct _Tuple
 *
 * @param a first element of comparison
 * @param b second element of comparison
 * @return negative if a < b, 0 if a == b, positive if a > b
 */
int8_t compare_tuple(const void *a, const void *b);

/**
 * @brief compare two struct Node
 *
 * @param a first element of comparison
 * @param b second element of comparison
 * @return -1 if f-score of a < f-score of b, 0 if f-score of a == f-score of b,
 * 1 if f-score of a > f-score of b
 */
int8_t compare_nodes(const void *a, const void *b);


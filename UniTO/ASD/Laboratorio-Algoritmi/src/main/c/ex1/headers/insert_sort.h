#pragma once

#include "../../shared/common.h"
#include <string.h>
#include <assert.h>

/**
 * @brief insertion sort of generic array
 * 
 * @param array array of generic elements
 * @param size size (in bytes) of the single element of the array
 * @param length number of elements in the array
 * @param comp pointer to a compare function desired for a type
 */
void insert_sort(void *const array, const size_t size, const int length, const Comp comp);
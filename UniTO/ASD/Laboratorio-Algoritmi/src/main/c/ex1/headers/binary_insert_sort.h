#pragma once

#include "../../shared/common.h"
#include <assert.h>
#include <string.h>

/**
 * @brief insertion sort of generic array using binary search
 * 
 * @param array array of generic elements
 * @param size size (in bytes) of the single element of the array
 * @param length number of elements in the array
 * @param comp pointer to a compare function desired for a type
 */
void binary_insert_sort(void *const array, const size_t size, int length, const Comp comp);

/**
 * @brief iterative binary search
 * 
 * @param array array of generic elements
 * @param size size (in bytes) of the single element of the array
 * @param l left index of the subarray
 * @param r right index of the subarray
 * @param comp pointer to a compare function desired for a type
 * @param key element to search
 * @return int index of #key in #array + 1, if #key is not found then returns r
 */
int binary_search(void *const array, const size_t size, int l, int r, const Comp comp, const void* key);
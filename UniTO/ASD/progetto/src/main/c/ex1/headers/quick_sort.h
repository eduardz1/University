#pragma once

#include "../../shared/common.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/**
 * @brief enumerator used to select different pivot
 */
enum Pivot
{
  RANDOM,
  FIRST,
  MIDDLE,
  LAST,
  MEDIAN3
};

/**
 * @brief quick sort of generic array
 * 
 * @param array array of generic elements
 * @param size size (in bytes) of the single element of the array
 * @param l index of the leftmost element in #partition() range
 * @param r index of the rightmost element in #partition() range 
 * @param comp pointer to the compare function desired for a type
 * @param selector allows to choose a pivot between { FIRST, LAST, MIDDLE, RANDOM, MEDIAN3 }, MEDIAN3 is the suggested one
 */
void quick_sort(void *const array, const size_t size, int l, int r, const Comp comp, const enum Pivot selector);

/**
 * @brief [Lomuto] partitions the array in the specified range [l, r] using r as pivot
 *  
 * @param array array of generic elements
 * @param size is the size of single element of the array
 * @param l index of the leftmost element in partition range
 * @param r index of the rightmost element in partition range 
 * @param comp pointer to the compare function desired for a type
 * @returns index of the pivot placed in the correct position
 */
int partition(void *const array, const size_t size, int p, int r, const Comp comp, const enum Pivot selector);
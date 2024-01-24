#include "headers/quick_sort.h"
#include "headers/binary_insert_sort.h"
#include "headers/insert_sort.h"

#define FALLBACK_CONST 8
#define SWAP(a, b, size)       \
  do                           \
  {                            \
    size_t _size = (size);     \
    char *_a = (a), *_b = (b); \
    while (_size-- > 0)        \
    {                          \
      char _tmp = *_a;         \
      *_a++ = *_b;             \
      *_b++ = _tmp;            \
    }                          \
  } while (0)

void quick_sort(void *const array, const size_t size, int l, int r, const Comp comp, const enum Pivot selector)
{
  assert(array != NULL && size > 0);
  /*
   * removing one quick_sort() call improves constant time complexity, calling the
   * function recursively only on the smaller sub-array reduces the call stack
   * depth in the worst case to log(n). When the subarray to order has less than
   * FALLBACK_CONST elements we use insert_sort() because it performs very well
   * on small groups of elements
   */
  while (l < r)
  {
    int pivot = partition(array, size, l, r, comp, selector);
    if (pivot - l < r - pivot)
    {
      if (pivot - l > FALLBACK_CONST)
        quick_sort(array, size, l, pivot - 1, comp, selector);
      else
        insert_sort(array + l * size, size, pivot - l, comp);
      l = pivot + 1;
    }
    else
    {
      if (r - pivot > FALLBACK_CONST)
        quick_sort(array, size, pivot + 1, r, comp, selector);
      else
        insert_sort(array + (pivot + 1) * size, size, r - pivot, comp);
      r = pivot - 1;
    }
  }
}

int _partition(void *const array, const size_t size, int l, int r, const Comp comp)
{
  // avoiding multiplications at every iteration noticeably improves performance
  int i = (l - 1) * size;
  int pivot_i = r * size;

  /** 
   * @invariant
   *  if (l * size <= k <= i)        then (array[k] <= pivot)
   *  if (i + size <= k <= j - size) then (array[k]  > pivot)
   *  if (k == r)                    then (array[k] == pivot)
   */
  for (int j = l * size; j <= pivot_i; j += size)
  {
    if (comp(array + j, array + pivot_i) <= 0)
    {
      i += size;
      SWAP(array + i, array + j, size);
    }
  }
  return i / size;
}

__attribute__((flatten)) int partition(void *const array, const size_t size, int l, int r, const Comp comp, const enum Pivot selector)
{
  switch (selector)
  {
  case RANDOM:
    SWAP(array + RAND(l, r) * size, array + r * size, size);
    break;
  case FIRST:
    SWAP(array + l * size, array + r * size, size);
    break;
  case MIDDLE:
    SWAP(array + (l + (r - l) / 2) * size, array + r * size, size);
    break;
  case MEDIAN3:
  {
    int first = l * size;
    int middle = (l + (r - l) / 2) * size;
    int last = r * size;
    if (comp(array + middle, array + first) < 0)
      SWAP(array + first, array + middle, size);
    if (comp(array + last, array + first) < 0)
      SWAP(array + first, array + last, size);
    if (comp(array + middle, array + last) < 0)
      SWAP(array + middle, array + last, size);
  }
  break;
  default: case LAST: break; // pivot already in place
  }
  return _partition(array, size, l, r, comp);
}
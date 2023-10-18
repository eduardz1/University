#include "headers/binary_insert_sort.h"

void binary_insert_sort(void *const array, const size_t size, int length, const Comp comp)
{
  assert(array != NULL && size > 0);
  for (int j = 1; j < length; ++j)
  {
    char key[size];
    memcpy(key, array + j * size, size);
    int pos = binary_search(array, size, 0, j - 1, comp, key);

    // Shifts all the elements greater than array[j] right by 1 unit
    memmove(array + (pos + 1) * size, array + pos * size, (j - pos) * size);
    memcpy(array + pos * size, key, size);
  }
}

int binary_search(void *const array, const size_t size, int l, int r, const Comp comp, const void* key)
{
  while (l <= r)
  {
    int mid = l + (r - l) / 2;
    int c = comp(key, array + mid * size);

    if (c == 0)
      return mid + 1;
    else if (c > 0)
      l = mid + 1;
    else
      r = mid - 1;
  }
  return l;
}
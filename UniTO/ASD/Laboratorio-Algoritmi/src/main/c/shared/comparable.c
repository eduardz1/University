#include "common.h"
#include "comparable.h"

int compare_int(const void *a, const void *b)
{
  int res;
  if (is_null(a, b, &res)) return res;

  int v1 = *(int*)a;
  int v2 = *(int*)b;
  if(v1<v2) return -1;
  if(v1>v2) return 1;
  return 0;
}

int compare_long(const void *a, const void *b)
{
  int res;
  if (is_null(a, b, &res)) return res;
  
  long v1 = *(long*)a;
  long v2 = *(long*)b;
  if(v1<v2) return -1;
  if(v1>v2) return 1;
  return 0;
}

int compare_float(const void *a, const void *b)
{
  int res;
  if (is_null(a, b, &res)) return res;
  
  float v1 = *(float*)a;
  float v2 = *(float*)b;
  if(v1<v2) return -1;
  if(v1>v2) return 1;
  return 0;
}

int compare_double(const void *a, const void *b)
{
  int res;
  if (is_null(a, b, &res)) return res;
  
  double v1 = *(double*)a;
  double v2 = *(double*)b;
  if(v1<v2) return -1;
  if(v1>v2) return 1;
  return 0;
}

int compare_char(const void *a, const void *b)
{
  int res;
  if (is_null(a, b, &res)) return res;
  
  char v1 = *(char*)a;
  char v2 = *(char*)b;
  if(v1<v2) return -1;
  if(v1>v2) return 1;
  return 0; 
}

int compare_string(const void *a, const void *b)
{
  int res;
  if (is_null(a, b, &res)) return res;
  
  char *v1 = *(char**)a;
  char *v2 = *(char**)b;
  return strcmp(v1, v2);
}

int is_null(const void *a, const void *b, int *res) 
{
  if (a != NULL && b != NULL) return 0;
  if (a == NULL && b == NULL) *res = 0;
  *res = a == NULL ? -1 : 1;
  return 1;
}
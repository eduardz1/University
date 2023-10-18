#pragma once

#include <string.h>
#include <stddef.h>

typedef int (*Comp)(const void *, const void *);

/**
 * @brief compare two integers
 * 
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 */
int compare_int(const void *a, const void *b);

/**
 * @brief compare two longs
 * 
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 */
int compare_long(const void *a, const void *b);

/**
 * @brief compare two floats
 * 
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 */
int compare_float(const void *a, const void *b);

/**
 * @brief compare two doubles
 * 
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 */
int compare_double(const void *a, const void *b);

/**
 * @brief compare two chars
 * 
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 */
int compare_char(const void *a, const void *b);

/**
 * @brief compare two strings
 * 
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 */
int compare_string(const void *a, const void *b);

/**
 * @brief checks if two pointer have value null and sets res accordingly
 * 
 * @param a first element of comparison 
 * @param b second element of comparison
 * @param res set to -1 if a is null, 1 if b is null, 0 if both are null
 * @return 1 if a or b are null, 0 otherwise 
 */
int is_null(const void *a, const void *b, int *res);
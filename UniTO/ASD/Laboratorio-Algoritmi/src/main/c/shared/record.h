#pragma once

#include <stdio.h>
#include "comparable.h"
#include "free.h"

struct Record
{
  int id;
  char *field1;
  int  field2;
  double field3;
};

/**
 * @brief compare two records based on their fields
 * @details 
 *  calls #compare_string() on the first field, if the two strings are equal, 
 *  calls #compare_int() on the second field, if the two integers are equal,
 *  calls #compare_double() on the third field
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 * 
 */
int compare_records_string(const void *a, const void *b);

/**
 * @brief compare two records based on their fields
 * @details 
 *  calls #compare_int() on the second field, if the two integers are equal,
 *  calls #compare_string() on the first field, if the two strings are equal, 
 *  calls #compare_double() on the third field
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 * 
 */
int compare_records_int(const void *a, const void *b);

/**
 * @brief compare two records based on their fields
 * @details 
 *  calls #compare_double() on the third field
 *  calls #compare_string() on the first field, if the two strings are equal, 
 *  calls #compare_int() on the second field, if the two integers are equal,
 * @param a first element of comparison  
 * @param b second element of comparison
 * @return -1 if a<b, 0 if a=b, 1 if a>b
 * 
 */
int compare_records_double(const void *a, const void *b);

void print_records(struct Record *array, int size);

/**
 * @brief dispose record memory
 * 
 * @param a record to dispose
 */
void free_record(void *a);

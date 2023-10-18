#pragma once
#include "../../shared/common.h"
#include <stdlib.h>

#define MAX_HEIGHT 19 // ~log_2(NUM_WORDS=661561)

/**
 * @struct node of skip list
 * 
 * @param elem generic element of Node
 * @param next array of pointers to the next and a certain number of other elements in the list
 * @param level current level of array #next of pointers to Node
 * @param size size_t in bytes of #elem
 */
struct Node;

/**
 * @brief probabilistic list of ordered elements
 * 
 * @param head pointer to the first element of the list
 * @param comp function comparable relative to the type of the elements
 * @param max_level current max value of Node::level in the list
 * @param elem_size size_t in bytes of #elem
 * @param free function used to free #elem
 */
struct SkipList;

/**
 * @brief insert an element into the list
 * 
 * @param list pointer to a list of generic elements
 * @param elem element to insert
 */
void insert_skip_list(struct SkipList *list, void *const elem);

/**
 * @brief verifies if an element is present in the list
 * 
 * @param list list of generic elements
 * @param elem elements to search
 * @return the element if found or NULL otherwise
 */
void *search_skip_list(struct SkipList *list, void *const elem);

/**
 * @brief initializes a new empty skip list
 *
 * @param comp pointer to the compare function desired for a type
 * @param free function used to free #elem
 * @param elem_size specifies the type by size
 * @return pointer to the new list or NULL if an error occurred
 */
struct SkipList *create_skip_list(Comp comp, void (*free)(void *), size_t elem_size);

/**
 * @brief deallocates every element of a list
 */
void delete_skip_list(struct SkipList *list);

/**
 * @brief prints skip list formatted vertically
 *
 *  output when redirected needs to be converted with "col -bxp <inputfile.txt >outputfile.txt"
 *  to render carriage returns properly
 */
void print_skip_list(struct SkipList *list, enum Type type);
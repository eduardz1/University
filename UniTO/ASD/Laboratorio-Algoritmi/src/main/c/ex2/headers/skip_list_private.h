#pragma once
#include "skip_list.h"

struct Node
{
  void *elem;
  struct Node **next;
  uint8_t level;
  size_t size;
};

struct SkipList
{
  struct Node *head;
  int (*comp)(const void*, const void*);
  uint8_t max_level;
  size_t elem_size;
  void (*free)(void *);
};

/**
 * @brief Create a node object
 * 
 * @param elem element of the node
 * @param level number of pointers to other nodes
 * @param size specifies size of byte to allocate for the elem
 * @return pointer to the new node or NULL if an error occurred
 */
struct Node *create_node(void *elem, uint32_t level, size_t size);

/**
 * @brief determines max number of pointer to include in a new Node
 */
uint32_t random_level();
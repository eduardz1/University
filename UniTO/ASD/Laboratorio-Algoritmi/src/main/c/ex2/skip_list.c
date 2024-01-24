#include "headers/skip_list_private.h"
#include "../shared/record.h"
#include <stdlib.h>

uint32_t random_level()
{
  int lvl = 1;
  while(rand() % 2 && lvl < MAX_HEIGHT) lvl++;
  return lvl;
}

struct Node *create_node(void *elem, uint32_t level, size_t size)
{
  struct Node *new = malloc(sizeof(struct Node));
  if(new == NULL) return NULL;

  if(size == 0)
  { 
    new->elem = NULL;
  }
  else
  {
    new->elem = malloc(size);
    if(new->elem == NULL) return NULL;
    memcpy(new->elem, elem, size);
  }

  new->level = level;

  new->next = calloc(level, sizeof(void*));
  if(new->next == NULL) return NULL;
  return new;
}

void insert_skip_list(struct SkipList *list, void *const elem)
{
  assert(list != NULL);
  struct Node *new = create_node(elem, random_level(), list->elem_size);
  if(new == NULL)
  {
    printf("Error creating node\n");
    exit(EXIT_FAILURE);
  }
  if(new->level > list->max_level) 
    list->max_level = new->level;
  
  struct Node *x = list->head;
  
  for(int k = list->max_level - 1; k >= 0;)
  {
    if((x->next[k] == NULL) || (list->comp(elem, x->next[k]->elem) < 0))
    {
      if(k < new->level)
      {
        new->next[k] = x->next[k];
        x->next[k] = new;
      }
      k--;
    }
    else
    {
      x = x->next[k];
    }
  }
}

struct SkipList *create_skip_list(Comp comp, void (*free)(void *), size_t elem_size)
{
  struct SkipList *new = malloc(sizeof(struct SkipList));
  if(new == NULL) return NULL;

  struct Node *sentinel = create_node(NULL, MAX_HEIGHT, 0);
  if(sentinel == NULL) return NULL;
  new->head = sentinel;

  new->free = free;
  new->comp = comp;
  new->max_level = 1;
  new->elem_size = elem_size;
  return new;
}

void delete_skip_list(struct SkipList* list)
{
  assert(list != NULL);
  struct Node *curr = NULL;
  while(list->head != NULL) 
  {
    curr = list->head;
    list->head = curr->next[0];
    if(curr->elem != NULL && list->free != NULL)
      list->free(curr->elem);
    
    if(curr->elem != NULL)
      free(curr->elem);
    free(curr->next);
    free(curr);

  }

  free(list);
}

void *search_skip_list(struct SkipList *list, void *const elem)
{
  assert(list != NULL && elem != NULL);
  struct Node *x = list->head;

  /// @invariant x->elem < elem
  for(int i = list->max_level - 1; i >= 0; i--)
  {
    while(x->next[i] != NULL && list->comp(x->next[i]->elem, elem) < 0)
      x = x->next[i];
  }

  x = x->next[0];
  if(x == NULL || list->comp(x->elem, elem) != 0)
    return NULL;
  else
    return x->elem;
}

// Redirection doesn't look too good because of the carriage returns, if we find
// a way to write the elem at the start of the line without them it will look good
// even when redirected, for now we can convert it with "col -bxp <inputfile.txt >outputfile.txt" (it takes a while)
void print_skip_list(struct SkipList *list, enum Type type)
{
  int i;

  struct Node *x = list->head;
  printf("\n\n");
  printf("-- HEAD (Sentinel) --\n\n");
  for(int i = 0; i < list->max_level; i++) printf("[LEVEL %03d] ", i);
  printf("\n");

  x = list->head;
  do
  {
    x = x->next[0];

    for(i = 0; i < list->max_level; i++) printf("     |      ");
    printf("\n ");
    for(i = 0; i < x->level; i++) printf("----V-------");
    for(i = x->level; i < list->max_level; i++) printf("    |       ");
    printf("\n");
    for(i = 0; i < x->level; i++) printf("            "); // blank space for elem
    printf(" |");
    for(i = x->level; i < list->max_level; i++) printf("   |        ");
    switch(type) // elem written at the start with carriage return, would be nice to do it without it
    {
    case TYPE_CHAR:
      printf("\r| %c", *(char*)x->elem);
      break;
    case TYPE_INT:
      printf("\r| %d", *(int*)x->elem);
      break;
    case TYPE_FLOAT:
      printf("\r| %f", *(float*)x->elem);
      break;
    case TYPE_DOUBLE: 
      printf("\r| %lf", *(double*)x->elem);
      break;
    case TYPE_STRING:
      printf("\r| %s", *(char**)x->elem);
      break;
    case TYPE_RECORD:
      printf("\r| <%d/%s/%d/%lf>", ((struct Record *)x->elem)->id, ((struct Record *)x->elem)->field1, ((struct Record *)x->elem)->field2, ((struct Record *)x->elem)->field3);
      break;
    case TYPE_POINTER: default:
      printf("\r| %p", x->elem);
      break;
    }

    printf("\n ");
    for(i = 0; i < x->level; i++) printf("------------");
    for(i = x->level; i < list->max_level; i++) printf("    |       ");
    printf("\n");
       
  } while(x->next[0] != NULL);

  for(i = 0; i < list->max_level; i++) printf("     |      ");
  printf("\n ");
  for(i = 0; i < list->max_level; i++) printf("----V-------");
  printf("\n");
  for(i = 0; i < list->max_level; i++) printf("            ");
  printf(" |\r| NIL\n ");
  for(i = 0; i < list->max_level; i++) printf("------------");
  printf("\n\n");
}
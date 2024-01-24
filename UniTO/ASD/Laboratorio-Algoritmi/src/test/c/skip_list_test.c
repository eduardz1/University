#include "unity/unity.h"
#include "../../main/c/ex2/headers/skip_list_private.h"
#include "../../main/c/shared/record.h"

#define PRINT_LISTS false

void setUp(void)
{
  srand(time(NULL));
}

void tearDown(void) {}

#pragma region /// TEST #seach_skip_list()
void test_search_int_skip_list() {
  
  int aa = 1;
  int bb = 3;
  int cc = 5;
  int dd = 7;

  struct Node * a = create_node(&aa, 3, sizeof(int));
  struct Node * b = create_node(&bb, 1, sizeof(int));
  struct Node * c = create_node(&cc, 2, sizeof(int));
  struct Node * d = create_node(&dd, 3, sizeof(int));

  a->next[2] = d; a->next[1] = c; a->next[0] = b;
  b->next[0] = c;
  c->next[1] = d; c->next[0] = d;
  d->next[2] = NULL; d->next[1] = NULL; d->next[0] = NULL;

  struct Node * dummy = malloc(sizeof(struct Node));
  if(dummy == NULL)
  {
    printf("Malloc failed\n");
    exit(EXIT_FAILURE);
  }
  dummy->next = malloc(sizeof(struct Node *) * 3);
  if(dummy->next == NULL)
  {
    printf("Malloc failed\n");
    exit(EXIT_FAILURE);
  }
  dummy->next[0] = a; dummy->next[1] = a; dummy->next[2] = a;
  dummy->elem = NULL;
  dummy->level = 3;

  struct SkipList * list = malloc(sizeof(struct SkipList));
  if(list == NULL)
  {
    printf("Malloc failed\n");
    exit(EXIT_FAILURE);
  }
  list->comp = compare_int;
  list->free = NULL;
  list->max_level = 3;
  list->head = dummy;

  int to_find = 1;
  TEST_ASSERT_EQUAL_INT(0, compare_int(&to_find, (int*)search_skip_list(list, &to_find)));
  delete_skip_list(list);
}

void test_search_char_skip_list()
{
  struct SkipList *l = create_skip_list(compare_char, NULL, sizeof(char));
  char actual[6] = { 'l', 'f', 'a', 'b', '0', 'w'};

  insert_skip_list(l, actual + 0);
  insert_skip_list(l, actual + 1);
  insert_skip_list(l, actual + 2);
  insert_skip_list(l, actual + 3);
  insert_skip_list(l, actual + 4);
  insert_skip_list(l, actual + 5);

  char to_search[6] = { 'l', 'z', 'a', 'k', '0', 'x'};

  // print_skip_list(l, TYPE_CHAR);
  TEST_ASSERT_EQUAL_INT(0, compare_char(search_skip_list(l, to_search + 0), actual + 0));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 1));
  TEST_ASSERT_EQUAL_INT(0, compare_char(search_skip_list(l, to_search + 2), actual + 2));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 3));
  TEST_ASSERT_EQUAL_INT(0, compare_char(search_skip_list(l, to_search + 4), actual + 4));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 5));
  delete_skip_list(l);
}

void test_search_skip_list()
{
  struct SkipList *l = create_skip_list(compare_records_string, NULL, sizeof(struct Record));
  struct Record actual[8] = {
      {0, "a\0", 1, 0.0001f},
      {1, "c\0", 0, 1.0001f},
      {2, "a\0", 0, 0.0211f},
      {3, "b\0", 24, 0.0001f},
      {4, "b\0", 15, 0.0001f},
      {5, "c\0", 0, 0.0001f},
      {6, "d\0", 0, 0.0001f},
      {7, "a\0", 0, 0.0001f}
    };
  
  insert_skip_list(l, actual + 0);
  insert_skip_list(l, actual + 1);
  insert_skip_list(l, actual + 2);
  insert_skip_list(l, actual + 3);
  insert_skip_list(l, actual + 4);
  insert_skip_list(l, actual + 5);
  insert_skip_list(l, actual + 6);
  insert_skip_list(l, actual + 7);
  
  struct Record to_search[8] = {
      {0, "a\0", 1, 0.0001f},
      {1, "c\0", 90, 1.0001f},
      {2, "a\0", 0, 0.0211f},
      {3, "b\0", 24, 0.0901f},
      {4, "b\0", 15, 0.0001f},
      {5, "i\0", 0, 0.0001f},
      {6, "d\0", 0, 0.0001f},
      {7, "a\0", 0, -0.0001f}
    };

  TEST_ASSERT_EQUAL_INT(0, compare_records_string(search_skip_list(l, to_search + 0), actual + 0));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 1));
  TEST_ASSERT_EQUAL_INT(0, compare_records_string(search_skip_list(l, to_search + 2), actual + 2));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 3));
  TEST_ASSERT_EQUAL_INT(0, compare_records_string(search_skip_list(l, to_search + 4), actual + 4));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 5));
  TEST_ASSERT_EQUAL_INT(0, compare_records_string(search_skip_list(l, to_search + 6), actual + 6));
  TEST_ASSERT_NULL(search_skip_list(l, to_search + 7));
  delete_skip_list(l);
}
#pragma endregion

#pragma region /// TEST #insert_skip_list()
void test_insert_char_skip_list()
{
  struct SkipList *l = create_skip_list(compare_char, NULL, sizeof(char));
  char actual[6] = { 'l', 'f', 'a', 'b', '0', 'w'};

  insert_skip_list(l, &actual[0]);
  insert_skip_list(l, &actual[1]);
  insert_skip_list(l, &actual[2]);
  insert_skip_list(l, &actual[3]);
  insert_skip_list(l, &actual[4]);
  insert_skip_list(l, &actual[5]);

  char expected[6] = { '0', 'a', 'b', 'f', 'l', 'w'};
  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(char*)tmp->elem;
    i++;
  }

  TEST_ASSERT_EQUAL_INT8_ARRAY(expected, actual, 6);
#if PRINT_LISTS
  print_skip_list(l, TYPE_CHAR);
#endif
  delete_skip_list(l);
}

void test_insert_int_skip_list()
{
  struct SkipList *l = create_skip_list(compare_int,NULL, sizeof(int));
  int actual[6] = { 3, 7, 1, 11, 89, 0};

  insert_skip_list(l, actual + 0);
  insert_skip_list(l, actual + 1);
  insert_skip_list(l, actual + 2);
  insert_skip_list(l, actual + 3);
  insert_skip_list(l, actual + 4);
  insert_skip_list(l, actual + 5); 

  int expected[6] = {0, 1, 3, 7, 11, 89};

  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(int*)tmp->elem;
    i++;
  }

  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 6);
#if PRINT_LISTS
  print_skip_list(l, TYPE_INT);
#endif
  delete_skip_list(l);
}

void test_insert_double_skip_list()
{
  struct SkipList *l = create_skip_list(compare_double, NULL, sizeof(double));
  double actual[6] = { 0.900000003, 34343.8989328, 0.0, 45.9999, 7.0, 78.89};

  insert_skip_list(l, actual + 0);
  insert_skip_list(l, actual + 1);
  insert_skip_list(l, actual + 2);
  insert_skip_list(l, actual + 3);
  insert_skip_list(l, actual + 4);
  insert_skip_list(l, actual + 5);

  double expected[6] = {0.0, 0.900000003, 7.0, 45.9999, 78.89, 34343.8989328};

  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(double*)tmp->elem;
    i++;
  }

  TEST_ASSERT_EQUAL_DOUBLE_ARRAY(expected, actual, 6);
#if PRINT_LISTS
  print_skip_list(l, TYPE_DOUBLE);
#endif
  delete_skip_list(l);
}

void test_insert_long_skip_list()
{
  struct SkipList *l = create_skip_list(compare_long, NULL, sizeof(double));
  long actual[6] = { INT_MAX + 1l, INT_MIN - 1l, 0l, 99l, INT_MIN * 2l, LONG_MAX};

  insert_skip_list(l, actual + 0);
  insert_skip_list(l, actual + 1);
  insert_skip_list(l, actual + 2);
  insert_skip_list(l, actual + 3);
  insert_skip_list(l, actual + 4);
  insert_skip_list(l, actual + 5);

  long expected[6] = {INT_MIN * 2l, INT_MIN - 1l, 0l, 99l, INT_MAX + 1l, LONG_MAX};

  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(long*)tmp->elem;
    i++;
  }

  TEST_ASSERT_EQUAL_INT64_ARRAY(expected, actual, 6);
#if PRINT_LISTS
  print_skip_list(l, TYPE_LONG);
#endif
  delete_skip_list(l);
}

void test_insert_float_skip_list()
{
  struct SkipList *l = create_skip_list(compare_float, NULL, sizeof(float));
  float actual[6] = { 4.0f, 4.999f, 1.0f, 0.0f, 59595.1f, -1.8f};

  insert_skip_list(l, &actual[0]);
  insert_skip_list(l, &actual[1]);
  insert_skip_list(l, &actual[2]);
  insert_skip_list(l, &actual[3]);
  insert_skip_list(l, &actual[4]);
  insert_skip_list(l, &actual[5]);

  float expected[6] = { -1.8f, 0.0f, 1.0f, 4.0f, 4.999f, 59595.1f};

  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(float*)tmp->elem;
    i++;
  }

  TEST_ASSERT_EQUAL_FLOAT_ARRAY(expected, actual, 6);
#if PRINT_LISTS
  print_skip_list(l, TYPE_FLOAT);
#endif
  delete_skip_list(l);
}

void test_insert_string_skip_list()
{
  struct SkipList *l = create_skip_list(compare_string, free_string, sizeof(char *));

  char *a = malloc(sizeof(char) * 5);
  strcpy(a, "aaaa");
  char *b = malloc(sizeof(char) * strlen("sdsadaaaaaa") + 1);
  strcpy(b, "sdsadaaaaaa");
  char *c = malloc(sizeof(char) * 5);
  strcpy(c, "bbb.");
  char *d = malloc(sizeof(char) * 2);
  strcpy(d, ",");
  char *e = malloc(sizeof(char) * 5);
  strcpy(e, "away");
  char *f = malloc(sizeof(char) * 2);
  strcpy(f, "4");

  char *actual[6] = { a, b, c, d, e, f};
  
  insert_skip_list(l, &a);
  insert_skip_list(l, &b);
  insert_skip_list(l, &c);
  insert_skip_list(l, &d);
  insert_skip_list(l, &e);
  insert_skip_list(l, &f);

  char *expected[] = {",", "4", "aaaa", "away", "bbb.", "sdsadaaaaaa"};

  // print_skip_list(l, TYPE_STRING);
  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(char**)tmp->elem;
    i++;
  }

  // Assert must be done before delete, as delete dispose values in #actual array
  TEST_ASSERT_EQUAL_STRING_ARRAY(expected, actual, 6);
#if PRINT_LISTS
  print_skip_list(l, TYPE_STRING);
#endif
  delete_skip_list(l);
}

void test_insert_record_skip_list()
{
  struct SkipList *l = create_skip_list(compare_records_string, NULL, sizeof(struct Record));
  struct Record actual[8] = {
      {0, "a\0", 1, 0.0001f},
      {1, "c\0", 0, 1.0001f},
      {2, "a\0", 0, 0.0211f},
      {3, "b\0", 24, 0.0001f},
      {4, "b\0", 15, 0.0001f},
      {5, "c\0", 0, 0.0001f},
      {6, "d\0", 0, 0.0001f},
      {7, "a\0", 0, 0.0001f}
    };
  
  insert_skip_list(l, actual + 0);
  insert_skip_list(l, actual + 1);
  insert_skip_list(l, actual + 2);
  insert_skip_list(l, actual + 3);
  insert_skip_list(l, actual + 4);
  insert_skip_list(l, actual + 5);
  insert_skip_list(l, actual + 6);
  insert_skip_list(l, actual + 7);

  struct Record expected[8] = {
      {7, "a\0", 0, 0.0001f},
      {2, "a\0", 0, 0.0211f},
      {0, "a\0", 1, 0.0001f},
      {4, "b\0", 15, 0.0001f},
      {3, "b\0", 24, 0.0001f},
      {5, "c\0", 0, 0.0001f},
      {1, "c\0", 0, 1.0001f},
      {6, "d\0", 0, 0.0001f},
  };

  struct Node *tmp = l->head->next[0];
  for(int i = 0; tmp != NULL; tmp = tmp->next[0])
  {
    actual[i] = *(struct Record*)tmp->elem;
    i++;
  }
  
  for (unsigned long int i = 0; i < sizeof(actual) / sizeof(actual[0]); i++)
  {
    TEST_ASSERT_EQUAL_STRING(expected[i].field1, actual[i].field1);
    TEST_ASSERT_EQUAL_INT(expected[i].field2, actual[i].field2);
    TEST_ASSERT_EQUAL_FLOAT(expected[i].field3, actual[i].field3);
  }
#if PRINT_LISTS
  print_skip_list(l, TYPE_RECORD);
#endif
  delete_skip_list(l);
}
#pragma endregion

void test_leak() {

  struct SkipList *l = create_skip_list(compare_string, free_string, sizeof(char *));
  char * st = malloc(sizeof(char) * 30);
  if(st == NULL)
  {
    printf("Malloc failed\n");
    exit(EXIT_FAILURE);
  }
  for (size_t i = 0; i < 30; i++)
  {
    st[i] = 'a';
  }
  insert_skip_list(l, &st);
  delete_skip_list(l);
}

int main(void)
{
  UNITY_BEGIN();

  RUN_TEST(test_insert_char_skip_list);
  RUN_TEST(test_insert_double_skip_list);
  RUN_TEST(test_insert_float_skip_list);
  RUN_TEST(test_insert_int_skip_list);
  RUN_TEST(test_insert_long_skip_list);
  RUN_TEST(test_insert_record_skip_list);
  RUN_TEST(test_insert_string_skip_list);

  RUN_TEST(test_search_skip_list);
  RUN_TEST(test_search_int_skip_list);
  RUN_TEST(test_search_char_skip_list);

  /*
  / Test used to check memory leak. 
  / No need to run it because without valgrind this test doesn't show nothing.
  */
  // RUN_TEST(test_leak);
  return UNITY_END();
}


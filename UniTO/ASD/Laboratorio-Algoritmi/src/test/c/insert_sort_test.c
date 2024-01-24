#include "unity/unity.h"
#include "../../main/c/ex1/headers/insert_sort.h"
#include "../../main/c/shared/record.h"

void setUp(void) {}
void tearDown(void) {}

void test_null_array(void)
{
  int *actual = NULL;
  TEST_ASSERT_NULL(actual);
  insert_sort(actual, 0, 0, compare_int);
  TEST_ASSERT_NULL(actual);
}

void test_int_array(void)
{
  int actual[] = {8, 5, 6, 78, 3, 5};
  int expected[] = {3, 5, 5, 6, 8, 78};
  insert_sort(actual, sizeof(actual[0]), 6, compare_int);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 6);
}

void test_string_array(void)
{
  char a[] = "aaaaaaaaa";
  char b[] = "zzz";
  char c[] = "yy";
  char d[] = "cc";
  char e[] = "ab";
  char f[] = "ba";
  char *actual[] = {a, b, c, d, e, f};
  char *expected[] = {a, e, f, d, c, b};
  insert_sort(actual, sizeof(char*), 6, compare_string);
  TEST_ASSERT_EQUAL_STRING_ARRAY(expected, actual, 6);
}

void test_float_array(void)
{
  float actual[] = {0.0f, 0.58f, 0.42f, 98.31f, 15.42f};
  float expected[] = {0.0f, 0.42f, 0.58f, 15.42f, 98.31f};
  insert_sort(actual, sizeof(actual[0]), 5, compare_float);
  TEST_ASSERT_EQUAL_FLOAT_ARRAY(expected, actual, 5);
}

void test_char_array(void)
{
  char actual[] = {'d', 'c', 'a', 'b', 'f', 'e'};
  char expected[] = {'a', 'b', 'c', 'd', 'e', 'f'};
  insert_sort(actual, sizeof(actual[0]), 6, compare_char);
  TEST_ASSERT_EQUAL_INT8_ARRAY(expected, actual, 5);
}

void test_double_array(void)
{
  double actual[] = {0.0000f, 0.5812f, 0.4122f, 98.0931f, 0.4123f};
  double expected[] = {0.0000f, 0.4122f, 0.4123f, 0.5812f, 98.0931f};
  insert_sort(actual, sizeof(actual[0]), 5, compare_double);
  TEST_ASSERT_EQUAL_DOUBLE_ARRAY(expected, actual, 5);
}

void test_long_array(void)
{
  long actual[] = {LONG_MAX, 0, LONG_MIN, 40, 21, 18, 58, 118, 98};
  long expected[] = {LONG_MIN, 0, 18, 21, 40, 58, 98, 118, LONG_MAX};
  insert_sort(actual, sizeof(actual[0]), 9, compare_long);
  TEST_ASSERT_EQUAL_INT32_ARRAY(expected, actual, 9);
}

void test_array_with_only_duplicated_elements(void)
{
  int actual[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
  int expected[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
  insert_sort(actual, sizeof(actual[0]), 10, compare_int);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 10);
}

void test_already_sorted_array(void)
{
  int actual[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  int expected[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  insert_sort(actual, sizeof(actual[0]), 10, compare_int);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 10);
}

void test_negative_int_array(void)
{
  int actual[] = {-1, -5, -9, -2, -3};
  int expected[] = {-9, -5, -3, -2, -1};
  insert_sort(actual, sizeof(actual[0]), 5, compare_int);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 5);
}

void test_records_array(void)
{

  struct Record actual[] = {
      {0, "a", 1, 0.0001f},
      {1, "c", 0, 1.0001f},
      {2, "a", 0, 0.0211f},
      {3, "b", 24, 0.0001f},
      {4, "b", 15, 0.0001f},
      {5, "c", 0, 0.0001f},
      {6, "d", 0, 0.0001f},
      {7, "a", 0, 0.0001f},
  };

  struct Record expected[] = {
      {7, "a", 0, 0.0001f},
      {2, "a", 0, 0.0211f},
      {0, "a", 1, 0.0001f},
      {4, "b", 15, 0.0001f},
      {3, "b", 24, 0.0001f},
      {5, "c", 0, 0.0001f},
      {1, "c", 0, 1.0001f},
      {6, "d", 0, 0.0001f},
  };

  insert_sort(actual, sizeof(actual[0]), 8, compare_records_string);
  for (unsigned long i = 0; i < sizeof(actual) / sizeof(actual[0]); i++)
  {
    TEST_ASSERT_EQUAL_STRING(expected[i].field1, actual[i].field1);
    TEST_ASSERT_EQUAL_INT(expected[i].field2, actual[i].field2);
    TEST_ASSERT_EQUAL_FLOAT(expected[i].field3, actual[i].field3);
  }
}

int main(void)
{
  UNITY_BEGIN();

  RUN_TEST(test_null_array);
  RUN_TEST(test_int_array);
  RUN_TEST(test_string_array);
  RUN_TEST(test_float_array);
  RUN_TEST(test_char_array);
  RUN_TEST(test_double_array);
  RUN_TEST(test_long_array);
  RUN_TEST(test_array_with_only_duplicated_elements);
  RUN_TEST(test_already_sorted_array);
  RUN_TEST(test_negative_int_array);
  RUN_TEST(test_records_array);

  return UNITY_END();
}

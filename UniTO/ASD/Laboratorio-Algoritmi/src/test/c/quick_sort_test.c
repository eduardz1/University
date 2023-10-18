#include "unity/unity.h"

#include "../../main/c/ex1/headers/quick_sort.h"
#include "../../main/c/shared/record.h"

void setUp(void) {}
void tearDown(void) {}

void test_null_array(void)
{
  int *actual = NULL;
  TEST_ASSERT_NULL(actual);
  quick_sort(actual, 0, 0, 0, compare_int, MEDIAN3);
  TEST_ASSERT_NULL(actual);
}

void test_int_array(void)
{
  int actual[] = {8, 5, 6, 78, 3, 5, 12, 9, 17, 24, 38};
  int expected[] = {3, 5, 5, 6, 8, 9, 12, 17, 24, 38, 78};
  quick_sort(actual, sizeof(actual[0]), 0, 10, compare_int, MEDIAN3);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 11);
}

void test_string_array(void)
{
  char *actual[9] = {"aa\0", "zzz\0", "yy\0", "cc\0", "ab\0", "ba\0", "ac\0", "ad\0", "ae\0"};
  char *expected[9] = {"aa\0", "ab\0", "ac\0", "ad\0", "ae\0", "ba\0", "cc\0", "yy\0", "zzz\0"};
  quick_sort(actual, sizeof(actual[0]), 0, 8, compare_string, MEDIAN3);
  TEST_ASSERT_EQUAL_STRING_ARRAY(expected, actual, 9);
}

void test_float_array(void)
{
  float actual[] = {0.0f, 0.58f, 0.42f, 98.31f, 15.42f, 0.18f, 0.21f, 0.40f, 0.401f};
  float expected[] = {0.0f, 0.18f, 0.21f, 0.40f, 0.401f, 0.42f, 0.58f, 15.42f, 98.31f};
  quick_sort(actual, sizeof(actual[0]), 0, 8, compare_float, MEDIAN3);
  TEST_ASSERT_EQUAL_FLOAT_ARRAY(expected, actual, 9);
}

void test_char_array(void)
{
  char actual[] = {'d', 'c', 'a', 'b', 'f', 'e', 'g', 'i', 'h', 'l'};
  char expected[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'l'};
  quick_sort(actual, sizeof(actual[0]), 0, 9, compare_char, MEDIAN3);
  TEST_ASSERT_EQUAL_INT8_ARRAY(expected, actual, 9);
}

void test_double_array(void)
{
  double actual[] = {0.0000f, 0.5812f, 0.4122f, 98.0931f, 0.4123f, 0.2118f, 0.2472f, 0.1987f, 0.1876f};
  double expected[] = {0.0000f,0.1876f, 0.1987f,0.2118f, 0.2472f, 0.4122f, 0.4123f, 0.5812f, 98.0931f};
  quick_sort(actual, sizeof(actual[0]), 0, 8, compare_double, MEDIAN3);
  TEST_ASSERT_EQUAL_DOUBLE_ARRAY(expected, actual, 9);
}

void test_long_array(void)
{
  long actual[] = {LONG_MAX, 0, LONG_MIN, 40, 21, 18, 58, 118, 98};
  long expected[] = {LONG_MIN, 0, 18, 21, 40, 58, 98, 118, LONG_MAX};
  quick_sort(actual, sizeof(actual[0]), 0, 8, compare_long, MEDIAN3);
  TEST_ASSERT_EQUAL_INT32_ARRAY(expected, actual, 9);
}

void test_array_with_only_duplicated_elements(void)
{
  int actual[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
  int expected[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
  quick_sort(actual, sizeof(actual[0]), 0, 9, compare_int, MEDIAN3);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 10);
}

void test_already_sorted_array(void)
{
  int actual[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  int expected[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  quick_sort(actual, sizeof(actual[0]), 0, 9, compare_int, MEDIAN3);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 10);
}

void test_negative_int_array(void)
{
  int actual[] = {-1, -5, -9, -2, -3, -14, - 10, -18, -21};
  int expected[] = {-21, -18, -14, -10, -9, -5, -3, -2, -1};
  quick_sort(actual, sizeof(actual[0]), 0, 8, compare_int, MEDIAN3);
  TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, 9);
}

void test_records_array(void)
{

  struct Record actual[] = {
      {0, "a\0", 1, 0.0001f},
      {1, "c\0", 0, 1.0001f},
      {2, "a\0", 0, 0.0211f},
      {3, "b\0", 24, 0.0001f},
      {4, "b\0", 15, 0.0001f},
      {5, "c\0", 0, 0.0001f},
      {6, "d\0", 0, 0.0001f},
      {7, "a\0", 0, 0.0001f},
      {8, "d\0", 0, 0.0002f},
  };

  struct Record expected[] = {
      {7, "a\0", 0, 0.0001f},
      {2, "a\0", 0, 0.0211f},
      {0, "a\0", 1, 0.0001f},
      {4, "b\0", 15, 0.0001f},
      {3, "b\0", 24, 0.0001f},
      {5, "c\0", 0, 0.0001f},
      {1, "c\0", 0, 1.0001f},
      {6, "d\0", 0, 0.0001f},
      {8, "d\0", 0, 0.0002f},
  };

  quick_sort(actual, sizeof(actual[0]), 0, 8, compare_records_string, MEDIAN3);
  for (unsigned long i = 0; i < sizeof(actual) / sizeof(actual[0]); i++)
  {
    TEST_ASSERT_EQUAL_STRING(expected[i].field1, actual[i].field1);
    TEST_ASSERT_EQUAL_INT(expected[i].field2, actual[i].field2);
    TEST_ASSERT_EQUAL_FLOAT(expected[i].field3, actual[i].field3);
    // cleaner method but if compare_records breaks we don't know which one is broken
    // TEST_ASSERT_TRUE(!compare_records(&expected[i], &actual[i]));
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

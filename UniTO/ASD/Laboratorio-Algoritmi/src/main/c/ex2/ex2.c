#include "headers/skip_list.h"
#include "../shared/common.h"
#include "../shared/record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_WORDS 256
#define LONGEST_WORD 30 // esofagodermatodigiunoplastica is the longest word in the italian dictionary :p

void load_dictionary(const char* file_name, struct SkipList *list)
{
  FILE *fp = fopen(file_name, "r");
  if(fp == NULL)
  {
    printf("Error opening file\n");
    exit(EXIT_FAILURE);
  }

  printf("Loading dictionary from file \033[1m%s\033[22m \0337\033[5m...\n", file_name);
  char buffer[128];
  int words_count = 0;

  clock_t start_loading = clock();
  for (int i = 0; fgets(buffer, sizeof(buffer), fp) != NULL; i++)
  { 
    char *word = calloc(LONGEST_WORD, sizeof(char));
    if(word == NULL && LONGEST_WORD > 0)
    {
      printf("Error allocating memory\n");
      exit(EXIT_FAILURE);
    }
    sscanf(buffer, "%s", word);
    insert_skip_list(list, &word);
    words_count++;
  }
  clock_t end_loading = clock();
  printf("\033[25m\0338\033[32mdone\033[0m\n");
  printf("\033[1mLOADING TIME\033[22m: %f seconds. Words inserted: %i\n", (double)(end_loading - start_loading) / CLOCKS_PER_SEC, words_count);

  
  fclose(fp);
}

int load_array(const char* file_name, char *arr[256])
{
  FILE *fp = fopen(file_name, "r");
  if(fp == NULL)
  {
    printf("Error opening file\n");
    exit(EXIT_FAILURE);
  }

  printf("Loading array from file \033[1m%s\033[22m \0337\033[5m...\n", file_name);

  bool ugly_flag = false;
  char c;
  int words = 0, chars = 0;

  arr[words] = calloc(LONGEST_WORD, sizeof(char)); // first word needs to be manually alloc'd
  if(arr[words] == NULL && LONGEST_WORD > 0)
  {
    printf("Error allocating memory\n");
    exit(EXIT_FAILURE);
  }
  while(((c = fgetc(fp)) != EOF) && words < MAX_WORDS)
  {
    if(c < 'A' || (c > 'Z' && c < 'a') || c > 'z')
    {
      if(!ugly_flag) continue; // makes fgetc loop until it finds a letter

      arr[words][chars] = '\0';
      chars = 0;
      arr[++words] = calloc(LONGEST_WORD, sizeof(char));
      if(arr[words] == NULL && LONGEST_WORD > 0)
      {
        printf("Error allocating memory\n");
        exit(EXIT_FAILURE);
      }
      ugly_flag = false;
    }
    else
    {
      if(c >= 'A' && c <= 'Z') c += 32; // lowercase
      arr[words][chars++] = c;
      ugly_flag = true;
    }
  }
  printf("\033[25m\0338\033[32mdone\033[0m\n");

  if(!ugly_flag) free(arr[words--]); // fixes case in which while loop thinks there's a word to be read but there's only random chars
  
  fclose(fp);
  return words;
}

int main(int argc, char const *argv[])
{
  if(argc < 3) 
  {
    printf("Usage: ordered_array_main <dictionary> <text>\n");
    exit(EXIT_FAILURE);
  }

  srand(time(NULL));

  struct SkipList *list = create_skip_list(compare_string, free_string, sizeof(char *));
  if(list == NULL)
  {
    printf("Error creating skip list\n");
    exit(EXIT_FAILURE);
  }

  char *words_to_correct[MAX_WORDS] = {0};
  load_dictionary(argv[1], list);
  
  int n_words = load_array(argv[2], words_to_correct);

  printf("\n\033[1mMAX_HEIGHT\033[22m of skip list set to \033[1m%d\033[22m\n", MAX_HEIGHT);
  clock_t start = clock();
  for(int i = 0; i <= n_words; i++)
  {
    if(search_skip_list(list, &words_to_correct[i]) == NULL)
      printf("\033[31mNot found:\033[0m %30s\n", words_to_correct[i]);
  }
  clock_t end = clock();
  printf("\033[1mTIME\033[22m: %f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);

  for(int i = 0; i <= n_words; i++) free(words_to_correct[i]);
  delete_skip_list(list);
  return (EXIT_SUCCESS);
}

/*****************************************
*  Struttura dati per le liste semplici
*  di interi
******************************************/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"

struct listEl {
    int            info;
    struct listEl* next;
};

typedef struct listEl* list;

list Cons(int x, list xs) {
    list newlist = malloc(sizeof(struct listEl));
    newlist->info = x;
    newlist->next = xs;
    return newlist;
}

void printlist (list l) {
    while (l != NULL) {
        printf("%d ", l->info);
        l = l->next;
    }
    printf("\n");
}

// pre:  l è una lista di interi, eventualmente vuota
// post: l è stata trasformata nella lista dei ranghi dei suoi
//       elementi; il valore ritornato è il rango del primo elemento
//       rispetto alla lista originaria (ovvero il valore del primo elemento
//       della lista così come trasformata da rank()), se questa non è vuota,
//       0 altrimenti
int rank(list l) 
{
    if(l == NULL) return 0;
    l->info = l->info + rank(l->next);
    return l->info;
}
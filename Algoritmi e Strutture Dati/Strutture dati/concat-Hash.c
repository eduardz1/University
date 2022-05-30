/**************************************
*  Struttura dati per tabelle hash
*  con concatenamento
**************************************/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"

// Liste doppie di trabocco

struct listEl {
    int            info;
    struct listEl* pred; // puntatore al predecessore
    struct listEl* next; // puntatore al successivo
};

typedef struct listEl* list;

// post: inserisce la chiave x in un frame
//       il cui predecessore è p e successore è n
list Cons(int x, list p, list n) {
    list newlist = malloc(sizeof(struct listEl));
    newlist->info = x;
    newlist->pred = p;
    newlist->next = n;
    return newlist;
}

void printlist (list l) {
    while (l != NULL) {
        printf("%d ", l->info);
        l = l->next;
    }
    printf("\n");
}

// Tabelle hash con concatenzaione

struct hashFrame {
    int       dim;  // dimensione della tabella
    list*   array;  // puntatore alla tabella array[0..dim-1] 
};

typedef struct hashFrame* HashTable;

// pre:  0 < m
// post: ritorna una tabella hash di dimensione m a chiavi intere;
//       la tabella contiene m puntatori a liste di trabocco ed è
//       inizializzata con tutti NULL
HashTable newHashTable(int m)
{
    HashTable T = malloc(sizeof(struct hashFrame));
    T->dim = m;
    T->array = malloc(m * sizeof(list));
    for(int i = 0; i < m; i++)
        T->array[i] = NULL;
    return T;
}

// pre:  0 <= k chiave, 0 < m == dimensione della tabella
// post: ritorna k mod m
int hashFun(int k, int m)
{
    return k % m;
}

void showTable (HashTable T) {
    for (int i = 0; i < T->dim; i++) {
        printf("%d : ", i);
        printlist(T->array[i]);
    }
}

int main () {
    return 0;
}
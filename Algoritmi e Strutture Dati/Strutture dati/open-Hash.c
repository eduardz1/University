/*************************************
*  Struttura dati per tabelle hash ad
*  indirizzamento aperto
*************************************/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"


struct hashFrame {
    int    dim;  // dimensione della tabella
    int* array;  // puntatore alla tabella array[0..dim-1] 
};

typedef struct hashFrame* HashTable;

// pre:  0 < m
// post: ritorna una tabella hash di dimensione m a chiavi positive,
//       inizializzata con tutti -1 che rappresenta l'assenza di chiavi
HashTable newHashTable(int m)
{
    HashTable T = malloc(sizeof(struct hashFrame));
    T->dim = m;
    T->array = malloc(m * sizeof(int));
    for(int i = 0; i < m; i++)
        T->array[i] = -1;
    return T;
}

// pre:  0 <= k chiave, 0 < m == dimensione della tabella
// post: ritorna k mod m
int hashFun(int k, int m)
{
    return k % m;
}

// pre:  0 <= k chiave, 0 <= i iterazione, 0 < m == dimensione della tabella
// post: ritorna (hashFun(k, m) + i) mod m
int linearProbing(int k, int i, int m)
{
    return (hashFun(k, m) + i) % m;
}

// post: stampa gli elementi di A[0..n-1]
void printarray(int A[], int n) {
    for (int i = 0; i < n; i++)
        printf("%d  ", A[i]);
    printf("\n");
}

int main () {
    return 0;
}
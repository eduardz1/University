/************************************
* Struttura dati degli alberi k-ari
************************************/

#include "Queue.h"
#include "List.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"

struct kTreeVertex {
    int                  key;
    struct kTreeVertex*  child;
    struct kTreeVertex*  sibling;
};

typedef struct kTreeVertex* kTree;

#define Type kTree

kTree consTree(int k, kTree c, kTree s) {
    kTree t = malloc(sizeof(struct kTreeVertex));
    t->key = k;
    t->child = c;
    t->sibling = s;
    return t;
}

kTree leaf(int k, kTree s) {
    return consTree(k, NULL, s);
}

kTree root(int k, kTree c) {
    return consTree(k, c, NULL);
}

// post: stampa indentata dell'albero t con margine
//       iniziale di n tab
void printTree(kTree t, int d) {
    if (t != NULL)
    for (int i = 0; i < d; ++i)
        printf("   ");
    printf("%d\n", t->key);
    kTree cl = t->child;
    while (cl != NULL) {
        printTree(cl, d + 1);
        cl = cl->sibling;
    }
}

// post: ritorna la somma delle etichette delle foglie di t
int sumLeaf(kTree t)
{
    if(t == NULL) return 0;
    if(t->child == NULL) return t->key;

    kTree tmp = t->child;
    int s = 0;
    while(tmp != NULL)
    {
        s = s + sumLeaf(tmp);
        tmp = tmp->sibling;
    }
    return s;
}

// // post: ritorna la lista delle etichette (chiavi) di t visitato in ampiezza
// list kTreeBFS(kTree t) {
//     if (t == NULL)
//         return NULL;
//     list l = NULL; 
//     queue q = NewQueue();
//     EnQueue(t, q);
//     while(!isEmptyQueue(q)) {
//         kTree node = DeQueue(q);
//         l = Cons(node->key, l); // visita
//         // l = Add(node->key, l); // versione con Add
//         node = node->child;
//         while (node != NULL) {
//             EnQueue(node, q);
//             node = node->sibling;
//         }
//     }
//     return reverse(l);
//     // return l; // versione con Add
// }
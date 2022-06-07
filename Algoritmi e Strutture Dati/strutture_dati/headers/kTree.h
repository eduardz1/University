/************************************
* Struttura dati degli alberi k-ari
************************************/

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

struct queueEl {
    Type            info;
    struct queueEl* next;
};

struct queueFrame {
    struct queueEl* front; // primo el. della coda
    struct queueEl* rear;  // ultimo el. della coda
};

typedef struct queueFrame* queue;
typedef kTree Type;

// post: alloca e ritorna una coda vuota
queue NewQueue() {
    queue q = malloc(sizeof(struct queueFrame));
    q->front = NULL;
    q->rear = NULL;
    return q;
}

// post: ritorna true se la coda è vuota, false altrimenti
bool isEmptyQueue(queue q) {
    return q->front == NULL;
}

// post: accoda t come ultimo elemento di q
void EnQueue (Type t, queue q) {
    struct queueEl* newEl = malloc(sizeof(struct queueEl));
    newEl->info = t;
    newEl->next = NULL;
    if (q->front == NULL)
        q->front = q->rear = newEl;
    else // q->front != NULL implica q->rear != NULL
    {
        q->rear->next = newEl;
        q->rear = newEl;
    }
}

// pre:  q non è vuota
// post: ritorna il primo el. di q SENZA rimuoverlo da q
Type First(queue q) {
    return q->front->info;
}

// pre:  q non è vuota
// post: ritorna il primo el. di q RIMUOVENDOLO da q
Type DeQueue(queue q) {
    Type t = q->front->info;
    struct queueEl* oldFirst = q->front;
    if (q->front == q->rear) // la coda ha un solo el.
        q->front = q->rear = NULL;
    else
        q->front = q->front->next;
    free(oldFirst);
    return t;
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
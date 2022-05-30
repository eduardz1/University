/**************************************
*  Code semplici di el. di tipo T = int
**************************************/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"

// nelle applicazioni il tipo int può essere sostituito con qualunque altro

typedef int Type;

// coda di el. di tipo T, ossia di puntatori a kTreeVertex

struct queueEl {
    Type            info;
    struct queueEl* next;
};

struct queueFrame {
    struct queueEl* front; // primo el. della coda
    struct queueEl* rear;  // ultimo el. della coda
};

typedef struct queueFrame* queue;

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

int main () {
    return 0;
}
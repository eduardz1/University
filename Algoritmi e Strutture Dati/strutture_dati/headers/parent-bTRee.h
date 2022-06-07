/***********************************
*  Struttura dati per alberi binari
*  con puntatore al padre
***********************************/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"

struct BtreeNd {
    int             key;
    struct BtreeNd* parent;
    struct BtreeNd* left;
    struct BtreeNd* right;
};

typedef struct BtreeNd* btree;

// pre: k etichetta, p punta al padre (NULL se si alloca la radice)
//      l punta al figlio sinistro, r al figlio destro (NULL se assenti)
// post: alloca un nuovo nodo con etichetta k, padre p, 
//       figlio sin. l e figlio des. r
btree ConsTree(int k, btree p, btree l, btree r) {
    btree rootnode = malloc(sizeof(struct BtreeNd));
    rootnode->key = k;
    rootnode->parent = p;
    rootnode->left = l;
    rootnode->right = r;
    return rootnode;
}

// post: stampa indentata dell'albero bt con margine
//       iniziale di n tab
void printtree(btree bt, int n) {
    if (bt != NULL) {
        for (int i = 0; i < n; i++) 
            printf("   ");
        printf("%d\n", bt->key);
        printtree(bt->left, n + 1);
        printtree(bt->right, n + 1);
    }
}
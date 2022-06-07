/************************************
*  Struttura per gli alberi binari
*  (senza puntatore al padre)
************************************/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#define SEPARATOR "#<ab@17943918#@>#"

struct BtreeNd {
    int             key;
    struct BtreeNd* left;
    struct BtreeNd* right;
};

typedef struct BtreeNd* btree;

btree ConsTree(int k, btree l, btree r) {
    btree rootnode = malloc(sizeof(struct BtreeNd));
    rootnode->key = k;
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
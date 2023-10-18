#include "headers/bTree.h"

/*
 * Un albero binario non vuoto T è completo se per ogni k ≤ height(T ) il livello k ha esattamente
 * 2k nodi. Si dia un algoritmo asintoticamente ottimo per decidere se T è completo.
 * Si dia una procedura ottima basata sulla BFS per decidere se T sia completo. Si consideri quindi la
 * seguente definizione alternativa di albero binario completo: T è completo se costituito da un solo nodo
 * oppure se ha due sottoalberi completi di uguale altezza. Si dimostri che le due definizioni sono equivalenti;
 * quindi si dia un algoritmo ottimo per decidere se T è completo basato sulla seconda definizione e ricorsivo
 * (quindi basato su una DFS).
 */
bool isComplete(btree t)
{
    // non funziona penso ciò che c'è scritto sotto
    if(t == NULL) return true;
    if(t->left == NULL && t->right == NULL) return true;
    if((t->left == NULL && t->right != NULL) ||
       (t->left != NULL && t->right == NULL)) return false;

    return isComplete(t->left) && isComplete(t->right);
}

int main()
{

    btree bt =
        ConsTree(20,
            ConsTree(35,
                ConsTree(9, NULL, NULL),
                ConsTree(1, NULL, NULL)
            ),
            ConsTree(5, NULL, NULL)
        );

    printf("Albero dato:\n");
    printtree(bt, 0);

    return 0;
}
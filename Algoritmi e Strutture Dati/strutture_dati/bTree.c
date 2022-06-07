#include "headers/bTree.h"

bool containsBranchOfLengthN(btree t, int n)
{
    if(t = NULL) return false;

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
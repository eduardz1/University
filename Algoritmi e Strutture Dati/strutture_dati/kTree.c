#include "headers/kTree.h"
#include <limits.h>

// int* maxElemOfEachLayer(kTree t) {
//     if(t == NULL) return NULL;
//     int n = Depth(t); // int n = INT_MAX se non c'è tempo
//     int *array = malloc(sizeof(int) * n);

//     queue q = EnQueue(q, t);
//     int max = 0, count = 0;
//     while(isNotEmpty(q))
//     {
//         kTree tmp = DeQueue(q);
//         tmp = tmp->child;
//         count++;
//         while(tmp != NULL)
//         {
//             EnQueue(q, tmp);
//             array[count] = Max(array[count], tmp->key);
//             tmp = tmp->sibling;
//         }
//     }
//     return array;
// }

void printMinElemOfEveryLayer(kTree t)
{
    if(t == NULL) return;

    queue q = NewQueue();
    EnQueue(t, q);
    int min;
    while(!isEmptyQueue(q))
    {
        kTree tmp = DeQueue(q);
        min = INT_MAX;
        tmp = tmp->child;
        if(tmp == NULL) continue;
        while(tmp != NULL)
        {
            EnQueue(tmp, q);
            if(min > tmp->key) min = tmp->key;
            tmp = tmp->sibling;
        }
        printf("%d\n", min);
    }
}

void printSumNodesOfEveryLayer(kTree t)
{
    if(t == NULL) return;
    
    queue q = NewQueue();
    EnQueue(t, q);
    int sum;
    int i = 0;
    int j = 0;
    /**
     * @invariant j == NUM_NODES in layer of tmp
     */
    while(!isEmptyQueue(q))
    {
        kTree tmp = DeQueue(q);
        tmp = tmp->child;
        while(tmp != NULL)
        {
            j++;
            EnQueue(tmp, q);
            sum += tmp->key;
            tmp = tmp->sibling;
        }
        i--;
        
        if(i == 0 && !isEmptyQueue(q))
        {
            printf("%d\n", sum);
            i = j; // we finished iterating over the layer, assign the counter to the next layer cardinality
            j = 0; // reset layer count
            sum = 0;
        }
    }
}

int main() {

// test 1
    kTree t =
       root(12, 
            consTree(22, 
                leaf(1,NULL), 
                leaf(2, 
                    root(32, 
                        leaf(3, 
                            leaf(4, NULL)
                        )
                    )
                )
            )
       );

    

/* t in forma indentata:
12
	22
		1
	2
	32
		3
		4
*/

    printf("Albero dato:\n");
    printTree(t, 0);

    // printf("Sum:\t%d\n", sumLeaf(t));
    printf("\n###############################\n\n");
    printSumNodesOfEveryLayer(t);
    printf("\n###############################\n\n");
    printMinElemOfEveryLayer(t);
}

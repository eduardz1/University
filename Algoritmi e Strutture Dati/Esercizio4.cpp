#include <assert.h>

/**
 * @brief Binary search that returns index of element n if found, -1 otherwise
 *
 * @pre A[i..j] array of integers in non descending order, n integer
 * @post returns k = min{k' \in i..j | A[k'] == a} if it exists, -1 otherwise
 * @invariant i'..j' \subseteq i..j et for each h \in i'..j' A[h] == n => h \in i'..j'
 */
int algoritmo_i (int array[],int i, int j, int n)
{
    assert(j>=0 && i>=0);

    while(i<=j)
    {
        int k = (i+j)/2;

        if(array[k] < n)
            i = k+1;
        else if(array[k] > n)
            j = k-1;
        else
            return k;
    }
    return -1;
}


int algoritmo_r (int array[],int i, int j, int n)
{
    int median = j/2;

}

int main(int argc, char const *argv[])
{
    int a[8] = {};
    int aa = 6;
    int b[8] = {};
    int bb = 6;
    //int r1 = algoritmo_i(a, 8, aa);
    //int r2 = algoritmo_r(b, 8, bb);

    //printf("%d, %d\n", r1, r2);
    return 0;
}
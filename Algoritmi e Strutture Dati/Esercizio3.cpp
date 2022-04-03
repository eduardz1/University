#include <assert.h>

int algoritmo_i (int a[],int a_length, int aa)
{
    assert(a_length>=0);
    // Invariante:       i <= a_length
    // Inizializzazione: i = 0 -> 0 <= a_length
    // Mantenimento:     i < n con n > 0 -> i+1 <= n
    for(int i = 0; i<a_length; i++)
    {
        if(a[i] == aa)
            return i;
    }
    return -1;
}

/* Wrong: ritorna l'ultimo k non il primo

int algoritmo_r (int b[], int b_length, int bb)
{
    if(b_length==0)
    {
        if(b[0] == bb)
            return 0;
        else
            return -1;
    }
    else
    {
        if(b[b_length-1] == bb)
            return b_length-1;
        else
            algoritmo_r(b, b_length - 1, bb);
    }
}*/

int main(int argc, char const *argv[])
{
    int a[8] = {};
    int aa = 6;
    int b[8] = {};
    int bb = 6;
    int r1 = algoritmo_i(a, 8, aa);
    //int r2 = algoritmo_r(b, 8, bb);

    //printf("%d, %d\n", r1, r2);
    return 0;
}

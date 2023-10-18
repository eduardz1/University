/*
 * Implementare la funzione con prototipo:
 * int verify_sum(int *array, int size);
 *
 * Restituisce TRUE se e solo se ogni elemnto (tranne il primo) è uguale alla
 * somma degli elementi precedenti; in ogni altro caso la funzione dovrà
 * restituire FALSE.
 * La soluzione deve fare uso di una funzione di appoggio "compute_sum" che
 * calcoli la somma di una certa sequenza degli elementi di un array.
 * Definite oppportunamente TRUE e FALSE, gestite ogni possibile caso per array e size.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRUE 1
#define FALSE 0

int compute_sum(int *array, int size)
{
    int sum = 0;
    for (int i = 0; i < size; i++)
    {
        sum += array[i];
    }

    return sum;
}

int verify_sum(int *array, int size)
{
    if (size <= 0 || array == NULL)
    {
        return FALSE;
    }
    else if (size == 1)
    {
        return TRUE;
    }

    return verify_sum(array, size - 1) && compute_sum(array, size - 1) == array[size - 1];
}

int main(int argc, char const *argv[])
{
    int s1[] = {1, 2, 3, 4, 5, 6, 7};
    int s2[] = {6, 6, 12, 24, 48};
    int s3[] = {6, 6, 12, 24, 47};
    int s4[] = {6, 6, 12, 24, 49};
    int s5[] = {};
    int s6[] = {4};

    printf("%d\n", verify_sum(s2, 5) == TRUE);
    printf("%d\n", verify_sum(s1, 7) == FALSE);
    printf("%d\n", verify_sum(s3, 5) == FALSE);
    printf("%d\n", verify_sum(s4, 5) == FALSE);
    printf("%d\n", verify_sum(s5, 0) == FALSE);
    printf("%d\n", verify_sum(s6, 1) == TRUE);

    return 0;
}
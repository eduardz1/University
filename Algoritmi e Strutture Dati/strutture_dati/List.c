#include "headers/List.h"

int main() {
    list a = Cons(1, Cons(2, Cons(3, NULL)));
    printlist(a);

    int res = rank(a);

    printf("Dopo rank:\n");
    printlist(a);
    printf("rank:\t%d\n", res);

    return 0;
}


#include "headers/List.h"

// list OddEven(list l)
// {
//     list odd;
//     list even;
//     list tmp = l;

//     while(tmp != NULL)
//     {
//         if(tmp->info % 2) // even
//             even = Cons(tmp->info, even);
//         else // odd 
//             odd = Cons(tmp->info, odd);
        
//         free(tmp);
//         tmp = tmp->next;
//     }
    
//     reverse(even);
//     reverse(odd);
//     l = append(odd, even);
//     return l;
// }

int main() {
    list a = Cons(1, Cons(2, Cons(3, NULL)));
    printlist(a);

    int res = rank(a);

    printf("Dopo rank:\n");
    printlist(a);
    printf("rank:\t%d\n", res);

    return 0;
}


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

bool equal(list a, list b)
{
    if(a == NULL) return b == NULL;
    if(b == NULL) return false;
    return a->info == b->info && equal(a->next, b->next);
}

/*
 * Si dia lo pseudo-codice della funzione Multiples(L) che data una lista semplice L di
 * n elementi restituisca il numero degli elementi che hanno almeno una copia in L. 
 * Ad esempio: se L = [3, 2, 3, 3, 5, 2] allora Multiples(L) = 2.
 * 
 * Suggerimento. Una semplice soluzione è O(n2), ma ne esiste una O(n log n).
 */
int multiples(list l)
{
    //merge_sort(l); // destructively sorts l, don't really feel like implementing it

    list tmp = l;
    int count = 0;
    bool flag = true;

    /**
     * @pre l is sorted
     */
    while (tmp != NULL && tmp->next != NULL)
    {
        if(flag && (tmp->info == tmp->next->info))
        {
            count++;
            flag = false;
        }

        if(tmp->info != tmp->next->info)
        {
            flag = true;
        }
        
        tmp = tmp->next;
    }
    return count;
}


/** 
 * @pre  l è una lista di interi, eventualmente vuota
 * 
 * @post l è stata trasformata nella lista dei ranghi dei suoi
 *       elementi; il valore ritornato è il rango del primo elemento
 *       rispetto alla lista originaria (ovvero il valore del primo elemento
 *       della lista così come trasformata da rank()), se questa non è vuota,
 *       0 altrimenti
 */
int rank(list l) 
{
    if(l == NULL) return 0;
    l->info = l->info + rank(l->next);
    return l->info;
}

list reverse(list l)
{
    list tmp = l;
    list res = NULL;
    while(tmp != NULL)
    {
        res = Cons(tmp->info, res);
        tmp = tmp->next;
    }
    return res;
}

/*
 * Una lista si dice palindroma se se le sue due metà, eliminando eventualmente l’elemento di
 * posto medio se la lunghezza della lista è dispari, sono simmetriche ossia l’una l’inversa dell’altra.
 * Si dia lo pseudo-codice della funzione Palindrome(L) che data una lista semplice L di n elementi decida
 * se L è palindroma in tempo O(n).
 */
bool palindrome(list l)
{
    list rev = reverse(l);
    list fwd = l;

    while(rev != NULL && fwd != NULL)
    {
        if(rev->info != fwd->info) return false;
    }

    if(rev == NULL && fwd != NULL) // fwd longer than rev, max 1 elem diff allowed
        return fwd->next == NULL;
    else if(fwd == NULL && rev != NULL) // rev longer than fwd, max 1 elem diff allowed
        return rev->next == NULL;
    return true;
}

bool palindrome_rec(list l)
{
    list rev = reverse(l);
    return equal(l, rev);
}

/**
 * @pre a e b liste ordinate, senza ripetizioni
 * @return list intersection so that every node x -> {x | x \in A && x \in B}
 */
list intersection_list(list a, list b)
{
    if(a == NULL || b == NULL) return NULL;

    if(a->info == b->info) return Cons(a->info, intersection_list(a->next, b->next));

    if(a->info > b->info)
        return intersection_list(a, b->next);
    else
        return intersection_list(a->next, b);
}

/**
 * @pre a e b liste ordinate, senza ripetizioni
 * @return list union so that every node x -> {x | x \in A || x \in B}
 */
list union_list(list a, list b)
{
    if(a == NULL) return b;
    if(b == NULL) return a;

    if(a->info == b->info) return Cons(a->info, union_list(a->next, b->next));

    if(a->info > b->info)
        return Cons(b->info, union_list(a, b->next));
    else
        return Cons(a->info, union_list(a->next, b));
}

/**
 * @pre a e b liste ordinate, senza ripetizioni
 * @return list difference so that every node x -> {x | x \in A && x \notin B}
 */
list difference_list(list a, list b)
{
    if(a == NULL) return NULL;
    if(b == NULL) return a;

    if(a->info == b->info) difference_list(a->next, b->next);

    if(a->info > b->info)
        return difference_list(a, b->next);
    else
        return Cons(a->info, difference_list(a->next, b));
}

/**
 * @pre a e b liste ordinate, senza ripetizioni
 * @return list symmetric difference so that every node x -> {x | (x \in A && x \notin B) || (x \in B && x \notin A)}
 */
list sym_difference_list(list a, list b)
{
    /*
     * Quick solution: return difference_list(union_list(a, b), intersection_list(a, b))
     */ 

    if(a == NULL) return b; // {1 2 3 4 5} <> {1 2 7} -> {3 4 5 7} 
    if(b == NULL) return a; // {3 4 5} <> {1 2 3 4 7} -> {1 2 5 7} 

    if(a->info == b->info) sym_difference_list(a->next, b->next);

    if(a->info > b->info)
        return Cons(b->info, sym_difference_list(a, b->next));
    else
        return Cons(a->info, sym_difference_list(a->next, b));
}

// THETA(n^2)
list foo(list l)
{
    list m = Cons(0, NULL);
    list p = m;
    while(l != NULL)
    {
        int n = 0;
        list q = l;
        while(q != NULL) // calcola il rango di q, viene salvato in n
        {
            n = n + q->info;
            q = q->next;
        }
        p->next = Cons(n, NULL); // aggiunge un nodo a m con il rango
        p = p->next;
        l = l->next;
    }
    return m->next; // restituisce la lista linkata di ranghi ignorando il primo
                    // nodo del quale non viene neanche mai effettuata la free wtf
}

list copy_list(list l)
{
    if(l == NULL) return NULL;
    return Cons(l->info, copy_list(l->next));
}
list goo(list l)
{
    list res = copy_list(l);
    rank(res);
    return res;
}

int main()
{
    list a = Cons(1, Cons(2, Cons(3, NULL)));
    printlist(a);

    int res = rank(a);

    printf("Dopo rank:\n");
    printlist(a);
    printf("rank:\t%d\n", res);

    return 0;
}

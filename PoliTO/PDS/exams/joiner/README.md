In una macchina utensile, sono in esecuzione N thread concorrenti, ciascuno dei quali rileva continuamente una sequenza di valori, risultato dell'elaborazione delle
misurazioni di un sensore. I valori devono essere raggruppati N a N in una struttura dati per essere ulteriormente trattati dal sistema. A questo scopo è definita la
seguente classe thread-safe:

```cpp
class Joiner {
    public: Joiner(int N); // N is the number of values that must be conferred
    std::map<int, double> supply(int key, double value);
};
```

Il metodo bloccante supply(...) riceve una coppia chiave/valore generata da un singolo thread e si blocca senza consumare CPU fino a che gli altri N-1 thread hanno inviato
le loro misurazioni. Quando sono arrivate N misurazioni (corrispondenti ad altrettante invocazioni concorrenti), si sblocca e ciascuna invocazione precedentemente bloccata
restituisce una mappa che contiene N elementi (uno per ciascun fornitore). Dopodiché, l'oggetto Joiner pulisce il proprio stato e si prepara ad accettare un nuovo gruppo di
N misurazioni, in modo ciclico.

Si implementi tale classe, facendo attenzione a non mescolare nuovi conferimenti con quelli della tornata precedente (un thread appena uscito potrebbe essere molto veloce
a rientrare, ripresentandosi con un nuovo valore quando lo stato non è ancora stato ripulito).

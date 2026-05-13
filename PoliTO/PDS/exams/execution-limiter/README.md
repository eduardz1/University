2022-07-08
All'interno di un programma è necessario garantire che non vengano eseguite CONTEMPORANEAMENTE più di N invocazioni di operazioni potenzialmente lente.
A questo scopo, è stata definita la struttura dati ExecutionLimiter che viene inizializzata con il valore N del limite.
Tale struttura è thread-safe e offre solo il metodo pubblico generico execute( f ), che accetta come unico parametro una funzione f, priva di parametri
che ritorna il tipo generico R. Il metodo execute(...) ha, come tipo di ritorno, lo stesso tipo R restituito da f ed ha il compito di mantere il conteggio
di quante invocazioni sono in corso. Se tale numero è già pari al valore N definito all'atto della costruzione della struttura dati, attende, senza provocare
consumo di CPU, che scenda sotto soglia, dopodiché invoca la funzione f ricevuta come parametro e ne restituisce il valore. Poiché l'esecuzione della funzione f
potrebbe fallire, in tale caso, si preveda di decrementare il conteggio correttamente. Si implementi, usando i linguaggi Rust o C++, tale struttura dati,
garantendo tutte le funzionalità richieste.use std::sync::{Arc, Condvar, Mutex};

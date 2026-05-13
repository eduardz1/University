La classe CountDownLatch permette di sincronizzare uno o più thread che devono attendere, senza consumare CPU, il completamento di operazioni in corso in altri thread. All’atto della costruzione, gli oggetti di questa
classe contengono un contatore inizializzato con un valore intero strettamente positivo.

Oltre al costruttore, questa classe offre due soli metodi pubblici: void await() e void countDown(). Quando un thread invoca await(), rimane bloccato fino a che il contatore non raggiunge il valore 0, dopodiché ritorna;
se, viceversa, all’atto della chiamata il contatore vale già 0, il metodo ritorna immediatamente.

Quando viene invocato countDown(), se il contatore è maggiore di zero, viene decrementato e se, come conseguenza del decremento, diventa nullo libera i thread bloccati all’interno di await(). Se, viceversa, il contatore
valeva già a zero, l’invocazione di countDown() non ha effetti.

Si implementi tale classe utilizzando le librerie standard C++11.

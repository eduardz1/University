2023-06-20
La struct MpMcChannel<E: Send> è una implementazione di un canale su cui possono scrivere molti produttori e da cui possono attingere valori molti consumatori.
Tale struttura offre i seguenti metodi:

    new(n: usize) -> Self    //crea una istanza del canale basato su un buffer circolare di "n" elementi

    send(e: E) -> Option<()>    //invia l'elemento "e" sul canale. Se il buffer circolare è pieno, attende
                                //senza consumare CPU che si crei almeno un posto libero in cui depositare il valore
                                //Ritorna:
                                    // - Some(()) se è stato possibile inserire il valore nel buffer circolare
                                    // - None se il canale è stato chiuso (Attenzione: la chiusura può avvenire anche
                                    //    mentre si è in attesa che si liberi spazio) o se si è verificato un errore interno

    recv() -> Option<E>         //legge il prossimo elemento presente sul canale. Se il buffer circolare è vuoto,
                                //attende senza consumare CPU che venga depositato almeno un valore
                                //Ritorna:
                                    // - Some(e) se è stato possibile prelevare un valore dal buffer
                                    // - None se il canale è stato chiuso (Attenzione: se, all'atto della chiusura sono
                                    //    già presenti valori nel buffer, questi devono essere ritornati, prima di indicare
                                    //    che il buffer è stato chiuso; se la chiusura avviene mentre si è in attesa di un
                                    //    valore, l'attesa si sblocca e viene ritornato None) o se si è verificato un errore interno.

    shutdown() -> Option<()>    //chiude il canale, impedendo ulteriori invii di valori.
                                //Ritorna:
                                    // - Some(()) per indicare la corretta chiusura
                                    // - None in caso di errore interno all'implementazione del metodo.

Si implementi tale struttura dati in linguaggio Rust, senza utilizzare i canali forniti dalla libreria standard né da altre librerie, avendo cura di garantirne
la correttezza in presenza di più thread e di non generare la condizione di panico all'interno dei suoi metodi.

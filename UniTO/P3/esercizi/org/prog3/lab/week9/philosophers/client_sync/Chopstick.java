package org.prog3.lab.week9.philosophers.client_sync;

/**
 * SINCRONIZZAZIONE LATO CLIENT
 *
 * Classe che rappresenta una bacchetta. Essendo la sincronizzazione
 * gestita dai metodi dei filosofi (sincronizzazione lato client),
 * la bacchetta non mantiene informazioni relative ai filosofi e non
 * ha metodi sincronizzati.
 */

class Chopstick {
    // la seguente operazione è thread-safe dato che in java l'inizializzazione
    // statica dei membri dato è garantita essere thread safe.
    private static int counter = 0;
    private int number = counter++;

    public String toString() {
        return "Chopstick " + number;
    }

    /**
     * @return   il numero identificativo della bacchetta
     */
    public int chopstickNumber() {
        return number;
    }
}

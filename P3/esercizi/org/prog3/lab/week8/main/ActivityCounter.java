package org.prog3.lab.week8.main;

/**
 * Contatore thread safe.
 */

public class ActivityCounter {
    int counter;

    /**
     * Costruttore della classe, inizializza counter a zero
     */

    public ActivityCounter() {
        counter = 0;
    }

    /**
     * Incremente in modo thread-safe il contatore
     */

    synchronized void incrementCounter() {
        counter++;
    }

    /**
     * @return      il valore di counter in formato stringa
     */
    @Override
    public String toString() {
        return String.valueOf(counter);
    }
}

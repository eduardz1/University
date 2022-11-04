package esercizi.observerobservable.es1_svolto;

import java.util.Observable;

/**
 * La classe Counter è un observable che notifica ogni cambiamento del valore val
 */
class Counter extends Observable {
    private int val;
    private int start;
    private int stop;

    public Counter(int start, int stop) {
        this.start = start;
        this.stop= stop;
    }

    public int getVal() {
        return val;
    }

    /**
     * Metodo che, quando genera un multiplo di 5, richiama gli osservatori
     * tramite notifyObservers() (in questo caso, il Filter)
     */
    public void start() {
        for (val=start; val<=stop; val++) {
            setChanged();
            notifyObservers();
        }
    }
}
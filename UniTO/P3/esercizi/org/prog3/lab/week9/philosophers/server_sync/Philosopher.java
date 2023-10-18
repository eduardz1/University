package org.prog3.lab.week9.philosophers.server_sync;

/**
 * SINCRONIZZAZIONE LATO SERVER
 *
 * Classe che rappresenta un filosofo. Ciascun filosofo alterna momenti
 * in cui pensa e momenti in cui mangia; quando deve mangiare ha bisogno di
 * prendere le due bacchette a lui adiacenti, quando pensa le rilascia così
 * che altri filosofi possano prenderle.
 */
class Philosopher extends Thread {
    // la seguente operazione è thread-safe dato che in java l'inizializzazione
    // statica dei membri dato è garantita essere thread safe.
    private static int counter = 0;
    private int number = counter++;
    private Chopstick left, right;

    /**
     * Costruttore; inizializza quali bacchette dovranno essere
     * prese dal filosofo per mangiare, e fa partire il thread.
     *
     * @param l   La bacchetta che prenderà con la mano sinistra
     * @param r   La bacchetta che prenderà con la mano destra
     */
    public Philosopher(Chopstick l, Chopstick r) {
        left = l;
        right = r;
        start();
    }

    /**
     * Metodo che viene invocato dal filosofo quando
     * finisce di mangiare e inizia a pensare.
     */
    public void think() {
        System.out.println(this + "\t0 T 0");
        try {
            sleep((long)(Math.random() * 1000));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    /**
     * Metodo invocato quando il filosofo deve mangiare.
     * Per completare l'azione ha bisogno di prendere le
     * due bacchette a lui adiacenti; la sincronizzazione
     * tra due filosofi che vogliono prendere la stessa
     * bacchetta è gestita dai metodi della bacchetta
     * (sincronizzazione lato server).
     */
    public void eat() {
        left.grab(this);
        System.out.println(this + "\t1 W 0");
        right.grab(this);
        System.out.println(this + "\t1 E 1");
        try {
            sleep((long)(Math.random() * 1000));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        right.release(this);
        System.out.println(this + "\t0 R 1");
        left.release(this);
        System.out.println(this + "\t0 R 0");
    }

    public String toString() {
        return "Philosoper " + number;
    }

    /**
     * Metodo lanciato dall'esecuzione del thread. Un filosofo
     * alterna di continuo momenti in cui pensa e in cui mangia.
     */
    public void run() {
        while(true) {
            think();
            eat();
        }
    }
}
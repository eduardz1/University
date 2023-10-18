package org.prog3.lab.week9.philosophers.client_sync;

/**
 * SINCRONIZZAZIONE LATO CLIENT
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
    private final Chopstick left, right;

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
        System.out.println(this + " thinking");
        try {
            sleep((long)(Math.random() * 1000));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    /**
     * Metodo invocato quando il filosofo deve mangiare. La sincronizzazione tra due filosofi che
     * vogliono prendere la stessa bacchetta è fatta dai metodi dei filosofi stessi, mediante
     * i blocchi synchronized sul lock delle bacchette (prima ottenendo la bacchetta di sinistra
     * e poi quella di destra).
     */
    public void eat() {
        System.out.println(this + " Waiting to grab chopstick " + left.chopstickNumber());
        synchronized(left) {
            System.out.println(this + " got " + left.chopstickNumber());
            System.out.println(this + " Waiting to grab chopstick " + right.chopstickNumber());

            synchronized(right) {
                System.out.println(this + " got " + right.chopstickNumber());
                try {
                    System.out.println(this + " Eating");
                    sleep((long)(Math.random() * 1000));
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            System.out.println(this + " Released chopstick " + right.chopstickNumber());
        }

        System.out.println(this + " Released chopstick " + left.chopstickNumber());
    }

    public String toString() {
        return "Philosoper " + number + " ";
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
package org.prog3.lab.week9.philosophers.server_sync;

/**
 * SINCRONIZZAZIONE LATO SERVER
 *
 * Classe che rappresenta una bacchetta. La sincronizzazione tra più
 * filosofi che cercano di prendere la stessa bacchetta viene gestita
 * dai metodi della bacchetta stessa (sincronizzazione lato server).
 */
class Chopstick {
    // la seguente operazione è thread-safe dato che in java l'inizializzazione
    // statica dei membri dato è garantita essere thread safe.
    private static int counter = 0;
    private int number = counter++;
    Philosopher owner = null;

    /**
     * Metodo invocato da un filosofo per prendere una bacchetta.
     * La sincronizzazione è realizzata sul lock della bacchetta:
     * se questa è già presa, il filosofo va in coda di wait.
     *
     * @param f   Il filosofo che ha invocato il metodo e che
     *            vuole prendere la bacchetta
     */
    public synchronized void grab(Philosopher f) {
        try {
            while(owner != null)
                wait();
        }
        catch(InterruptedException e) {
            e.printStackTrace();
        }
        owner = f;
    }

    /**
     * Metodo invocato da un filosofo per rilasciare una bacchetta
     * precedentemente presa. La sincronizzazione viene fatta sul
     * lock della bacchetta.
     *
     * @param f   Il filosofo che vuole rilasciare la bacchetta
     */
    public synchronized void release(Philosopher f) {
        if(f == owner) {
            owner = null;
        }

        notify();
        // basta una notify, anziché una notifyAll, in quanto basta svegliare un filosofo a caso
    }

    public String toString() {
        return "Chopstick " + number;
    }
}

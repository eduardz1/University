package org.prog3.lab.week8.main;

import java.util.ArrayList;

/**
 * Una activity è una unità di esecuzione a sé stante. In questo semplice esempio tutte le attività
 * fanno la stessa cosa (per maggiori informazioni, vedere documentazione del methodo `run`)
  */

public class Activity implements Runnable {
    ArrayList<Thread> waitFor;
    int activityNumber;
    int secondsToWait;
    ActivityCounter activityCounter;

    /**
     * Costruttore della classe.
     *
     * @param    activityNumber  numero assegnato alla attività
     * @param    secondsToWait   numero di secondi che dovrà attendere il thread prima di terminare
     * @param    threadToWait    lista dei thread da cui l'attività dipende
     * @param    activityCounter counter condiviso thread-safe
     */

    public Activity(int activityNumber, int secondsToWait, ArrayList<Thread> threadToWait, ActivityCounter activityCounter) {
        this.waitFor = new ArrayList<>(threadToWait);
        this.activityNumber = activityNumber;
        this.secondsToWait = secondsToWait;
        this.activityCounter = activityCounter;
    }


     /**
      * Esegue le azioni previste da questa attività. In questa semplice implementazione:
      *  - stampa a video un messaggio per segnalare che si sta mettendo in attesa della terminazione dei thread
      *     da cui dipende l'attività corrente
      *  - attende che i thread da cui dipende l'attività corrente terminino
      *  - segnala che l'esecuzione inizia
      *  - stampa a video il valore attuale del contatore condiviso
      *  - si mette in attesa per il numero di secondi specificato al momento della costruzione dell'oggetto
      *  - incrementa il valore del contatore
      *  - segnala il termine dell'attività
      */

    @Override
    public void run() {
        System.out.println("Activity " + activityNumber + " waiting...");

        for(Thread thread: waitFor) {
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println("Activity " + activityNumber + " running, counter:" + activityCounter);

        try {
            Thread.sleep(secondsToWait * 1000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        activityCounter.incrementCounter();
        System.out.println("Activity " + activityNumber + " ended.");
    }
}

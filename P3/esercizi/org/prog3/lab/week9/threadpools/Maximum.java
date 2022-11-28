package org.prog3.lab.week9.threadpools;

import java.util.concurrent.Callable;

/**
 * Classe che rappresenta un task asincrono, che
 * produce un risultato di computazione di tipo int.
 */
class Maximum implements Callable<Integer> {
    private int[] list;

    /**
     * Costruttore della classe.
     *
     * @param list   Riga di una matrice di cui trovare
     *               il massimo locale.
     */
    public Maximum(int[] list) {
        this.list = list;
    }

    /**
     * Esecuzione del task, che trova il massimo nella
     * riga di una matrice.
     *
     * @return   Il valore massimo della riga esaminata.
     */
    public Integer call() {
        System.out.println("INIZIO");
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        int max = list[0];
        for (int j : list)
            if (j > max)
                max = j;
        System.out.println("Massimo locale: "+ max);
        System.out.println("FINE");
        return max;
    }
}

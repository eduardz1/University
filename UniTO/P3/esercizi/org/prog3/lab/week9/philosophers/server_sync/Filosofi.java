package org.prog3.lab.week9.philosophers.server_sync;

import java.util.ArrayList;

/**
 * SINCRONIZZAZIONE LATO SERVER
 *
 * Classe che contiene il main e che inizializza filosofi e bacchette.
 * In questa versione la sincronizzazione è gestita dai metodi delle bacchette.
 */
public class Filosofi {
	public static void main(String[] args) {
		int numPhilosophers = 3;
		ArrayList<Philosopher> phil = new ArrayList<>();

		Chopstick left = new Chopstick();
		Chopstick right = new Chopstick();
		Chopstick first = left;
		phil.add(new Philosopher(left, right));
		for(int i=0; i < numPhilosophers-2; ++i) {
			left = right;
			right = new Chopstick();
			phil.add(new Philosopher(left, right));
		}

		// Questo programma può andare in deadlock quando
		// tutti i filosofi hanno afferrato la bacchetta
		// di sinistra e sono in attesa di quella di destra
		// Per evitare il deadlock si possono scambiare i due
		// parametri dell'ultimo filosofo: prima prende la
		// bacchetta di destra e poi quella di sinistra
		phil.add(new Philosopher(first,left));
	}
}



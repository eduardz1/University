package org.prog3.lab.week9.threadpools;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.FutureTask;
import java.util.concurrent.Executors;
import java.util.*;

/**
 * Classe che contiene il main. Crea dei tasks asicroni che lavorano sulla
 * stessa matrice, e che sono eseguiti da un ThreadPool.
 */
public class CallableTest {
	private static int N = 100;
	private static int NUM_THREADS = 10;

    public static void main (String[] args) {
		int[][] matr = new int[N][N];
		initialize(matr);
		print(matr);

		int maximum = matr [0][0];

		ExecutorService executor = Executors.newFixedThreadPool(NUM_THREADS);
		Vector<FutureTask<Integer>> tasks = new Vector<>();
		for (int i=0; i<N; i++) {
			FutureTask<Integer> ft = new FutureTask<>(new Maximum(matr[i]));
			tasks.add(ft);
			executor.execute(ft);
		}
		try {
			for (int i=0; i<matr.length; i++) {
				FutureTask<Integer> f = tasks.get(i);
				int localMax = f.get();
				if (localMax > maximum)
					maximum = localMax;
			}
		} catch (Exception e) {System.out.println(e.getMessage());}
		System.out.println("Il massimo è: " + maximum);

		executor.shutdown();
    }

    /**
	 * Inizializza una matrice di interi con numeri casuali.
	 *
	 * @param matr   La matrice da inizializzare
	 */
  	private static void initialize(int[][] matr) {
		Random r = new Random();
		for (int i=0; i<matr.length; i++) {
			for (int j=0; j<matr[i].length; j++) {
				matr[i][j] = r.nextInt(matr.length * matr.length * 1000);
			}
		}
  	}

  	/**
	 * Stampa le informazioni relative a una matrice.
	 *
	 * @param matr   La matrice di cui stampare le informazioni
	 */
  	private static void print(int[][] matr) {
		System.out.println("Matrix size [" + matr.length + "," + matr[0].length + "]" );
  	}
}
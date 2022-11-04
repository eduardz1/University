package esercizi.observerobservable.es1_svolto;

import java.util.List;
import java.util.Observable;
import java.util.Observer;

/**
 * La classe Visualizer osserva il Filter; quando quest'ultimo
 * invoca il metodo notifyObservers() all'interno del metodo filter(),
 * viene chiamato il metodo update() del Visualizer
 */
class Visualizer {
    public void visualize(List<Integer> lista) {
        if(lista.size() % 2 != 0) {
            return;
        }

        System.out.println("List size:" + lista.size());
        for (Integer i : lista) {
            System.out.println(i.intValue());
        }
        System.out.println();
    }
}
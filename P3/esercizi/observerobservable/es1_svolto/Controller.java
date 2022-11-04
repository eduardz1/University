package esercizi.observerobservable.es1_svolto;

import java.util.Observable;
import java.util.Observer;

/**
 * Gestisce l'interazione fra i modelli (counter e filter) e la vista (visualizer)
 */
public class Controller implements Observer {
    Counter counter;
    Visualizer visualizer;
    Filter filter;

    /**
     * Inizializza il controller imposta i collegamenti (observer/observable) tra
     * le varie componenti.
     * @param c il counter da utilizzare
     * @param f il filtro da utilizzare
     * @param v la vista da utilizzare
     */
    Controller(Counter c, Filter f, Visualizer v) {
        counter = c;
        filter = f;
        visualizer = v;

        c.addObserver(this);
        f.addObserver(this);
    }

    /**
     * Lancia l'applicazione
     */
    public void run() {
        counter.start();
    }


    /**
     * Reagisce agli aggiornamenti provenienti dai modelli
     * @param o
     * @param arg
     */
    @Override
    public void update(Observable o, Object arg) {
        if(o instanceof Counter) {
            filter.filter(counter.getVal());
            return;
        }

        if(o instanceof Filter) {
            visualizer.visualize(filter.getList());
        }
    }
}

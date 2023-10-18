package esercizi.observerobservable.es1_svolto;

import java.util.ArrayList;
import java.util.List;
import java.util.Observable;
import java.util.Observer;

/**
 * La classe Filter ha duplice comportamento:
 *  - osserva un Counter e ne filtra i valori (mantenendo solo i multipli di 5)
 *  - notifica inoltre ogni suo cambiamento.
 */
class Filter extends Observable  {
    private List<Integer> list;

    public Filter() {
        list = new ArrayList<Integer>();
    }

    public List<Integer> getList() {
        return list;
    }

    /**
     * Filtra il valore in input (criterio: valore deve essere divisibile per 5).
     * Se il valore supera il controllo viene aggiunto alla lista di interi mantenuta
     * da questa classe e la modifica viene segnalata ad eventuali observer.
     */
    public void filter(int c) {
        if(c % 5 == 0) {
            list.add(c);
            setChanged();
            notifyObservers();
        }
    }
}
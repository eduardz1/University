package esercizi.mvc;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Observable;
import java.util.Observer;

/**
 * Il Controller deve gestire le azioni sulla view. In particolare la pressione
 * del tasto che genera il cambiamento di stato nel modello. Implementa pertanto ActionListener e
 * invoca chooseProverb sul modello quando riceve la notifica dell'azione.
 */
class Controller implements ActionListener, Observer {
    private Model model;
    private View view;

    /**
     * Inizializza il controller e imposta le relazioni listener/observer necessarie al
     * buon funzionamento dell'app.
     *
     * @param model componente modello nell'applicazione
     * @param view componente vista nell'applicazione
     */
    public Controller(Model model, View view) {
        view.setListenerForNextProverbButtonPress(this);
        model.addObserver(this);
        this.model = model;
        this.view = view;
    }

    /**
     * Invocato quando il bottone nella view viene premuto. Invoca model.chooseProverb().
     * @param e evento scatenato dalla pressione del bottone nella view.
     */
    public void actionPerformed(ActionEvent e) {
        model.chooseProverb();
    }

    /**
     * Reacts to changes to the model and updates the view
     */
    @Override
    public void update(Observable o, Object arg) {
        if(o instanceof Model) {
            Model m = (Model) o;

            view.updateProverb(m.getProverb());
        }
    }
}
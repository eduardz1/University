package esercizi.mvc;

import java.util.ArrayList;
import java.util.Observable;
import java.util.Random;

/**
 * Il Model si occupa di mantenere lo stato dell'applicazione.
 *
 * Notifica i suoi osservatori quando il suo stato viene modificato.
 */
class Model extends Observable {
    private ArrayList<String> proverbs;
    private int index; // indice che rappresenta il proverbio attualmente "attivo" nella lista

    public Model() {
        proverbs = new ArrayList<>();
        proverbs.add("A bad workman always complains of his tools");
        proverbs.add("A bald head is soon shaved");
        proverbs.add("A bird in the hand is worth two in the bush");
        proverbs.add("A friend in need is a friend indeed");
        proverbs.add("A good dog deserves a good bone");
        proverbs.add("Better to have loved and lost, than never have loved at all");
        proverbs.add("Eaten bread is soon forgotten");
        proverbs.add("Hope is the bread of the unhappy");
        proverbs.add("It takes two to make a quarrel");
        proverbs.add("One enemy is too many, and a hundred friends are too few");
        index = 0;
    }

    /**
     * @return il proverbio corrente
     */
    public String getProverb() {
        return proverbs.get(index);
    }

    /**
     * Imposta un nuovo proverbio corrente.
     */
    public void chooseProverb() {
        Random r = new Random();
        index = r.nextInt(0, proverbs.size());

        setChanged();
        notifyObservers();
    }
}
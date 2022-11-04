package esercizi.mvc;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;


/**
 * La classe View si occupa di gestire la vista dell'applicazione.
 */
class View extends JFrame {
    private JButton button;
    private JLabel label;

    /**
     * Il costruttore della View genera e rende visibile
     * la finestra, contenente un bottone e una label
     */
    public View(String name) {
        super(name);
        setLayout(new FlowLayout(FlowLayout.LEFT, 20, 40));

        button = new JButton("Prossimo proverbio");
        label = new JLabel("Less is more");
        add(button);
        add(label);

        setSize(500, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setVisible(true);
    }

    /**
     * aggiunge un nuovo listener per l'azione di pressione del tasto
     * per ottenere un nuovo proverbio.
     */
    public void setListenerForNextProverbButtonPress(ActionListener c) {
        button.addActionListener(c);
    }

    /**
     * Imposta il testo della label alla stringa ricevuta in input
     * @param newProverb nuovo testo per la label
     */
    public void updateProverb(String newProverb) {
        label.setText(newProverb);
    }
}
package model;

import javafx.beans.property.SimpleStringProperty;

import java.util.Random;

/**
 *
 * @author liliana
 */
public class DataModel {
    private Esercizio[] esercizi;
    private int scelta = 0;
    private Random r = new Random();
    private SimpleStringProperty testoEsercizioProperty = null;
    private SimpleStringProperty rispostaProperty = null;
    private SimpleStringProperty verificaRispostaProperty = null;


    public DataModel() {
        esercizi = new Esercizio[3];
        esercizi[0] = new Esercizio("es1", "Calcola la radice quadrata di 9", "3");
        esercizi[1] = new Esercizio("es2", "Calcola la radice quadrata di 16", "4");
        esercizi[2] = new Esercizio("es3", "Calcola la radice quadrata di 25", "5");

        testoEsercizioProperty = new SimpleStringProperty();
        rispostaProperty = new SimpleStringProperty();
        verificaRispostaProperty = new SimpleStringProperty();
    }

    public SimpleStringProperty getTestoEsercizioProperty() {
        return testoEsercizioProperty;
    }

    public SimpleStringProperty getRispostaProperty() {
        return rispostaProperty;
    }

    public SimpleStringProperty getVerificaRispostaProperty() {
        return verificaRispostaProperty;
    }

    public void setEsercizio() {
        scelta = r.nextInt(esercizi.length);
        testoEsercizioProperty.set(esercizi[scelta].testo);
    }

    public void checkRisposta() {
        if (rispostaProperty.get().equals(esercizi[scelta].risultato))
            verificaRispostaProperty.set("Risposta corretta!");
        else verificaRispostaProperty.set("Errore!");
    }

    private static class Esercizio {
        private String titolo;
        private String testo;
        private String risultato;

        Esercizio(String tit, String t, String r) {
            titolo = tit;
            testo = t;
            risultato = r;
        }
    }
}


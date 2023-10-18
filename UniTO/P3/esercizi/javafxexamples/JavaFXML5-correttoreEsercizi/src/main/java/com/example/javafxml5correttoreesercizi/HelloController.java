package com.example.javafxml5correttoreesercizi;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import model.*;

public class HelloController {
    @FXML
    private Label valutazione;

    @FXML
    private TextField testoEsercizio;

    @FXML
    private TextField risposta;

    private DataModel model = new DataModel();; // NB: senza java annotation!

    @FXML
    private void handleAltroEsercizioAction(ActionEvent event) {
        model.setEsercizio();
    }

    @FXML
    private void handleVerificaRisultato(ActionEvent event) {
        System.out.println("in handleVerificaRisultato");
        model.checkRisposta();
    }

    public void initModel() {
        testoEsercizio.textProperty().bind(model.getTestoEsercizioProperty());
        model.getRispostaProperty().bind(risposta.textProperty());
        valutazione.textProperty().bind(model.getVerificaRispostaProperty());
        model.setEsercizio();
    }
}
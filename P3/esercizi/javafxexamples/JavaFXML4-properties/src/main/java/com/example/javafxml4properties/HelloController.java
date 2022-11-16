package com.example.javafxml4properties;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import model.Bill;

import java.util.Random;

public class HelloController {
    private Bill electricBill = new Bill();
    private final Random r = new Random();
    @FXML
    private TextField billValue;
    @FXML
    private Label ris;

    @FXML
    protected void onHelloButtonClick() {
        ris.setText("Value of bill:"); // brutto...
        int i = r.nextInt(10000);
        electricBill.setAmountDue(new StringBuilder().append(i).toString());
    }

    public void bindProperties() {
        billValue.textProperty().bind(electricBill.amountDueProperty());
        // questo listener rimane solo per poter scrivere su standard output il valore di amountDue
        // non serve per la visualizzazione sulla finestra dell'applicazione
        electricBill.amountDueProperty().addListener(new ChangeListener<String>() {
            public void changed(ObservableValue<? extends String> observableValue, String oldVal, String newVal) {
                System.out.println("Electric bill has changed to " + newVal + "!");
            }
        });
    }
}
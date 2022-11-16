package com.example.javafxml2bindings;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class HelloController {

    @FXML
    private Label welcomeText;

    @FXML
    private TextField inserimento;

    @FXML
    private TextField visualizza;

    @FXML
    protected void onHelloButtonClick() {
        welcomeText.setText("Welcome to JavaFX Application!");
        bindProperties();
    }

    public void bindProperties() {
        visualizza.textProperty().bind(inserimento.textProperty());
    }
}
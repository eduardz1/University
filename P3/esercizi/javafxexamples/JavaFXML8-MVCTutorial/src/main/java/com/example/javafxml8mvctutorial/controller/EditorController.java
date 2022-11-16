package com.example.javafxml8mvctutorial.controller;

import com.example.javafxml8mvctutorial.model.DataModel;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author liliana
 */
public class EditorController {

    @FXML
    private TextField firstNameField ;
    @FXML
    private TextField lastNameField ;
    @FXML
    private TextField emailField ;

    private DataModel model ;

    public void initModel(DataModel model) {
        if (this.model != null) {
            throw new IllegalStateException("Model can only be initialized once");
        }
        this.model = model ;
        model.loadData(null);//  aggiunto per far caricare i dati delle person
        model.currentPersonProperty().addListener((obs, oldPerson, newPerson) -> {
            if (oldPerson != null) {
                firstNameField.textProperty().unbindBidirectional(oldPerson.firstNameProperty());
                lastNameField.textProperty().unbindBidirectional(oldPerson.lastNameProperty());
                emailField.textProperty().unbindBidirectional(oldPerson.emailProperty());
            }
            if (newPerson == null) {
                firstNameField.setText("");
                lastNameField.setText("");
                emailField.setText("");
            } else {
                firstNameField.textProperty().bindBidirectional(newPerson.firstNameProperty());
                lastNameField.textProperty().bindBidirectional(newPerson.lastNameProperty());
                emailField.textProperty().bindBidirectional(newPerson.emailProperty());
            }
        });
    }
}


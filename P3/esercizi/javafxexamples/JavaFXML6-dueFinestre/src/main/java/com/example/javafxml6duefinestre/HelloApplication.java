package com.example.javafxml6duefinestre;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import model.Bill;

import java.io.IOException;

public class HelloApplication extends Application {
    @Override
    public void start(Stage stage) throws IOException {
        Bill electricBill = new Bill(); // creo il model

        FXMLLoader fxmlLoader = new FXMLLoader(HelloApplication.class.getResource("sample.fxml"));
        Scene scene = new Scene(fxmlLoader.load(), 520, 440);
        stage.setTitle("Hello World!");
        stage.setScene(scene);
        Controller contr = fxmlLoader.getController();
        contr.initialize(electricBill);
        stage.show();

        FXMLLoader fxmlLoader2 = new FXMLLoader(HelloApplication.class.getResource("sample2.fxml"));
        Scene scene2 = new Scene(fxmlLoader2.load(), 320, 240);
        Stage stage2 = new Stage();
        stage2.setTitle("Hello World 2!");
        stage2.setScene(scene2);
        System.out.println("due");
        Controller2 contr2 = fxmlLoader2.getController();
        System.out.println("tre");
        contr2.initialize(electricBill);
        stage2.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
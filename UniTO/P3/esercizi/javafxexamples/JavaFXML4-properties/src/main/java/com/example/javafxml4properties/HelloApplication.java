package com.example.javafxml4properties;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class HelloApplication extends Application {
    @Override
    public void start(Stage stage) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(HelloApplication.class.getResource("hello-view.fxml"));
        Scene scene = new Scene(fxmlLoader.load(), 320, 240);
        stage.setTitle("Binding with properties");
        stage.setScene(scene);
        HelloController contr = fxmlLoader.getController();
        contr.bindProperties();
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
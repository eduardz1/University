module com.example.javafxml8mvctutorial {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.javafxml8mvctutorial to javafx.fxml;
    exports com.example.javafxml8mvctutorial;
    exports com.example.javafxml8mvctutorial.controller;
    opens com.example.javafxml8mvctutorial.controller to javafx.fxml;
    exports com.example.javafxml8mvctutorial.model;
    opens com.example.javafxml8mvctutorial.model to javafx.fxml;
}
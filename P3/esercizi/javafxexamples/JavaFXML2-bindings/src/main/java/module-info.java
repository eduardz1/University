module com.example.javafxml2bindings {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.javafxml2bindings to javafx.fxml;
    exports com.example.javafxml2bindings;
}
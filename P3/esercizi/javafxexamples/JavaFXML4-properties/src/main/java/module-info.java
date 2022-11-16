module com.example.javafxml4properties {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.javafxml4properties to javafx.fxml;
    exports com.example.javafxml4properties;
}
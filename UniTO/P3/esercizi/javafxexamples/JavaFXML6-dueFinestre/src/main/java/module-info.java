module com.example.javafxml6duefinestre {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.javafxml6duefinestre to javafx.fxml;
    exports com.example.javafxml6duefinestre;
}
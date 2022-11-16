module com.example.javafxml5correttoreesercizi {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.javafxml5correttoreesercizi to javafx.fxml;
    exports com.example.javafxml5correttoreesercizi;
}
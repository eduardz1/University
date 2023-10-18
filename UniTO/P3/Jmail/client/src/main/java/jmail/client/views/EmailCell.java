package jmail.client.views;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.layout.Region;
import jmail.client.Main;
import jmail.lib.models.Email;

public class EmailCell extends ListCell<Email> {

    // Views
    @FXML private Label fromLabel;

    @FXML private Label subjectLabel;

    @FXML private Label dateLabel;

    @FXML private Label bodyLabel;

    @FXML private Region readMarker;

    public EmailCell() {
        try {
            FXMLLoader loader = new FXMLLoader(Main.class.getResource("email_cell.fxml"));
            loader.setController(this);
            loader.setRoot(this);
            loader.load();

            initListeners();
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

    @Override
    protected void updateItem(Email item, boolean empty) {
        super.updateItem(item, empty);
        if (empty || item == null) {
            setText(null);
            setContentDisplay(ContentDisplay.TEXT_ONLY);
            setDisable(true);
            return;
        }
        setDisable(false);
        setContentDisplay(ContentDisplay.GRAPHIC_ONLY);
    }

    public void initListeners() {
        itemProperty().addListener((obs, oldValue, newValue) -> {

            // Empty cell
            if (newValue == null) {
                return;
            }

            fromLabel.setText(newValue.getSender());
            subjectLabel.setText(newValue.getSubject());

            Calendar today = Calendar.getInstance();

            Calendar date = Calendar.getInstance();
            date.setTime(newValue.getDate());
            DateFormat df;
            if (date.get(Calendar.YEAR) == today.get(Calendar.YEAR)
                    && date.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR)) {
                df = new SimpleDateFormat("HH:mm");
            } else {
                df = new SimpleDateFormat("dd MMM yy, HH:mm");
            }
            dateLabel.setText(df.format(newValue.getDate()));

            bodyLabel.setText(newValue.getBody());
            readMarker.setStyle("-fx-background-color:" + (newValue.getRead() ? "#00000000;" : "#009688FF;"));
            setContentDisplay(ContentDisplay.GRAPHIC_ONLY);
        });
    }
}

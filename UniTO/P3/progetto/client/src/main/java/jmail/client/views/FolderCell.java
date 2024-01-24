package jmail.client.views;

import java.io.IOException;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Insets;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.paint.Paint;
import javafx.scene.text.Font;
import jmail.client.Main;
import jmail.client.models.model.DataModel;
import jmail.lib.constants.Folders;
import org.kordamp.ikonli.javafx.FontIcon;

public class FolderCell extends ListCell<String> {

    // Views
    @FXML private Label iconLabel;

    @FXML private Label folderLabel;

    @FXML private Label counterLabel;

    public FolderCell() {
        try {
            FXMLLoader loader = new FXMLLoader(Main.class.getResource("folder_cell.fxml"));
            loader.setController(this);
            loader.setRoot(this);
            loader.load();

            initListeners();
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

    @Override
    protected void updateItem(String item, boolean empty) {
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

    private void initListeners() {

        itemProperty().addListener((obs, oldValue, newValue) -> {

            // Empty cell
            if (newValue == null || newValue.isEmpty()) {
                return;
            }

            // Prevent unnecessary updates
            if (oldValue != null && oldValue.equalsIgnoreCase(newValue)) return;

            // Init new mail listener only for INBOX
            if (newValue.equalsIgnoreCase(Folders.INBOX)) {
                counterLabel.setVisible(DataModel.getInstance().getNewEmailCount() > 0);
                initNewMailListener();
            }

            // Icon
            var fontIcon = new FontIcon(
                    switch (newValue.toLowerCase()) {
                        case Folders.INBOX -> "mdi2i-inbox";
                        case Folders.SENT -> "mdi2e-email-send";
                        case Folders.TRASH -> "mdi2t-trash-can";
                        default -> "mdi2a-folder";
                    });
            fontIcon.setIconColor(Paint.valueOf("#afb1b3"));
            iconLabel.setGraphic(fontIcon);
            iconLabel.setFont(Font.font(18));
            iconLabel.setPadding(new Insets(2, 0, 0, 0));

            // Folder name
            folderLabel.setText(newValue);

            // Counter
            counterLabel.setText(DataModel.getInstance().getNewEmailCount() + "");
        });
    }

    private void initNewMailListener() {
        DataModel.getInstance().getNewEmailCountProperty().addListener((observable, oldValue, newValue) -> {
            counterLabel.setText(newValue + "");
            counterLabel.setVisible(newValue.intValue() > 0);
        });
    }
}

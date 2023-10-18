package jmail.client.dialogs;

import java.io.IOException;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.ButtonBar;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Dialog;
import javafx.scene.control.DialogPane;
import javafx.scene.control.Label;
import javafx.scene.paint.Paint;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.stage.Window;
import jmail.client.Main;
import jmail.lib.constants.ColorPalette;
import org.kordamp.ikonli.javafx.FontIcon;

public class CustomDialog extends Dialog<String> {

    private ButtonType noBtn;
    private ButtonType okBtn;

    @FXML private Label messageLabel;

    @FXML private Label icon;

    @FXML private Label titleLabel;

    public CustomDialog(Stage owner, String mode, String title, String message) {
        try {
            FXMLLoader loader = new FXMLLoader(Main.getResource("dialog.fxml"));
            loader.setController(this);

            DialogPane dialogPane = loader.load();
            initOwner(owner);
            initModality(Modality.WINDOW_MODAL);
            initStyle(StageStyle.TRANSPARENT);

            FontIcon fontIcon = null;
            String color = "";
            switch (mode) {
                case "error" -> {
                    fontIcon = new FontIcon("mdi2c-close-circle-outline");
                    fontIcon.setIconColor(Paint.valueOf(ColorPalette.RED.getHexValue()));
                    color = "#FF5555";
                    okBtn = new ButtonType("OK", ButtonBar.ButtonData.OK_DONE);
                    dialogPane.getButtonTypes().add(okBtn);
                }
                case "info" -> {
                    fontIcon = new FontIcon("mdi2a-alert-circle-outline");
                    fontIcon.setIconColor(Paint.valueOf(ColorPalette.BLUE.getHexValue()));
                    color = "#1273DE";
                    okBtn = new ButtonType("OK", ButtonBar.ButtonData.OK_DONE);
                    dialogPane.getButtonTypes().add(okBtn);
                }
                case "confirm" -> {
                    fontIcon = new FontIcon("mdi2c-check-circle-outline");
                    fontIcon.setIconColor(Paint.valueOf(ColorPalette.GREEN.getHexValue()));
                    color = "#39864F";
                    noBtn = new ButtonType("Cancel");
                    dialogPane.getButtonTypes().add(noBtn);
                    okBtn = new ButtonType("Confirm");
                    dialogPane.getButtonTypes().add(okBtn);
                }
                case "warning" -> {
                    fontIcon = new FontIcon("mdi2a-alert-circle-outline");
                    fontIcon.setIconColor(Paint.valueOf(ColorPalette.YELLOW.getHexValue()));
                    color = "#FFB86C";
                    noBtn = new ButtonType("Cancel");
                    dialogPane.getButtonTypes().add(noBtn);
                    okBtn = new ButtonType("Confirm");
                    dialogPane.getButtonTypes().add(okBtn);
                }
            }
            icon.setGraphic(fontIcon);
            titleLabel.setText(title);
            messageLabel.setText(message);

            titleLabel.setStyle(titleLabel.getStyle() + "; -fx-text-fill: " + color + ";");

            setDialogPane(dialogPane);

            setResultConverter(buttonType -> {
                if (buttonType.getText().equals("Confirm")
                        || buttonType.getText().equals("OK")) {
                    return "yes";
                }
                return "no";
            });

            setOnShowing(dialogEvent -> Platform.runLater(() -> {
                messageLabel.requestFocus();
            }));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @FXML private void initialize() {
        Window window = getDialogPane().getScene().getWindow();
        window.setOnCloseRequest(event -> window.hide());
    }
}

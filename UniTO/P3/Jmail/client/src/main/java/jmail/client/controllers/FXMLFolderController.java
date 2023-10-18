package jmail.client.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.UUID;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.layout.AnchorPane;
import javafx.scene.paint.Paint;
import jmail.client.Main;
import jmail.client.factory.FolderCellFactory;
import jmail.client.models.model.DataModel;
import jmail.lib.constants.ColorPalette;
import jmail.lib.models.Email;
import org.kordamp.ikonli.javafx.FontIcon;

public class FXMLFolderController extends AnchorPane {

    @FXML public AnchorPane root;

    /*
     * Folder views
     */
    @FXML private Button newMailButton;

    @FXML private ListView<String> listFolder;

    @FXML private Label currentUserName;

    @FXML private Label currentUserEmail;

    @FXML private Label connectionLabel;

    public FXMLFolderController() {
        // Load
        FXMLLoader loader = new FXMLLoader(Main.getResource("folder.fxml"));

        loader.setController(this);
        try {
            loader.load();

            initView();
            initListeners();

        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

    private void initView() {

        // Set avatar icon
        var avatar = DataModel.getInstance().getCurrentUserProperty().getValue().getAvatar();
        Node graphic;
        if (avatar == null) {
            var fontIcon = new FontIcon("mdi2a-account");
            fontIcon.setIconColor(Paint.valueOf(ColorPalette.TEXT.getHexValue()));
            graphic = fontIcon;
        } else {
            graphic = new ImageView(avatar);
        }
        currentUserName.setGraphic(graphic);

        // Init folder list
        listFolder.getItems().addAll("Inbox", "Sent", "Trash");

        // Set graphic for each item
        listFolder.setCellFactory(new FolderCellFactory());

        // Update connection status
        var fontIcon = new FontIcon("mdi2w-web-box");
        fontIcon.setIconColor(Paint.valueOf(ColorPalette.GREEN.getHexValue()));
        connectionLabel.setGraphic(fontIcon);
        connectionLabel.setText("Connected");
    }

    private void initListeners() {

        // Update username
        currentUserName
                .textProperty()
                .bind(DataModel.getInstance().getCurrentUserProperty().map(u -> u == null ? "" : u.getName()));

        currentUserEmail
                .textProperty()
                .bind(DataModel.getInstance().getCurrentUserProperty().map(u -> u == null ? "" : u.getEmail()));

        // Update currentFolder model based on selected item
        listFolder.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> {
            DataModel.getInstance().setCurrentFolder(newValue.toLowerCase());
        });

        // Update connection status
        DataModel.getInstance()
                .isServerStatusConnected()
                .addListener((observable, oldValue, newValue) -> Platform.runLater(() -> {
                    var newFontIcon = new FontIcon("mdi2w-web-box");
                    newFontIcon.setIconColor(
                            newValue
                                    ? Paint.valueOf(ColorPalette.GREEN.getHexValue())
                                    : Paint.valueOf(ColorPalette.RED.getHexValue()));
                    connectionLabel.setGraphic(newFontIcon);
                    connectionLabel.setText(newValue ? "Connected" : "Disconnected");
                }));
    }

    @FXML public void buttonNewMail(ActionEvent e) {

        // TODO: Remove this
        // DataModel.getInstance().setEditingMode(true);
        // var n = new Email(
        //         UUID.randomUUID().toString(),
        //         "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
        //         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the
        // industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and
        // scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into
        // electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of
        // Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like
        // Aldus PageMaker including versions of Lorem Ipsum.",
        //         DataModel.getInstance().getCurrentUser().getEmail(),
        //         Arrays.asList("emmedeveloper@gmail.com"),
        //         Calendar.getInstance().getTime(),
        //         false);
        // DataModel.getInstance().setCurrentEmail(n);

        DataModel.getInstance().setEditingMode(true);
        var newEmail = new Email(
                UUID.randomUUID().toString(),
                "",
                "",
                DataModel.getInstance().getCurrentUser().getEmail(),
                new ArrayList<>(),
                Calendar.getInstance().getTime(),
                false);

        DataModel.getInstance().setCurrentEmail(newEmail);
        // LOGGER.info("NewMailButton: {}", newEmail);
    }
}

package jmail.client.controllers;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import javafx.animation.PauseTransition;
import javafx.application.Platform;
import javafx.collections.ListChangeListener;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;
import javafx.scene.layout.AnchorPane;
import javafx.util.Duration;
import jmail.client.Main;
import jmail.client.factory.EmailCellFactory;
import jmail.client.models.model.DataModel;
import jmail.lib.autocompletion.textfield.AutoCompletionBinding;
import jmail.lib.autocompletion.textfield.TextFields;
import jmail.lib.models.Email;

public class FXMLListEmailController extends AnchorPane {

    @FXML public AnchorPane root;

    private FXMLController mainController;

    /*
     * Email views
     */
    @FXML private ListView<Email> listEmails;

    @FXML private Button searchButton;

    @FXML private Label currentFolder;

    @FXML private TextField searchField;

    /*
     * Search suggestions
     */
    private final Set<String> suggestions = new HashSet<>();
    private transient AutoCompletionBinding<String> autoCompletionBinding;

    public FXMLListEmailController() {
        // Load
        FXMLLoader loader = new FXMLLoader(Main.class.getResource("list_email.fxml"));
        loader.setController(this);
        try {
            loader.load();
            initViews();
            initListeners();
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

    public void setMainController(FXMLController mainController) {
        this.mainController = mainController;
    }

    public void initListeners() {

        autoCompletionBinding = TextFields.bindAutoCompletion(searchField, suggestions);

        // Effettua la ricerca al click del pulsante
        searchField.setOnKeyPressed(event -> {
            if (event.getCode() == javafx.scene.input.KeyCode.ENTER) {
                buttonSearch(null);
                learnWord(searchField.getText().trim());
            }
        });

        // Effettua la ricerca alla modifica del filtro, dopo che l'utente ha smesso di digitare
        PauseTransition pause = new PauseTransition(Duration.seconds(1));
        searchField.textProperty().addListener((observable, oldValue, newValue) -> {
            pause.setOnFinished(event -> {
                if (newValue == null || newValue.isEmpty()) {
                    DataModel.getInstance().setSearchFilter(null);
                } else {
                    DataModel.getInstance().setSearchFilter(newValue);
                }
            });
            pause.playFromStart();
        });

        // Aggiorna il filtro di ricerca quando viene modificato dall'esterno
        DataModel.getInstance().getSearchFilterProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue == null || newValue.isEmpty()) {
                searchField.clear();
            } else {
                if (!newValue.equalsIgnoreCase(searchField.getText())) {
                    searchField.setText(newValue);
                }
            }
        });

        // Aggiorna la lista degli email quando viene modificata dall'esterno
        DataModel.getInstance().getCurrentFilteredEmails().addListener((ListChangeListener<Email>)
                c -> Platform.runLater(() -> {
                    listEmails.getItems().clear();
                    var list = c.getList();
                    listEmails.getItems().addAll(list);

                    list.stream().map(Email::getSubject).forEach(this::learnWord);
                    DataModel.getInstance()
                            .getCurrentEmail()
                            .ifPresent(email -> listEmails.getSelectionModel().select(email));
                }));

        // Quando viene selezionato un email, viene impostato come email corrente
        // e viene impostato il flag di lettura
        listEmails.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue == null || newValue.equals(oldValue)) {
                return;
            }
            DataModel.getInstance().setCurrentEmail(newValue);
            DataModel.getInstance().setEditingMode(false);

            if (!newValue.getRead()) {
                mainController.readEmail(newValue);
            }
        });

        // Quando viene modificato l'email corrente, viene selezionato l'email corrispondente nella lista
        DataModel.getInstance().getCurrentEmailProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue == null
                    || listEmails.getSelectionModel().getSelectedItem() == null
                    || !listEmails.getSelectionModel().getSelectedItem().equals(newValue)) {
                listEmails.getSelectionModel().clearSelection();
            }
        });

        // Quando viene modificato la cartella corrente, viene aggiornato il testo
        DataModel.getInstance().getCurrentFolderProperty().addListener((observable, oldValue, newValue) -> {
            currentFolder.textProperty().set(newValue.toUpperCase());
        });
    }

    public void initViews() {

        // Set listEmails view graphic
        listEmails.setCellFactory(new EmailCellFactory(listEmails));
        listEmails.setStyle("-fx-background-insets: 1 ;");
    }

    @FXML public void buttonSearch(ActionEvent e) {
        var text = searchField.textProperty().getValueSafe();
        DataModel.getInstance().setSearchFilter(text);
    }

    private void learnWord(String trim) {
        suggestions.add(trim);
        if (autoCompletionBinding != null) {
            autoCompletionBinding.dispose();
        }

        autoCompletionBinding = TextFields.bindAutoCompletion(searchField, suggestions);

        // Set autocompletation popup width
        autoCompletionBinding.getAutoCompletionPopup().prefWidthProperty().bind(searchField.widthProperty());
    }
}

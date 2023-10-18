package jmail.client.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import jmail.client.Main;
import jmail.client.dialogs.CustomDialog;
import jmail.client.models.client.MailClient;
import jmail.client.models.model.DataModel;
import jmail.client.models.responses.ListEmailResponse;
import jmail.lib.constants.Folders;
import jmail.lib.constants.ServerResponseStatuses;
import jmail.lib.handlers.LockHandler;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.Email;
import jmail.lib.models.ServerResponse;
import jmail.lib.models.commands.CommandDeleteEmail;
import jmail.lib.models.commands.CommandDeleteEmail.CommandDeleteEmailParameter;
import jmail.lib.models.commands.CommandListEmail;
import jmail.lib.models.commands.CommandReadEmail;
import jmail.lib.models.commands.CommandSendEmail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FXMLController {
    private static final Logger LOGGER = LoggerFactory.getLogger(FXMLController.class.getName());
    private static final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private Long lastUnixTimeEmailCheck = 0L;

    @FXML private FXMLFolderController folderController;

    @FXML private FXMLListEmailController listEmailController;

    @FXML private FXMLEmailController emailController;

    @FXML private SplitPane root;

    Map<String, Path> paths;

    public void initialize() {

        // Add reference to main controller into sub controllers
        listEmailController.setMainController(this);
        emailController.setMainController(this);

        // Load sub controllers in view
        root.getItems().clear();
        root.getItems().add(folderController.root);
        root.getItems().add(listEmailController.root);
        root.getItems().add(emailController.root);

        foldersInit();
        synchronizeEmails();
    }

    private void foldersInit() {

        // Mappa di default con i path delle cartelle
        paths = new HashMap<>(Map.of(
                Folders.INBOX,
                SystemIOHelper.getUserInbox(
                        DataModel.getInstance().getCurrentUser().getEmail()),
                Folders.SENT,
                SystemIOHelper.getUserSent(
                        DataModel.getInstance().getCurrentUser().getEmail()),
                Folders.TRASH,
                SystemIOHelper.getUserTrash(
                        DataModel.getInstance().getCurrentUser().getEmail())));

        // Aggiorniamo la mappa ogni volta che cambia l'utente
        DataModel.getInstance().getCurrentUserProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue == null) {
                throw new IllegalStateException("Current user cannot be null");
            }
            paths.put(Folders.INBOX, SystemIOHelper.getUserInbox(newValue.getEmail()));
            paths.put(Folders.SENT, SystemIOHelper.getUserSent(newValue.getEmail()));
            paths.put(Folders.TRASH, SystemIOHelper.getUserTrash(newValue.getEmail()));
        });
    }

    public void listEmails(String folder) {
        // Prevents concurrent write of new email to the list
        var lock = LockHandler.getInstance().getWriteLock(folder);
        lock.lock();

        var params = new CommandListEmail.CommandListEmailParameter(lastUnixTimeEmailCheck, folder);
        var command = new CommandListEmail(params);

        MailClient.getInstance()
                .sendCommand(
                        command,
                        response -> {
                            if (response.getStatus().equals(ServerResponseStatuses.OK)) {
                                var resp = (ListEmailResponse) response;

                                if (resp.getEmails().isEmpty()) return;

                                // Already sorted by date in the server
                                var emails = resp.getEmails().toArray(Email[]::new);
                                addEmail(folder, emails);

                                // Aggiorniamo lastUnixTimeEmailCheck con la data più recente tra le email
                                // ricevute
                                // Non utilizziamo il tempo corrente per evitare problemi di sincronizzazione:
                                // se viene inviata una email tra il momento in cui viene richiesta la lista di
                                // email
                                // e il momento in cui viene ricevuta la risposta, questa email non verrà mai
                                // ricevuta
                                // in quanto avrà la data nel momento in cui viene spedita
                                lastUnixTimeEmailCheck = Arrays.stream(emails)
                                        .findFirst()
                                        .map(Email::getDate)
                                        .map(Date::toInstant)
                                        .map(Instant::getEpochSecond)
                                        .orElse(lastUnixTimeEmailCheck);

                                System.out.println(lastUnixTimeEmailCheck);
                                LOGGER.info("Email list: {}", response);
                            } else {
                                LOGGER.error("Error getting email: {}", response);
                            }
                        },
                        ListEmailResponse.class);

        lock.unlock();
        LockHandler.getInstance().removeLock(folder);
    }

    public void sendEmail(Email email) {
        var params = new CommandSendEmail.CommandSendEmailParameter(email);
        var command = new CommandSendEmail(params);

        MailClient.getInstance()
                .sendCommand(
                        command,
                        response -> {
                            if (response.getStatus().equals(ServerResponseStatuses.OK)) {
                                DataModel.getInstance().setCurrentEmail(null);
                                DataModel.getInstance().setEditingMode(false);
                                addEmail(Folders.SENT, email);
                                // When send an email, not add to inbox, but update it
                                listEmails(Folders.INBOX);
                                LOGGER.info("Email sent: {}", response);
                            } else {
                                showError(
                                        "Send failed!",
                                        "Something went wrong. \nPlease retry later\n\nInfo: " + response.getMessage());
                                LOGGER.error("Error sending email: {}", response);
                            }
                        },
                        ServerResponse.class);
    }

    public void deleteEmail(String emailID, String folder, Boolean hardDelete) {
        var params = new CommandDeleteEmailParameter(emailID, folder, hardDelete);
        var command = new CommandDeleteEmail(params);

        MailClient.getInstance()
                .sendCommand(
                        command,
                        response -> {
                            if (response.getStatus().equals(ServerResponseStatuses.OK)) {
                                if (!hardDelete) {
                                    addEmail(
                                            Folders.TRASH,
                                            DataModel.getInstance()
                                                    .getCurrentEmail()
                                                    .orElseThrow());
                                }
                                DataModel.getInstance().removeCurrentEmail();
                                try {
                                    SystemIOHelper.deleteFile(paths.get(folder).resolve(emailID));
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                                LOGGER.info("DeleteMailResponse: {}", response);
                            } else {
                                showError(
                                        "Delete failed!",
                                        "Something went wrong. \nPlease retry later\n\nInfo: " + response.getMessage());
                                LOGGER.error("Error deleting email: {}", response);
                            }
                        },
                        ServerResponse.class);
    }

    public void synchronizeEmails() {
        // Gestione della cache
        for (String folder : paths.keySet()) {
            var mails = new ArrayList<Email>();
            var files = (new File(paths.get(folder).toUri())).listFiles();
            if (files == null) {
                continue;
            }

            for (File file : files) {
                try {
                    var json = SystemIOHelper.readJSONFile(Path.of(file.getPath()));
                    var mail = JsonHelper.fromJson(json, Email.class);
                    lastUnixTimeEmailCheck =
                            Math.max(mail.getDate().toInstant().getEpochSecond(), lastUnixTimeEmailCheck);
                    mails.add(mail);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            mails.sort(Comparator.comparing(Email::getDate).reversed());
            DataModel.getInstance().addEmail(folder, mails.toArray(Email[]::new));
        }

        listEmails(Folders.INBOX);
        listEmails(Folders.SENT);
        listEmails(Folders.TRASH);
        // Make sure that the lastUnixTimeEmailCheck is updated, so scheduler start
        // after first check
        scheduler.scheduleAtFixedRate(() -> listEmails(Folders.INBOX), 5, 3, TimeUnit.SECONDS);
    }

    public void addEmail(String folder, Email... emails) {

        for (Email email : emails) {
            try {
                SystemIOHelper.writeJSONFile(paths.get(folder), email.fileID(), JsonHelper.toJson(email));
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        DataModel.getInstance().addEmail(folder, emails);
    }

    public void readEmail(Email email) {
        if (email == null
                || email.getRead()
                || !DataModel.getInstance().getCurrentFolder().equals(Folders.INBOX)) {
            return;
        }

        var params = new CommandReadEmail.CommandReadEmailParameter(email.fileID(), true);
        var cmd = new CommandReadEmail(params);

        MailClient.getInstance()
                .sendCommand(
                        cmd,
                        response -> {
                            if (response.getStatus().equals(ServerResponseStatuses.OK)) {
                                email.setRead(true);
                                DataModel.getInstance().syncFilteredEmails();
                                LOGGER.info("Email {} marked as read", email.fileID());
                                try {
                                    SystemIOHelper.writeJSONFile(
                                            paths.get(Folders.INBOX), email.fileID(), JsonHelper.toJson(email));
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                            } else {
                                LOGGER.error("Error marking email {} as read", email.fileID());
                            }
                        },
                        ServerResponse.class);
    }

    private void showError(String title, String content) {
        Platform.runLater(() -> new CustomDialog(Main.primaryStage, "error", title, content).showAndWait());
    }
}

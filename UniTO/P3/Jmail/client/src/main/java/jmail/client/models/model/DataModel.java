package jmail.client.models.model;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableBooleanValue;
import javafx.beans.value.ObservableLongValue;
import javafx.beans.value.ObservableObjectValue;
import javafx.beans.value.ObservableStringValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import jmail.lib.constants.*;
import jmail.lib.models.Email;
import jmail.lib.models.User;
import me.xdrop.fuzzywuzzy.FuzzySearch;
import me.xdrop.fuzzywuzzy.model.BoundExtractedResult;

public class DataModel {

    private static final DataModel instance = new DataModel();
    private final ObjectProperty<User> currentUser;
    private final SimpleStringProperty currentFolder;
    private final ObservableList<Email> inbox;
    private final ObservableList<Email> sent;
    private final ObservableList<Email> trash;

    private final ObservableList<Email> currentFilteredEmails; // Used for filtering emails to show bby search
    private final ObjectProperty<Email> currentEmail;

    private final SimpleBooleanProperty serverStatusConnected;
    private final SimpleBooleanProperty editingMode;
    private final SimpleLongProperty newEmailCount;

    private final SimpleStringProperty searchFilter;

    private DataModel() {
        currentUser = new SimpleObjectProperty<>();
        currentFolder = new SimpleStringProperty();

        inbox = FXCollections.observableArrayList();
        sent = FXCollections.observableArrayList();
        trash = FXCollections.observableArrayList();
        currentFilteredEmails = FXCollections.observableArrayList();

        currentEmail = new SimpleObjectProperty<>();
        serverStatusConnected = new SimpleBooleanProperty();
        editingMode = new SimpleBooleanProperty();
        newEmailCount = new SimpleLongProperty();

        searchFilter = new SimpleStringProperty();
    }

    public static DataModel getInstance() {
        return instance;
    }

    public ObservableObjectValue<User> getCurrentUserProperty() {
        return currentUser;
    }

    public User getCurrentUser() {
        return currentUser.get();
    }

    public void setCurrentUser(User user) {
        currentUser.set(user);
    }

    public ObservableStringValue getCurrentFolderProperty() {
        return currentFolder;
    }

    public String getCurrentFolder() {
        return currentFolder.get();
    }

    public void setCurrentFolder(String folder) {
        currentFolder.set(folder);
        syncFilteredEmails();
    }

    public ObservableList<Email> getInbox() {
        return inbox;
    }

    public void setInbox(List<Email> emails) {
        inbox.setAll(emails);
    }

    public ObservableList<Email> getSent() {
        return sent;
    }

    public void setSent(List<Email> emails) {
        sent.setAll(emails);
    }

    public ObservableList<Email> getTrash() {
        return trash;
    }

    public void setTrash(List<Email> emails) {
        trash.setAll(emails);
    }

    public ObservableList<Email> getCurrentFilteredEmails() {
        return currentFilteredEmails;
    }

    public ObservableObjectValue<Email> getCurrentEmailProperty() {
        return currentEmail;
    }

    public Optional<Email> getCurrentEmail() {
        return Optional.ofNullable(currentEmail.get());
    }

    public void setCurrentEmail(Email email) {
        currentEmail.set(email);
    }

    public ObservableBooleanValue isServerStatusConnected() {
        return serverStatusConnected;
    }

    public void setServerStatusConnected(boolean serverStatusConnected) {
        this.serverStatusConnected.set(serverStatusConnected);
    }

    public void removeCurrentEmail() {
        switch (currentFolder.get()) {
            case Folders.INBOX -> inbox.remove(currentEmail.get());
            case Folders.SENT -> sent.remove(currentEmail.get());
            case Folders.TRASH -> trash.remove(currentEmail.get());
        }
        syncFilteredEmails();
        currentEmail.set(null);
    }

    public void addEmail(String folder, Email... emails) {
        // isEmpty
        if (Arrays.stream(emails).findAny().isEmpty()) {
            return;
        }

        // Make sure the email in sent/trash folder are marked as read
        if (folder.equals(Folders.SENT) || folder.equals(Folders.TRASH)) {
            for (Email email : emails) {
                email.setRead(true);
            }
        }

        // append array to start of list
        switch (folder) {
            case Folders.INBOX -> inbox.addAll(0, Arrays.asList(emails));
            case Folders.SENT -> sent.addAll(0, Arrays.asList(emails));
            case Folders.TRASH -> trash.addAll(0, Arrays.asList(emails));
        }

        if (folder.equalsIgnoreCase(getCurrentFolder())) {
            syncFilteredEmails();
        } else syncNewEmailCount();
    }

    public void syncFilteredEmails() {
        var emails =
                switch (currentFolder.get()) {
                    case Folders.INBOX -> inbox;
                    case Folders.SENT -> sent;
                    case Folders.TRASH -> trash;
                    default -> throw new IllegalStateException("Unexpected value: " + currentFolder.get());
                };

        if (searchFilter.get() == null || searchFilter.get().isEmpty()) {
            currentFilteredEmails.setAll(emails);
        } else {
            var filter = searchFilter.get().toLowerCase();

            // Search by subject or body or sender
            // var filteredEmails = emails.stream()
            //         .filter(email -> email.getSubject().toLowerCase().contains(filter)
            //                 || email.getBody().toLowerCase().contains(filter)
            //                 || email.getSender().toLowerCase().contains(filter))
            //         .sorted(Comparator.comparing(Email::getDate).reversed())
            //         .collect(Collectors.toList());
            // TODO: Non capisco come funziona questa libreria, non ordina le cose correttamente e mette sempre il limit
            // dei risultati, mettendo al top le ricerche più coerenti
            // Ma non sono sicuro che sia cosi
            var filteredResult = FuzzySearch.extractTop(
                    filter, emails, email -> email.getSubject() + " " + email.getSender() + " " + email.getBody(), 5);
            var filteredEmails = filteredResult.stream()
                    .map(BoundExtractedResult::getReferent)
                    .collect(Collectors.toList());
            currentFilteredEmails.setAll(filteredEmails);
        }
        syncNewEmailCount();
    }

    public void syncNewEmailCount() {
        setNewEmailCount(inbox.stream().filter(email -> !email.getRead()).count());
    }

    public void setFilteredEmails(List<Email> collect) {
        currentFilteredEmails.setAll(collect);
    }

    public boolean isEditingMode() {
        return editingMode.get();
    }

    public ObservableBooleanValue isEditingModeProperty() {
        return editingMode;
    }

    public void setEditingMode(boolean editingMode) {
        this.editingMode.set(editingMode);
    }

    public long getNewEmailCount() {
        return newEmailCount.get();
    }

    public ObservableLongValue getNewEmailCountProperty() {
        return newEmailCount;
    }

    public void setNewEmailCount(Long newEmailCount) {
        this.newEmailCount.set(newEmailCount);
    }

    public String getSearchFilter() {
        return searchFilter.get();
    }

    public ObservableStringValue getSearchFilterProperty() {
        return searchFilter;
    }

    public void setSearchFilter(String searchFilter) {
        this.searchFilter.set(searchFilter);
        syncFilteredEmails();
    }
}

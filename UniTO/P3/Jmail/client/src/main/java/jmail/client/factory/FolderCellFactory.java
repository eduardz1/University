package jmail.client.factory;

import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.util.Callback;
import jmail.client.views.FolderCell;

public class FolderCellFactory implements Callback<ListView<String>, ListCell<String>> {

    public FolderCellFactory() {}

    @Override
    public ListCell<String> call(ListView<String> param) {
        return new FolderCell();
    }
}

package jmail.client;

import io.github.mimoguz.custom_window.DwmAttribute;
import io.github.mimoguz.custom_window.StageOps;
import java.io.IOException;
import java.net.URL;
import java.util.Objects;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import jmail.client.models.client.MailClient;
import jmail.lib.constants.ServerResponseStatuses;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.ServerResponse;
import jmail.lib.models.commands.CommandPing;

public class Main extends Application {

    public static Stage primaryStage;
    private static final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    public static void main(String[] args) {
        launch(args);
    }

    public static void changeScene(String fxml) {
        Platform.runLater(() -> {
            try {
                changeSceneImpl(fxml);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }

    public static URL getResource(String resource) {
        return Main.class.getResource(resource);
    }

    private static void changeSceneImpl(String fxml) throws IOException {
        Parent pane = FXMLLoader.load(Objects.requireNonNull(Main.class.getResource(fxml)));
        primaryStage.getScene().setRoot(pane);
        primaryStage.sizeToScene();
        primaryStage.setResizable(true);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        Main.primaryStage = primaryStage;

        FXMLLoader loader = new FXMLLoader(getClass().getResource("login.fxml"));

        Parent root = loader.load();

        Scene scene = new Scene(root);
        addCss(scene);

        primaryStage.setTitle("JMAIL");
        primaryStage.getIcons().add(new Image("icon.png"));
        primaryStage.setScene(scene);

        Platform.runLater(() -> {
            final var handle = StageOps.findWindowHandle(primaryStage);
            // Forces Dark Mode on Windows11
            StageOps.dwmSetBooleanValue(handle, DwmAttribute.DWMWA_USE_IMMERSIVE_DARK_MODE, true);
            startCheckThread();

            try {
                SystemIOHelper.createBaseFoldersIfNotExists();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        primaryStage.setResizable(false);
        primaryStage.show();
    }

    public void startCheckThread() {
        scheduler.scheduleAtFixedRate(Main::sendPingForConnectionCheck, 0, 15, TimeUnit.SECONDS);
    }

    public static void sendPingForConnectionCheck() {
        // La gestione dell'aggiornamento dello stato della connessione è dentro il
        // mailclient
        var pingCmd = new CommandPing();
        MailClient.getInstance()
                .sendCommand(
                        pingCmd,
                        response -> {
                            if (response.getStatus().equals(ServerResponseStatuses.OK)) {
                                System.out.println("Server is connected");
                            } else {
                                System.out.println("Server is not connected");
                            }
                        },
                        ServerResponse.class);
    }

    private void addCss(Scene scene) {
        scene.getStylesheets()
                .add(SystemIOHelper.getResource("styles/style.css").toExternalForm());
        scene.getStylesheets()
                .add(SystemIOHelper.getResource("styles/dark-mode.css").toExternalForm());
    }
}

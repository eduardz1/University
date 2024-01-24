package jmail.server;

import com.google.common.hash.Hashing;
import io.github.mimoguz.custom_window.DwmAttribute;
import io.github.mimoguz.custom_window.StageOps;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Objects;
import java.util.Properties;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.User;

public class Main extends Application {

    public static void main(String... args) throws IOException {

        Properties properties = new Properties();
        properties.load(Objects.requireNonNull(
                Thread.currentThread().getContextClassLoader().getResourceAsStream("server.properties")));

        Server server = new Server(Integer.parseInt(properties.getProperty("port")));
        server.start();
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("server.fxml"));
        Parent root = loader.load();

        Scene newScene = new Scene(root);
        addCss(newScene);

        primaryStage.setScene(newScene);

        primaryStage.setTitle("SERVER");
        primaryStage.getIcons().add(new Image("icon.png"));

        Platform.runLater(() -> {
            final var handle = StageOps.findWindowHandle(primaryStage);

            // Forces Dark Mode on Windows11
            StageOps.dwmSetBooleanValue(handle, DwmAttribute.DWMWA_USE_IMMERSIVE_DARK_MODE, true);
        });

        primaryStage.show();
    }

    @Override
    public void stop() {}

    private void addCss(Scene scene) {
        scene.getStylesheets()
                .add(SystemIOHelper.getResource("styles/style.css").toExternalForm());
        scene.getStylesheets()
                .add(SystemIOHelper.getResource("styles/dark-mode.css").toExternalForm());
    }

    public static void createUserForTest() {
        var edu1 = new User();
        edu1.setEmail("occhipinti.eduard@gmail.com");
        edu1.setName("Eduard");
        edu1.setSurname("Occhipinti");
        edu1.setPasswordSHA256(
                Hashing.sha256().hashString("edu1", StandardCharsets.UTF_8).toString());

        var edu2 = new User();
        edu2.setEmail("eduard.occhipinti@edu.unito.it");
        edu2.setName("Eduard");
        edu2.setSurname("Occhipinti");
        edu2.setPasswordSHA256(
                Hashing.sha256().hashString("edu2", StandardCharsets.UTF_8).toString());

        var fratta = new User();
        fratta.setEmail("marcofrattarola@gmail.com");
        fratta.setName("Marco");
        fratta.setSurname("Frattarola");
        fratta.setPasswordSHA256(
                Hashing.sha256().hashString("fratta", StandardCharsets.UTF_8).toString());

        var emme = new User();
        emme.setEmail("emmedeveloper@gmail.com");
        emme.setName("Emme");
        emme.setSurname("Developer");
        emme.setPasswordSHA256(
                Hashing.sha256().hashString("emme", StandardCharsets.UTF_8).toString());

        var mario = new User();
        mario.setEmail("mario@yahoo.it");
        mario.setName("Mario");
        mario.setSurname("Oiram");
        mario.setPasswordSHA256(
                Hashing.sha256().hashString("mario", StandardCharsets.UTF_8).toString());

        save(edu1);
        save(edu2);
        save(fratta);
        save(emme);
        save(mario);
    }

    private static void save(User user) {
        try {
            SystemIOHelper.createUserFolderIfNotExists(user.getEmail());
            SystemIOHelper.writeJSONFile(
                    SystemIOHelper.getUserDirectory(user.getEmail()), "user.json", JsonHelper.toJson(user));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

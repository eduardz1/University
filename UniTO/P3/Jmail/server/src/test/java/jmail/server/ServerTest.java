package jmail.server;

import com.google.common.hash.Hashing;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.User;
import org.junit.jupiter.api.Test;

class ServerTest {

    // test creation of new users
    @Test
    void testCreateNewUser() {
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

    public void save(User user) {
        try {
            SystemIOHelper.createUserFolderIfNotExists(user.getEmail());
            SystemIOHelper.writeJSONFile(
                    SystemIOHelper.getUserDirectory(user.getEmail()), "user.json", JsonHelper.toJson(user));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

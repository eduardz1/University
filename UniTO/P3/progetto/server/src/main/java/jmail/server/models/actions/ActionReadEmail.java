package jmail.server.models.actions;

import java.io.IOException;
import java.nio.file.Files;
import jmail.lib.handlers.LockHandler;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.Email;
import jmail.lib.models.commands.CommandReadEmail;
import jmail.server.exceptions.ActionExecutionException;

public class ActionReadEmail implements ActionCommand {
    private final CommandReadEmail command;

    public ActionReadEmail(CommandReadEmail cmd) {
        this.command = cmd;
    }

    @Override
    public void execute() throws ActionExecutionException {

        var cmd = (CommandReadEmail) this.command;
        var params = cmd.getParameter();
        var userEmail = cmd.getUserEmail();
        var emailID = params.emailID();

        if (userEmail == null || userEmail.isEmpty()) {
            throw new ActionExecutionException("User invalid");
        }

        var handler = LockHandler.getInstance();
        var lock = handler.getWriteLock(userEmail);
        lock.lock();
        try {
            var path = SystemIOHelper.getInboxEmailPath(userEmail, emailID);
            var json = SystemIOHelper.readJSONFile(path);
            var mail = JsonHelper.fromJson(json, Email.class);

            if (!mail.getRead().equals(params.setAsRead())) {
                var email = new Email(
                        emailID,
                        mail.getSubject(),
                        mail.getBody(),
                        mail.getSender(),
                        mail.getRecipients(),
                        mail.getDate(),
                        params.setAsRead());
                Files.write(path, JsonHelper.toJson(email).getBytes());
            }

        } catch (IOException e) {
            throw new ActionExecutionException(e, "Internal error");
        } finally {
            lock.unlock();
            handler.removeLock(userEmail);
        }
    }
}

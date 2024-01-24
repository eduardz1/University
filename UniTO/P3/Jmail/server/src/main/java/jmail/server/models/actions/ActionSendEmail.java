package jmail.server.models.actions;

import java.io.IOException;
import java.nio.file.Path;
import jmail.lib.handlers.LockHandler;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.commands.CommandSendEmail;
import jmail.server.exceptions.ActionExecutionException;

public class ActionSendEmail implements ActionCommand {
    private final CommandSendEmail command;

    public ActionSendEmail(CommandSendEmail cmd) {
        this.command = cmd;
    }

    @Override
    public void execute() throws ActionExecutionException {

        var params = command.getParameter();
        var userEmail = command.getUserEmail();

        if (userEmail == null || userEmail.isEmpty()) {
            throw new ActionExecutionException("User invalid");
        }

        // Check recipients and compose errorMessage, if some error will occure
        StringBuilder errorMessage = new StringBuilder();
        var email = params.email();

        var areAllRecipientsValid = email.getRecipients().stream().allMatch(user -> {
            if (!SystemIOHelper.userExists(user)) {
                errorMessage.append("User not found with email: ").append(user).append("\n");
                return false;
            }
            return true;
        });

        if (!areAllRecipientsValid) {
            throw new ActionExecutionException(errorMessage.toString());
        }

        // Lock user folder that send email
        var handler = LockHandler.getInstance();
        var senderLock = handler.getWriteLock(userEmail);

        var sent = SystemIOHelper.getUserSent(userEmail);
        Path sentEmailPath;
        var fileName = email.fileID();

        try {
            senderLock.lock();
            var jsonEmail = JsonHelper.toJson(email);
            SystemIOHelper.writeJSONFile(sent, fileName, jsonEmail);
            sentEmailPath = SystemIOHelper.getSentEmailPath(
                    userEmail, fileName); // Get path to email file sent, used above to copy to inbox
        } catch (IOException e) {
            senderLock.unlock();
            handler.removeLock(userEmail);
            throw new ActionExecutionException(e, "Internal error");
        }

        // All recs valid, send email
        for (String receiver : email.getRecipients()) {
            var receiverLock = handler.getWriteLock(receiver);
            try {
                receiverLock.lock();
                SystemIOHelper.copyFile(sentEmailPath, SystemIOHelper.getInboxEmailPath(receiver, fileName));
            } catch (IOException e) {
                throw new ActionExecutionException(e, "Internal error");
            } finally {
                receiverLock.unlock();
                handler.removeLock(receiver);
            }
        }

        // Release lock if no errors occured
        senderLock.unlock();
        handler.removeLock(userEmail);
    }
}

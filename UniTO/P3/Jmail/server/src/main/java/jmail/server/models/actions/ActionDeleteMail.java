package jmail.server.models.actions;

import java.io.IOException;
import jmail.lib.constants.Folders;
import jmail.lib.handlers.LockHandler;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.commands.CommandDeleteEmail;
import jmail.server.exceptions.ActionExecutionException;

public class ActionDeleteMail implements ActionCommand {
    private final CommandDeleteEmail command;

    public ActionDeleteMail(CommandDeleteEmail cmd) {
        this.command = cmd;
    }

    @Override
    public void execute() throws ActionExecutionException {
        var userEmail = command.getUserEmail();
        var emailID = command.getParameter().emailID();
        var from = command.getParameter().from();
        var hardDelete = command.getParameter().hardDelete();

        if (userEmail == null || userEmail.isEmpty()) {
            throw new ActionExecutionException("User invalid");
        }
        var handler = LockHandler.getInstance();
        var lock = handler.getWriteLock(userEmail);
        var locked = false;

        try {
            var fromPath =
                    switch (from) {
                        case Folders.INBOX -> SystemIOHelper.getInboxEmailPath(userEmail, emailID);
                        case Folders.SENT -> SystemIOHelper.getSentEmailPath(userEmail, emailID);
                        case Folders.TRASH -> SystemIOHelper.getDeletedEmailPath(userEmail, emailID);
                        default -> throw new ActionExecutionException("Invalid from");
                    };
            lock.lock();
            locked = true;
            if (hardDelete) {
                SystemIOHelper.deleteFile(fromPath);
            } else {
                SystemIOHelper.moveFile(fromPath, SystemIOHelper.getDeletedEmailPath(userEmail, emailID));
            }
        } catch (IOException e) {
            throw new ActionExecutionException(e, "Internal error");
        } finally {
            if (locked) lock.unlock();
            handler.removeLock(userEmail);
        }
    }
}

package jmail.server.models.actions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import jmail.lib.constants.Folders;
import jmail.lib.constants.ServerResponseStatuses;
import jmail.lib.handlers.LockHandler;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.Email;
import jmail.lib.models.ServerResponse;
import jmail.lib.models.commands.CommandListEmail;
import jmail.server.exceptions.ActionExecutionException;
import lombok.Getter;
import lombok.Setter;

public class ActionListEmail implements ActionCommand {
    private final CommandListEmail command;

    public ActionListEmail(CommandListEmail cmd) {
        this.command = cmd;
    }

    @Override
    public ServerResponse executeAndGetResult() throws ActionExecutionException {
        var params = command.getParameter();
        var folder = params.folder();
        var userEmail = command.getUserEmail();

        if (userEmail == null || userEmail.isEmpty()) {
            throw new ActionExecutionException("User invalid");
        }

        // If shouldCheckUnixTime is false means that user needs to load all emails
        boolean shouldCheckUnixTime = params.lastUnixTimeCheck() != null;

        var handler = LockHandler.getInstance();
        var userLock = handler.getReadLock(userEmail);
        userLock.lock();

        var path =
                switch (folder) {
                    case Folders.INBOX -> SystemIOHelper.getUserInbox(userEmail);
                    case Folders.SENT -> SystemIOHelper.getUserSent(userEmail);
                    case Folders.TRASH -> SystemIOHelper.getUserTrash(userEmail);
                    default -> throw new ActionExecutionException("Invalid folder");
                };

        var mails = new ArrayList<Email>();
        File[] files = (new File(path.toUri())).listFiles();
        files = files == null ? new File[] {} : files;
        for (File file : files) {
            if (!shouldCheckUnixTime || getUnixTimeFromFilename(file) > params.lastUnixTimeCheck()) {
                System.out.println("file " + getUnixTimeFromFilename(file) + " " + params.lastUnixTimeCheck());
                try {
                    var json = SystemIOHelper.readJSONFile(Path.of(file.getPath()));
                    var mail = JsonHelper.fromJson(json, Email.class);
                    mails.add(mail);
                } catch (IOException e) {
                    userLock.unlock();
                    handler.removeLock(userEmail); // Release lock before throwing exception
                    throw new ActionExecutionException(e, "Internal error");
                }
            }
        }
        mails.sort(Comparator.comparing(Email::getDate).reversed());

        userLock.unlock();
        handler.removeLock(userEmail);
        return new ActionListEmailServerResponse(mails);
    }

    private Long getUnixTimeFromFilename(File file) {
        var name = file.getName();
        var last_ = name.lastIndexOf("_");
        return Long.parseLong(name.substring(last_ + 1));
    }

    @Getter
    @Setter
    public class ActionListEmailServerResponse extends ServerResponse {
        private List<Email> emails;

        public ActionListEmailServerResponse(List<Email> emails) {
            super(ServerResponseStatuses.OK, "");
            this.emails = emails;
        }
    }
}

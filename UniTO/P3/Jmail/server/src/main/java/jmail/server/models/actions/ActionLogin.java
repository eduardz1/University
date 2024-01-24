package jmail.server.models.actions;

import jmail.lib.constants.ServerResponseStatuses;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.ServerResponse;
import jmail.lib.models.User;
import jmail.lib.models.commands.CommandLogin;
import lombok.Getter;
import lombok.Setter;

public class ActionLogin implements ActionCommand {
    private final CommandLogin command;

    public ActionLogin(CommandLogin command) {
        this.command = command;
    }

    @Override
    public ServerResponse executeAndGetResult() {
        if (!SystemIOHelper.userExists(command.getParameter().email()))
            return ServerResponse.createErrorResponse("User does not exist");

        var user = SystemIOHelper.getUser(command.getParameter().email());
        if (user.getPasswordSHA256().equals(command.getParameter().hashedPassword())) {
            return new ActionLoginServerResponse(user);
        } else {
            return ServerResponse.createErrorResponse("Login failed");
        }
    }

    @Getter
    @Setter
    public class ActionLoginServerResponse extends ServerResponse {
        private User user;

        public ActionLoginServerResponse(User user) {
            super(ServerResponseStatuses.OK, "Login successful");
            this.user = user;
        }
    }
}

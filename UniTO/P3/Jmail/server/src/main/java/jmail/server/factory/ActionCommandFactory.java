package jmail.server.factory;

import jmail.lib.constants.CommandActions;
import jmail.lib.models.commands.*;
import jmail.server.models.actions.*;

public class ActionCommandFactory {

    public static ActionCommand getActionCommand(Command cmd) {
        return switch (cmd.getAction()) {
            case CommandActions.DELETE -> new ActionDeleteMail((CommandDeleteEmail) cmd);
            case CommandActions.LIST -> new ActionListEmail((CommandListEmail) cmd);
            case CommandActions.READ -> new ActionReadEmail((CommandReadEmail) cmd);
            case CommandActions.RESTORE -> new ActionRestoreEmail((CommandRestoreEmail) cmd);
            case CommandActions.SEND -> new ActionSendEmail((CommandSendEmail) cmd);
            case CommandActions.LOGIN -> new ActionLogin((CommandLogin) cmd);
            default -> null;
        };
    }
}

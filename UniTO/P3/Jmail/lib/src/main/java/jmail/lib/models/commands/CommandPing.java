package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;

public class CommandPing extends Command {
    public CommandPing() {
        super(CommandActions.PING);
    }
}

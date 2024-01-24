package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;

public class CommandDeleteEmail extends Command {

    public CommandDeleteEmail(CommandDeleteEmailParameter parameter) {
        super(CommandActions.DELETE);
        super.setParameter(parameter);
    }

    @Override
    public CommandDeleteEmailParameter getParameter() {
        return (CommandDeleteEmailParameter) super.getParameter();
    }

    public record CommandDeleteEmailParameter(String emailID, String from, Boolean hardDelete)
            implements CommandParameters {}
}

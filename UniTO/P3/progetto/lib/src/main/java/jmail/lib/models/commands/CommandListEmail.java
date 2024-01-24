package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;

public class CommandListEmail extends Command {

    // Standard constructor for jackson
    public CommandListEmail() {
        super(CommandActions.LIST);
    }

    public CommandListEmail(CommandListEmailParameter parameter) {
        super(CommandActions.LIST);
        super.setParameter(parameter);
    }

    @Override
    public CommandListEmailParameter getParameter() {
        return (CommandListEmailParameter) super.getParameter();
    }

    public record CommandListEmailParameter(Long lastUnixTimeCheck, String folder) implements CommandParameters {}
}

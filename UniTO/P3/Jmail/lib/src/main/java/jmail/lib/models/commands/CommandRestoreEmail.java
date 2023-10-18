package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;

public class CommandRestoreEmail extends Command {

  public CommandRestoreEmail(CommandRestoreEmailParameter parameter) {
    super(CommandActions.RESTORE);
    super.setParameter(parameter);
  }

  @Override
  public CommandRestoreEmailParameter getParameter() {
    return (CommandRestoreEmailParameter) super.getParameter();
  }

  public record CommandRestoreEmailParameter(String emailID) implements CommandParameters {}
}

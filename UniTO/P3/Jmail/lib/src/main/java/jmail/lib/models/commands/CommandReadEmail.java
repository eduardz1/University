package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;

public class CommandReadEmail extends Command {

  public CommandReadEmail(CommandReadEmailParameter parameter) {
    super(CommandActions.READ);
    super.setParameter(parameter);
  }

  @Override
  public CommandReadEmailParameter getParameter() {
    return (CommandReadEmailParameter) super.getParameter();
  }

  public record CommandReadEmailParameter(String emailID, Boolean setAsRead)
      implements CommandParameters {}
}

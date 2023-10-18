package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;
import jmail.lib.models.Email;

public class CommandSendEmail extends Command {

  public CommandSendEmail(CommandSendEmailParameter parameter) {
    super(CommandActions.SEND);
    super.setParameter(parameter);
  }

  @Override
  public CommandSendEmailParameter getParameter() {
    return (CommandSendEmailParameter) super.getParameter();
  }

  public record CommandSendEmailParameter(Email email) implements CommandParameters {}
}

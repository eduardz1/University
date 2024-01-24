package jmail.lib.models.commands;

import jmail.lib.constants.CommandActions;

public class CommandLogin extends Command {

  public CommandLogin(CommandLoginParameter parameter) {
    super(CommandActions.LOGIN);
    super.setUserEmail(getUserEmail());
    super.setParameter(parameter);
  }

  @Override
  public CommandLoginParameter getParameter() {
    return (CommandLoginParameter) super.getParameter();
  }

  public record CommandLoginParameter(String email, String hashedPassword)
      implements CommandParameters {}
}

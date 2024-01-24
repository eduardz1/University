package jmail.server.models.actions;

import jmail.lib.models.ServerResponse;
import jmail.server.exceptions.ActionExecutionException;

public interface ActionCommand {
  default void execute() throws ActionExecutionException {
    throw new ActionExecutionException("Method not implemented");
  }

  default ServerResponse executeAndGetResult() throws ActionExecutionException {
    throw new ActionExecutionException("Method not implemented");
  }
}

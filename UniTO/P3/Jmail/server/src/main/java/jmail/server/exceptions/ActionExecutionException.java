package jmail.server.exceptions;

public class ActionExecutionException extends Exception {
  private Exception innerExceptions = null;

  public ActionExecutionException(String message) {
    super(message);
  }

  public ActionExecutionException(Exception inner, String message) {
    super(message);
    this.innerExceptions = inner;
  }

  public String getInnerMessage() {
    if (innerExceptions == null) return "";
    return innerExceptions.getLocalizedMessage();
  }
}

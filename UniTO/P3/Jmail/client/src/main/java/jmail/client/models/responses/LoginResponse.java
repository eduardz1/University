package jmail.client.models.responses;

import jmail.lib.models.ServerResponse;
import jmail.lib.models.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginResponse extends ServerResponse {
  private User user;

  public LoginResponse(String status, String message) {
    super(status, message);
  }

  public LoginResponse() {
    super();
  }
}

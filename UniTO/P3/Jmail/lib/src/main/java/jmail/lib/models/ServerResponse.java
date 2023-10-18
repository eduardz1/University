package jmail.lib.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import jmail.lib.constants.ServerResponseStatuses;
import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ServerResponse {
  private String status;
  private String message;

  public ServerResponse() {}

  public ServerResponse(String status, String message) {
    this.status = status;
    this.message = message;
  }

  public ServerResponse(String status) {
    this.status = status;
  }

  public static ServerResponse createOkResponse(String message) {
    return new ServerResponse(ServerResponseStatuses.OK, message);
  }

  public static ServerResponse createErrorResponse(String message) {
    return new ServerResponse(ServerResponseStatuses.ERROR, message);
  }
}

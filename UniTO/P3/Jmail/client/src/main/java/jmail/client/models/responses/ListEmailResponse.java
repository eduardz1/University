package jmail.client.models.responses;

import java.util.List;
import jmail.lib.models.Email;
import jmail.lib.models.ServerResponse;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ListEmailResponse extends ServerResponse {
    private List<Email> emails;

    public ListEmailResponse(String status, String message) {
        super(status, message);
    }

    public ListEmailResponse() {
        super();
    }
}

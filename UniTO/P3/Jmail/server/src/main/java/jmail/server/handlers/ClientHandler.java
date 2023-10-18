package jmail.server.handlers;

import com.fasterxml.jackson.core.JsonProcessingException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import jmail.lib.constants.ServerResponseStatuses;
import jmail.lib.exceptions.CommandNotFoundException;
import jmail.lib.exceptions.NotAuthorizedException;
import jmail.lib.helpers.JsonHelper;
import jmail.lib.helpers.SystemIOHelper;
import jmail.lib.models.ServerResponse;
import jmail.lib.models.commands.Command;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ClientHandler implements Runnable {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClientHandler.class.getName());
    private final Socket internalSocket;
    private BufferedReader reader;
    private PrintWriter writer;

    public ClientHandler(Socket clientSocket) {
        internalSocket = clientSocket;
    }

    @Override
    public void run() {
        try {
            reader = new BufferedReader(new InputStreamReader(internalSocket.getInputStream()));
            writer = new PrintWriter(internalSocket.getOutputStream(), true);
            String request = reader.readLine();
            LOGGER.info("Message received from client: " + request);

            var cmd = JsonHelper.fromJson(request, Command.class);
            if (cmd == null) {
                throw new CommandNotFoundException();
            }
            if (cmd.requireAuth()) {
                if (!cmd.hasEmail()) {
                    throw new NotAuthorizedException("User not provided");
                }

                var userEmail = cmd.getUserEmail();
                if (SystemIOHelper.userExists(userEmail)) {
                    SystemIOHelper.createUserFolderIfNotExists(userEmail);
                } else {
                    throw new NotAuthorizedException("User not found");
                }
            }

            var commandHandler = new CommandHandler(cmd, writer);
            commandHandler.executeAction();

        } catch (CommandNotFoundException | JsonProcessingException e) {
            LOGGER.error(e.getMessage());
            sendResponse(ServerResponseStatuses.ERROR, "Message invalid");
        } catch (NotAuthorizedException e) {
            LOGGER.error(e.getMessage());
            sendResponse(ServerResponseStatuses.ERROR, e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
            sendResponse(ServerResponseStatuses.ERROR, e.getMessage());
        }
    }

    private void sendResponse(String status, String errorMessage) {
        var resp = new ServerResponse(status, errorMessage);
        try {
            writer.println(JsonHelper.toJson(resp));
        } catch (JsonProcessingException e) {
            LOGGER.error("Cannot serialize server response: " + e.getLocalizedMessage());
            writer.println("{\"status\": \"error\", \"message\":\"Unable to get response from server\"}");
        }
    }
}

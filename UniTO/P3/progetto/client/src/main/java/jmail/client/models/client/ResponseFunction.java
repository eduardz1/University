package jmail.client.models.client;

import jmail.lib.models.ServerResponse;

@FunctionalInterface
public interface ResponseFunction {
  void run(ServerResponse response);
}

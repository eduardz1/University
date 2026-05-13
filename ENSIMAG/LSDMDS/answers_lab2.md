# Lab 2

- If the server crashes and needs to be restarted, the producers and consumers automatically connect to it again
- If multiple consumers are registered to the same topic, they all receive the same messages
- The consumers don't see any difference and receive all the messages
- Only the last one receives the message
- Still only one receives the message
- The new one does not receive the message
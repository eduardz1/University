package jmail.lib.layouts;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.LayoutBase;
import java.time.Instant;

public class LogLayout extends LayoutBase<ILoggingEvent> {

  @Override
  public String doLayout(ILoggingEvent event) {
    return String.format(
        "%1$21s [%2$s] %3$6s %4$s - %5$s",
        Instant.ofEpochMilli(event.getTimeStamp()),
        event.getThreadName(),
        event.getLevel(),
        event.getLoggerName(),
        event.getFormattedMessage());
  }
}

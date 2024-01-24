package jmail.server.controllers;

import java.net.URL;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import jmail.lib.logger.ObservableStreamAppender;
import org.fxmisc.richtext.CodeArea;
import org.fxmisc.richtext.model.StyleSpans;
import org.fxmisc.richtext.model.StyleSpansBuilder;

public class FXMLMainController implements Initializable {

    private static final String TRACE_PATTERN = "\\b(Trace)\\b:";
    private static final String DEBUG_PATTERN = "\\b(DEBUG|Debug)\\b|(?i)\\b(debug):";
    private static final String INFO_PATTERN =
            "\\b(HINT|INFO|INFORMATION|Info|NOTICE|II)\\b|(?i)\\b(info|information):";
    private static final String WARN_PATTERN = "\\b(WARNING|WARN|Warn|WW)\\b|(?i)\\b(warning):";
    private static final String ERROR_PATTERN =
            "\\b(ALERT|CRITICAL|EMERGENCY|ERROR|FAILURE|FAIL|Fatal|FATAL|Error|EE)\\b|(?i)\\b(error):";
    private static final String ISODATES_PATTERN = "\\b\\d{4}-\\d{2}-\\d{2}(T|\\b)";
    private static final String LOCALDATES_PATTERN = "(?<=(^|\\s))\\d{2}[^\\w\\s]\\d{2}[^\\w\\s]\\d{4}\\b";
    private static final String TIME_PATTERN = "\\d{1,2}:\\d{2}(:\\d{2}([.,]\\d+)?)?(Z| ?[+-]\\d{1,2}:\\d{2})?\\b";
    private static final String GUID_PATTERN = "\\b[0-9a-fA-F]{8}-?([0-9a-fA-F]{4}-?){3}[0-9a-fA-F]{12}\\b";
    private static final String MAC_PATTERN = "\\b([0-9a-fA-F]{2,}[:-])+[0-9a-fA-F]{2,}+\\b";
    private static final String CONSTANTS_PATTERN = "\\b([0-9]+|true|false|null)\\b";
    private static final String HEXCONSTANTS_PATTERN = "\\b(0x[a-fA-F0-9]+)\\b";
    private static final String STRINGCONSTANTS_PATTERN = "\"[^\"]*\"" + "(?<!\\w)'[^']*'";
    private static final String EXCEPTIONS_PATTERN = "\\b([a-zA-Z.]*Exception)\\b";
    private static final String URL_PATTERN = "\\b[a-z]+://\\S+\\b/?";
    private static final String NAMESPACES_PATTERN = "(?<![\\w/\\\\])([\\w-]+\\.)+([\\w-])+(?![\\w/\\\\])";

    private static final String OTHER_PATTERN = "\\S+";
    private static final Pattern PATTERN = Pattern.compile("(?<TRACE>"
            + TRACE_PATTERN
            + ")"
            + "|(?<DEBUG>"
            + DEBUG_PATTERN
            + ")"
            + "|(?<INFO>"
            + INFO_PATTERN
            + ")"
            + "|(?<WARN>"
            + WARN_PATTERN
            + ")"
            + "|(?<ERROR>"
            + ERROR_PATTERN
            + ")"
            + "|(?<ISODATES>"
            + ISODATES_PATTERN
            + ")"
            + "|(?<LOCALDATES>"
            + LOCALDATES_PATTERN
            + ")"
            + "|(?<TIME>"
            + TIME_PATTERN
            + ")"
            + "|(?<GUID>"
            + GUID_PATTERN
            + ")"
            + "|(?<MAC>"
            + MAC_PATTERN
            + ")"
            + "|(?<CONSTANTS>"
            + CONSTANTS_PATTERN
            + ")"
            + "|(?<HEXCONSTANTS>"
            + HEXCONSTANTS_PATTERN
            + ")"
            + "|(?<STRINGCONSTANTS>"
            + STRINGCONSTANTS_PATTERN
            + ")"
            + "|(?<EXCEPTIONS>"
            + EXCEPTIONS_PATTERN
            + ")"
            + "|(?<URL>"
            + URL_PATTERN
            + ")"
            + "|(?<NAMESPACES>"
            + NAMESPACES_PATTERN
            + ")"
            + "|(?<OTHER>"
            + OTHER_PATTERN
            + ")");

    @FXML private CodeArea codeArea;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        // Colora il messaggio arrivato dal log
        codeArea.richChanges()
                .filter(ch -> !ch.getInserted().equals(ch.getRemoved()))
                .subscribe(change -> codeArea.setStyleSpans(0, computeHighlighting(codeArea.getText())));

        // Aggiunge il messaggio al log
        ObservableStreamAppender.getObservable()
                .addListener((observable, oldValue, newValue) ->
                        Platform.runLater(() -> codeArea.appendText(newValue + '\n')));
    }

    // Formatta il colore
    private StyleSpans<Collection<String>> computeHighlighting(String text) {
        Matcher matcher = PATTERN.matcher(text);
        int lastKwEnd = 0;
        StyleSpansBuilder<Collection<String>> spansBuilder = new StyleSpansBuilder<>();

        var matchArray = List.of(
                "TRACE",
                "DEBUG",
                "INFO",
                "WARN",
                "ERROR",
                "ISODATES",
                "LOCALDATES",
                "TIME",
                "GUID",
                "MAC",
                "CONSTANTS",
                "HEXCONSTANTS",
                "STRINGCONSTANTS",
                "EXCEPTIONS",
                "URL",
                "NAMESPACES",
                "OTHER");

        while (matcher.find()) {
            for (String match : matchArray) {
                if (matcher.group(match) != null) {
                    spansBuilder.add(Collections.emptyList(), matcher.start() - lastKwEnd);
                    spansBuilder.add(Collections.singleton(match.toLowerCase()), matcher.end() - matcher.start());
                    lastKwEnd = matcher.end();
                    break;
                }
            }
        }
        spansBuilder.add(Collections.emptyList(), text.length() - lastKwEnd);
        return spansBuilder.create();
    }
}

package jmail.lib.constants;

public enum ColorPalette {
    BLUE("#1273DE"),
    GREEN("#39864F"),
    TEXT("#AfB1B3"),
    RED("#FF5555"),
    YELLOW("#FFB86C");

    private final String color;

    ColorPalette(String color) {
        this.color = color;
    }

    public String getHexValue() {
        return color;
    }
}

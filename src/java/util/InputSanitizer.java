package util;

public final class InputSanitizer {
    private InputSanitizer() {}

    /**
     * Escapes HTML special characters to prevent XSS attacks.
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }
}

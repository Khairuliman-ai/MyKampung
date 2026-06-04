package util;

/**
 * InputSanitizer provides utilities to prevent Cross-Site Scripting (XSS) vulnerabilities.
 * It encodes HTML special characters into their respective safe HTML entities.
 * 
 * Note: Performs entity encoding rather than tag stripping. We implement this custom utility 
 * to maintain a lightweight servlet deployment without introducing heavy external library dependencies
 * (such as Jsoup or OWASP HTML Sanitizer).
 */
public final class InputSanitizer {
    private InputSanitizer() {}

    /**
     * Escapes HTML special characters in the input string.
     * Escapes characters: &, <, >, ", ', and /.
     * 
     * @param input the raw string to sanitize
     * @return the HTML entity encoded safe string, or an empty string if input is null
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

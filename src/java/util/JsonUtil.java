package util;

import com.google.gson.Gson;

/**
 * Utility class for JSON operations, specifically for safely embedding JSON strings
 * in HTML/JSP data-* attributes to prevent XSS.
 */
public final class JsonUtil {
    private static final Gson gson = new Gson();

    private JsonUtil() {
        // Prevent instantiation
    }

    /**
     * Serializes an object to JSON and escapes characters that are sensitive in HTML
     * contexts (especially quotes and brackets) so it can be safely used within
     * HTML data attributes (e.g., data-hebahan="...").
     *
     * @param obj the object to serialize
     * @return HTML-safe JSON string
     */
    public static String toSafeAttr(Object obj) {
        if (obj == null) {
            return "{}";
        }
        String json = gson.toJson(obj);
        return json.replace("&", "&amp;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;");
    }
}

package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.cert.X509Certificate;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;
import java.util.logging.Level;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

public class GeminiUtil {

    private static final Logger LOGGER = Logger.getLogger(GeminiUtil.class.getName());
    private static String apiKey = null;
    private static String modelName = null;

    static {
        loadConfig();
        bypassSSL(); // Bulletproof guarantee against JVM PKIX SSL handshake errors on older JDK 8 setups
    }

    private static void loadConfig() {
        Properties config = new Properties();
        try (java.io.InputStream input = GeminiUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                config.load(input);
                apiKey = config.getProperty("gemini.api.key");
                modelName = config.getProperty("gemini.model", "gemini-1.5-flash");
                LOGGER.log(Level.INFO, "GeminiUtil - Konfigurasi berjaya dimuatkan. Model: {0}, API Key present: {1}", 
                        new Object[]{modelName, (apiKey != null && !apiKey.isEmpty())});
            } else {
                LOGGER.log(Level.SEVERE, "GeminiUtil - config.properties tidak dijumpai! Gemini AI tidak akan berfungsi.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "GeminiUtil - Ralat membaca config.properties: " + e.getMessage(), e);
        }
    }

    /**
     * Bypasses SSL Certificate Verification.
     * Extremely important for student/local machines running older JDK 8 versions
     * which don't have modern Google root certificates in their trustStore.
     */
    private static void bypassSSL() {
        try {
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    public java.security.cert.X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                }
            };

            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) { return true; }
            };
            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
            LOGGER.log(Level.INFO, "GeminiUtil - Pintasan SSL Global berjaya dikonfigurasikan.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "GeminiUtil - Ralat semasa menetapkan pintasan SSL Global: " + e.getMessage(), e);
        }
    }

    /**
     * Send chat request to Gemini.
     * @param systemPrompt Instructions for behavior and knowledge
     * @param history List of [role, text] history elements (role: "user" or "model")
     * @param userMessage New user input
     * @return AI text response
     */
    public static String chat(String systemPrompt, List<String[]> history, String userMessage) {
        if (apiKey == null || apiKey.isEmpty()) {
            LOGGER.log(Level.WARNING, "GeminiUtil [Chat] - Percubaan memanggil Gemini AI gagal: Kunci API tidak dikonfigurasikan.");
            return "Maaf, kunci API Gemini tidak dikonfigurasikan. Sila semak config.properties.";
        }

        try {
            // Using the stable production v1 endpoint
            String urlString = "https://generativelanguage.googleapis.com/v1/models/" + modelName + ":generateContent?key=" + apiKey;
            URL url = new URL(urlString);
            
            LOGGER.log(Level.INFO, "GeminiUtil [Chat] - Membuka sambungan HTTPS ke: https://generativelanguage.googleapis.com/v1/models/{0}:generateContent", modelName);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            
            // Set SSL bypass directly on connection to guarantee it works in Tomcat
            try {
                TrustManager[] trustAllCerts = new TrustManager[]{
                    new X509TrustManager() {
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() { return null; }
                        public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {}
                        public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {}
                    }
                };
                SSLContext sc = SSLContext.getInstance("TLS");
                sc.init(null, trustAllCerts, new java.security.SecureRandom());
                conn.setSSLSocketFactory(sc.getSocketFactory());
                conn.setHostnameVerifier((hostname, session) -> true);
                LOGGER.log(Level.INFO, "GeminiUtil [Chat] - Pintasan SSL bagi sambungan aktif berjaya ditetapkan.");
            } catch (Exception sslEx) {
                LOGGER.log(Level.WARNING, "GeminiUtil [Chat] - Gagal menetapkan pintasan SSL terus pada sambungan: " + sslEx.getMessage(), sslEx);
            }

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(30000);

            // Construct JSON request body manually
            StringBuilder json = new StringBuilder("{");
            json.append("\"contents\":[");

            boolean hasContent = false;

            // 1. Inject the System Prompt as the initial turn of conversation.
            if (systemPrompt != null && !systemPrompt.trim().isEmpty()) {
                json.append("{\"role\":\"user\",")
                    .append("\"parts\":[{\"text\":\"SISTEM ARAHAN PERILAKU DAN PENGETAHUAN KAMPUNGBOT:\\n")
                    .append(escapeJson(systemPrompt)).append("\"}]}");
                
                json.append(",{\"role\":\"model\",")
                    .append("\"parts\":[{\"text\":\"Faham. Saya bersedia membantu sebagai KampungBot pintar.\"}]}");
                hasContent = true;
            }

            // 2. Add previous history
            if (history != null && !history.isEmpty()) {
                for (String[] turn : history) {
                    if (turn.length >= 2 && turn[0] != null && turn[1] != null) {
                        if (hasContent) json.append(",");
                        json.append("{\"role\":\"").append(escapeJson(turn[0])).append("\",")
                            .append("\"parts\":[{\"text\":\"").append(escapeJson(turn[1])).append("\"}]}");
                        hasContent = true;
                    }
                }
            }

            // 3. Add new user message
            if (hasContent) json.append(",");
            json.append("{\"role\":\"user\",")
                .append("\"parts\":[{\"text\":\"").append(escapeJson(userMessage)).append("\"}]}");

            json.append("]}");

            LOGGER.log(Level.INFO, "GeminiUtil [Chat] - Mengirim payload JSON (Saiz: {0} aksara)...", json.length());

            // Send payload
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = json.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            // Get response
            int responseCode = conn.getResponseCode();
            LOGGER.log(Level.INFO, "GeminiUtil [Chat] - Respon diterima daripada Google API. Kod Status HTTP: {0}", responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    LOGGER.log(Level.INFO, "GeminiUtil [Chat] - Pembacaan respons berjaya. Menyahsulit kandungan...");
                    return extractText(response.toString());
                }
            } else {
                // Read error stream for debugging with safe null check
                StringBuilder errMsg = new StringBuilder();
                java.io.InputStream errorStream = conn.getErrorStream();
                if (errorStream != null) {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(errorStream, "utf-8"))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            errMsg.append(line.trim());
                        }
                    }
                } else {
                    errMsg.append("Tiada butiran tambahan dipulangkan oleh API Google.");
                }
                
                LOGGER.log(Level.SEVERE, "GeminiUtil [Chat] - Gagal memanggil API. Kod HTTP: {0}. Butiran Ralat: {1}", 
                        new Object[]{responseCode, errMsg.toString()});
                return "Maaf, berlaku gangguan semasa menghubungi KampungBot (HTTP " + responseCode + "). Sila cuba seketika lagi.";
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "GeminiUtil [Chat] - Pengecualian rangkaian / input-output semasa menghubungi Gemini: " + e.getMessage(), e);
            return "Maaf, ralat sambungan rangkaian dikesan: " + e.getMessage();
        }
    }

    /**
     * Escape characters to build a valid JSON string.
     */
    private static String escapeJson(String text) {
        if (text == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            switch (ch) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (ch < ' ') {
                        String t = "000" + Integer.toHexString(ch);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(ch);
                    }
            }
        }
        return sb.toString();
    }

    /**
     * Parse text inside "text" field from Gemini response manually.
     */
    private static String extractText(String json) {
        int textIndex = json.indexOf("\"text\":");
        if (textIndex == -1) {
            textIndex = json.indexOf("\"text\" :");
        }
        if (textIndex == -1) return "Maaf, KampungBot tidak dapat memberikan jawapan.";

        int startQuote = json.indexOf("\"", textIndex + 7);
        if (startQuote == -1) return "Maaf, ralat format tindak balas.";

        StringBuilder sb = new StringBuilder();
        boolean escaped = false;
        for (int i = startQuote + 1; i < json.length(); i++) {
            char c = json.charAt(i);
            if (escaped) {
                switch (c) {
                    case 'n': sb.append('\n'); break;
                    case 'r': sb.append('\r'); break;
                    case 't': sb.append('\t'); break;
                    case 'b': sb.append('\b'); break;
                    case 'f': sb.append('\f'); break;
                    case '\\': sb.append('\\'); break;
                    case '"': sb.append('"'); break;
                    case '/': sb.append('/'); break;
                    case 'u':
                        if (i + 4 < json.length()) {
                            String hex = json.substring(i + 1, i + 5);
                            try {
                                sb.append((char) Integer.parseInt(hex, 16));
                            } catch (NumberFormatException e) {
                                sb.append("\\u").append(hex);
                            }
                            i += 4;
                        }
                        break;
                    default: sb.append(c);
                }
                escaped = false;
            } else if (c == '\\') {
                escaped = true;
            } else if (c == '"') {
                break; // End of string
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}

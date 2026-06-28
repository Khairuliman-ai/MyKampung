package controller;

import model.Pengguna;
import model.LaporanSnapshot;
import dao.LaporanSnapshotDAO;
import service.AnalyticsService;
import util.GeminiUtil;

import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.util.Calendar;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LaporanServlet", urlPatterns = {"/laporan/view", "/laporan/ai/generate", "/laporan/snapshot/save"})
/**
 * LaporanServlet manages report aggregation, monthly snapshots, and AI analytics generation.
 * It provides role-based statistics on population, complaints, welfare requests, and facility bookings.
 * 
 * <h3>Endpoints:</h3>
 * <ul>
 *   <li>{@code /laporan/view} - Compiles role-based analytics data and forwards to the reports view JSP.</li>
 *   <li>{@code /laporan/ai/generate} - Triggers Gemini AI to analyze raw metrics and generate a PDF executive report (Ketua Kampung only).</li>
 *   <li>{@code /laporan/snapshot/save} - Persists the current month's analytics snapshot to the database for historical audit trail (Ketua Kampung only).</li>
 * </ul>
 */
public class LaporanServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LaporanServlet.class.getName());
    private final AnalyticsService analyticsService = new AnalyticsService();
    private final LaporanSnapshotDAO snapshotDao = new LaporanSnapshotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        LOGGER.log(Level.INFO, "LaporanServlet [GET] - servletPath: {0}, pathInfo: {1}, requestURI: {2}",
                new Object[]{servletPath, pathInfo, request.getRequestURI()});
        
        HttpSession session = request.getSession();
        Pengguna user = (session != null) ? (Pengguna) session.getAttribute("currentUser") : null;

        if (user == null) {
            LOGGER.log(Level.WARNING, "LaporanServlet [GET] - Akses ditolak: Sesi pengguna kosong. Mengalihkan ke halaman utama.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String role = user.getNama_peranan(); // e.g. "Ketua Kampung", "AJK Kampung"
        String biro = user.getNama_jawatan(); // e.g. "Setiausaha", "Biro Kebajikan & Sosial", etc.

        LOGGER.log(Level.INFO, "LaporanServlet [GET] - Sesi Sah: Pengguna {0} ({1}) mengakses analitik.",
                new Object[]{user.getNama_penuh(), role});

        // Restrict Penduduk role from accessing reports
        if (!"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
            LOGGER.log(Level.WARNING, "LaporanServlet [GET] - Akses ditolak: Peranan {0} tidak dibenarkan mengakses laporan.", role);
            response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
            return;
        }

        Map<String, Object> analyticsData = analyticsService.getAnalyticsDataForRole(role, biro);
        
        // Expose all data to request attributes
        for (Map.Entry<String, Object> entry : analyticsData.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }

        LOGGER.log(Level.INFO, "LaporanServlet [GET] - Memajukan ke /views/laporan/laporanAnalitik.jsp");
        request.getRequestDispatcher("/views/laporan/laporanAnalitik.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        LOGGER.log(Level.INFO, "LaporanServlet [POST] - servletPath: {0}, pathInfo: {1}, requestURI: {2}", 
                new Object[]{servletPath, pathInfo, request.getRequestURI()});
        
        HttpSession session = request.getSession();
        Pengguna user = (session != null) ? (Pengguna) session.getAttribute("currentUser") : null;

        if (user == null) {
            LOGGER.log(Level.WARNING, "LaporanServlet [POST] - Sesi tamat atau pengguna tidak sah.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"reply\":\"Sesi anda telah tamat. Sila log masuk semula.\",\"error\":true}");
            return;
        }

        boolean isAiGenerate = "/laporan/ai/generate".equals(servletPath) || "/ai/generate".equals(pathInfo);
        boolean isSnapshotSave = "/laporan/snapshot/save".equals(servletPath) || "/snapshot/save".equals(pathInfo);

        if (isAiGenerate) {
            LOGGER.log(Level.INFO, "LaporanServlet [POST] - Mengendalikan penjanaan AI oleh pengguna: {0}", user.getNama_penuh());
            handleAIGenerate(request, response, user);
        } else if (isSnapshotSave) {
            LOGGER.log(Level.INFO, "LaporanServlet [POST] - Mengendalikan penyimpanan snapshot sejarah oleh pengguna: {0}", user.getNama_penuh());
            handleSaveSnapshot(request, response, user);
        } else {
            LOGGER.log(Level.WARNING, "LaporanServlet [POST] - Laluan tidak dikenali. Menghantar ralat HTTP 404. servletPath: {0}, pathInfo: {1}", 
                    new Object[]{servletPath, pathInfo});
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleAIGenerate(HttpServletRequest request, HttpServletResponse response, Pengguna user)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Security check: Only Ketua Kampung can generate AI analysis
        if (!"Ketua Kampung".equalsIgnoreCase(user.getNama_peranan())) {
            LOGGER.log(Level.WARNING, "LaporanServlet [AI] - Akses disekat: Pengguna {0} berstatus peranan {1} (Bukan Ketua Kampung).", 
                    new Object[]{user.getNama_penuh(), user.getNama_peranan()});
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"reply\":\"Akses disekat. Hanya Ketua Kampung boleh menjana ulasan AI.\",\"error\":true}");
            out.flush();
            return;
        }

        String reportType = request.getParameter("reportType"); // "kebajikan", "aduan", "fasiliti", "eksekutif"
        if (reportType == null || reportType.trim().isEmpty()) {
            reportType = "eksekutif";
        }

        LOGGER.log(Level.INFO, "LaporanServlet [AI] - Memulakan penjanaan laporan AI. Jenis laporan: {0}", reportType);

        try {
            // Gather all analytics data
            LOGGER.log(Level.INFO, "LaporanServlet [AI] - Mengumpul data analitik untuk prompt AI...");
            Map<String, Object> data = analyticsService.getAnalyticsDataForRole("Ketua Kampung", null);
            String systemPrompt = analyticsService.buildAIPrompt(data, reportType);

            LOGGER.log(Level.INFO, "LaporanServlet [AI] - Mengirim permintaan chat ke utiliti GeminiUtil...");
            // Call Gemini
            String reply = GeminiUtil.chat(systemPrompt, new java.util.ArrayList<>(), "Sila mulakan penjanaan laporan sekarang berdasarkan garis panduan yang ditetapkan.");

            // Dynamically detect connection or configuration errors returned by GeminiUtil.chat
            boolean isError = reply != null && (reply.startsWith("Maaf, ") || reply.startsWith("Gagal "));
            
            String structuredJson = null;
            HttpSession session = request.getSession();
            if (!isError && "eksekutif_json".equalsIgnoreCase(reportType)) {
                structuredJson = sanitizeAIJsonResponse(reply);
                if (structuredJson != null) {
                    try {
                        // Validate parsing
                        JsonObject jsonObject = JsonParser.parseString(structuredJson).getAsJsonObject();
                        
                        // Store the executive summary in session so it can be saved in the monthly snapshot
                        if (jsonObject.has("executive_summary")) {
                            session.setAttribute("latest_ai_executive_summary", jsonObject.get("executive_summary").getAsString());
                        }
                        // Also store the entire structured report in session for the dashboard widget
                        session.setAttribute("latest_ai_structured_report", structuredJson);
                    } catch (Exception parseEx) {
                        LOGGER.log(Level.WARNING, "LaporanServlet [AI] - Gagal menghuraikan JSON AI: " + parseEx.getMessage());
                        isError = true;
                        reply = "Gagal memproses maklumat AI kerana format tindak balas yang tidak sah.";
                    }
                } else {
                    isError = true;
                    reply = "Gagal memproses maklumat AI kerana maklum balas bukan dalam format JSON.";
                }
            }

            if (isError) {
                LOGGER.log(Level.WARNING, "LaporanServlet [AI] - Ralat dikesan semasa panggilan Gemini API atau proses JSON: {0}", reply);
                String escapedReply = escapeJson(reply);
                out.print("{\"reply\":\"" + escapedReply + "\",\"error\":true}");
            } else {
                LOGGER.log(Level.INFO, "LaporanServlet [AI] - Penjanaan laporan AI berjaya diselesaikan.");
                if ("eksekutif_json".equalsIgnoreCase(reportType) && structuredJson != null) {
                    out.print("{\"reply\":\"" + escapeJson(reply) + "\",\"structured_report\":" + structuredJson + ",\"error\":false}");
                } else {
                    String escapedReply = escapeJson(reply);
                    out.print("{\"reply\":\"" + escapedReply + "\",\"error\":false}");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "LaporanServlet [AI] - Ralat teruk dikesan semasa menjana laporan AI: " + e.getMessage(), e);
            // Do NOT set response.setStatus(500) to prevent Tomcat from replacing the JSON response with its HTML error page.
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"reply\":\"Gagal menjana laporan AI disebabkan ralat dalaman: " + escapeJson(e.getMessage()) + "\",\"error\":true}");
        } finally {
            out.flush();
        }
    }

    private String sanitizeAIJsonResponse(String raw) {
        if (raw == null) return null;
        raw = raw.trim();
        // Remove markdown block wraps: ```json ... ``` or ``` ... ```
        if (raw.startsWith("```")) {
            int firstLineBreak = raw.indexOf("\n");
            if (firstLineBreak != -1) {
                raw = raw.substring(firstLineBreak).trim();
            } else {
                raw = raw.substring(3).trim();
            }
        }
        if (raw.endsWith("```")) {
            raw = raw.substring(0, raw.length() - 3).trim();
        }
        
        // Ensure it looks like a JSON object
        if (raw.startsWith("{") && raw.endsWith("}")) {
            return raw;
        }
        
        // If not, try to find the first '{' and last '}'
        int firstBrace = raw.indexOf("{");
        int lastBrace = raw.lastIndexOf("}");
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            return raw.substring(firstBrace, lastBrace + 1);
        }
        
        return null;
    }

    @SuppressWarnings("unchecked")
    private void handleSaveSnapshot(HttpServletRequest request, HttpServletResponse response, Pengguna user)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Security check: Only Ketua Kampung can save snapshots
        if (!"Ketua Kampung".equalsIgnoreCase(user.getNama_peranan())) {
            LOGGER.log(Level.WARNING, "LaporanServlet [Snapshot] - Akses disekat: Pengguna {0} berstatus peranan {1} cuba menyimpan snapshot.", 
                    new Object[]{user.getNama_penuh(), user.getNama_peranan()});
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"message\":\"Akses disekat. Hanya Ketua Kampung boleh menyimpan snapshot.\",\"success\":false}");
            out.flush();
            return;
        }

        try {
            Calendar cal = Calendar.getInstance();
            int tahun = cal.get(Calendar.YEAR);
            int bulan = cal.get(Calendar.MONTH) + 1; // 1-12

            LOGGER.log(Level.INFO, "LaporanServlet [Snapshot] - Memulakan penyimpanan snapshot untuk tempoh: {0}/{1}", 
                    new Object[]{bulan, tahun});

            Map<String, Object> stats = analyticsService.getAnalyticsDataForRole("Ketua Kampung", null);
            
            LaporanSnapshot s = new LaporanSnapshot();
            s.setTahun(tahun);
            s.setBulan(bulan);
            s.setTotal_penduduk((Integer) stats.getOrDefault("totalPenduduk", 0));
            s.setTotal_bantuan_dipohon((Integer) stats.getOrDefault("totalBantuan", 0));
            
            Map<String, Integer> banStats = (Map<String, Integer>) stats.get("bantuanSummaryStats");
            int totalBantuanDiluluskan = 0;
            if (banStats != null) {
                totalBantuanDiluluskan = banStats.getOrDefault("LULUS", 0);
            }
            s.setTotal_bantuan_diluluskan(totalBantuanDiluluskan);

            Map<String, Integer> aduStats = (Map<String, Integer>) stats.get("aduanSummaryStats");
            int totalAduanDiterima = 0;
            int totalAduanSelesai = 0;
            if (aduStats != null) {
                // Sum up all complaints
                for (int count : aduStats.values()) {
                    totalAduanDiterima += count;
                }
                totalAduanSelesai = aduStats.getOrDefault("RESOLVED", 0) + aduStats.getOrDefault("CLOSED", 0);
            }
            s.setTotal_aduan_diterima(totalAduanDiterima);
            s.setTotal_aduan_selesai(totalAduanSelesai);
            s.setTotal_tempahan_fasiliti((Integer) stats.getOrDefault("totalTempahan", 0));
            s.setPurata_pendapatan((Double) stats.getOrDefault("averageIncome", 0.0));

            // Retrieve and set session-cached AI summary
            HttpSession session = request.getSession();
            String aiSummary = (String) session.getAttribute("latest_ai_executive_summary");
            if (aiSummary != null) {
                s.setAi_executive_summary(aiSummary);
            }

            boolean success = snapshotDao.insertSnapshot(s);
            if (success) {
                LOGGER.log(Level.INFO, "LaporanServlet [Snapshot] - Snapshot bulanan {0}/{1} berjaya disimpan ke pangkalan data.", 
                        new Object[]{bulan, tahun});
                out.print("{\"message\":\"Snapshot sejarah bagi bulan " + bulan + "/" + tahun + " berjaya disimpan!\",\"success\":true}");
            } else {
                LOGGER.log(Level.WARNING, "LaporanServlet [Snapshot] - Gagal menyimpan snapshot bulanan {0}/{1} ke pangkalan data (Kemungkinan rekod unik tahun/bulan telah wujud).", 
                        new Object[]{bulan, tahun});
                out.print("{\"message\":\"Gagal menyimpan snapshot ke pangkalan data. Rekod untuk bulan ini mungkin sudah wujud.\",\"success\":false}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "LaporanServlet [Snapshot] - Ralat teruk semasa menyimpan snapshot bulanan: " + e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"message\":\"Ralat dalaman dikesan semasa menyimpan snapshot.\",\"success\":false}");
        } finally {
            out.flush();
        }
    }

    private String escapeJson(String text) {
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
                        String t = "000" + java.lang.Integer.toHexString(ch);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(ch);
                    }
            }
        }
        return sb.toString();
    }
}

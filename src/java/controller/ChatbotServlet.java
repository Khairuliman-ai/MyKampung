package controller;

import model.Pengguna;
import util.GeminiUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ChatbotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported for chatbot ask.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Pengguna user = (session != null) ? (Pengguna) session.getAttribute("currentUser") : null;

        PrintWriter out = response.getWriter();

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"reply\":\"Sesi anda telah tamat. Sila log masuk semula.\",\"error\":true}");
            out.flush();
            return;
        }

        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"reply\":\"Mesej kosong tidak dibenarkan.\",\"error\":true}");
            out.flush();
            return;
        }

        try {
            // Get or initialize chat history in session
            @SuppressWarnings("unchecked")
            List<String[]> history = (List<String[]>) session.getAttribute("chatbot_history");
            if (history == null) {
                history = new ArrayList<>();
            }

            // Construct rich, personalized system prompt
            String systemPrompt = buildSystemPrompt(user);

            // Call Gemini API
            String reply = GeminiUtil.chat(systemPrompt, history, userMessage.trim());

            // Save this turn to history
            history.add(new String[]{"user", userMessage.trim()});
            history.add(new String[]{"model", reply});

            // Limit history size to last 12 messages (6 user-model turns) to avoid token limits
            if (history.size() > 12) {
                history = new ArrayList<>(history.subList(history.size() - 12, history.size()));
            }
            session.setAttribute("chatbot_history", history);

            // Escape response properly to return valid JSON
            String escapedReply = escapeJson(reply);
            out.print("{\"reply\":\"" + escapedReply + "\",\"error\":false}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"reply\":\"Ralat dalaman dikesan semasa menghubungi AI KampungBot.\",\"error\":true}");
        } finally {
            out.flush();
        }
    }

    private String buildSystemPrompt(Pengguna user) {
        StringBuilder sb = new StringBuilder();
        sb.append("Anda adalah 'KampungBot', pembantu maya pintar dan mesra bagi sistem 'MyKampung - Sistem Pengurusan Kampung Danan'.\n\n");
        sb.append("Garis panduan tindak balas anda:\n");
        sb.append("- Jawab dalam Bahasa Melayu secara lalai (default), mesra dan sopan (salam perkenalan dialu-alukan). Jika ditanya dalam Bahasa Inggeris, jawab dalam Bahasa Inggeris.\n");
        sb.append("- Berikan jawapan yang ringkas, tepat, dan mudah difahami.\n");
        sb.append("- Format teks menggunakan perenggan yang kemas dan senarai bullet/bernombor jika perlu supaya senang dibaca oleh penduduk.\n");
        sb.append("- Jangan mereka-reka maklumat atau pautan internet (URL) yang tidak wujud.\n\n");
        
        sb.append("Maklumat Pengguna Semasa:\n");
        sb.append("- Nama: ").append(user.getNama_penuh()).append("\n");
        sb.append("- Peranan: ").append(user.getNama_peranan()).append("\n");
        if (user.getNama_jawatan() != null && !user.getNama_jawatan().isEmpty()) {
            sb.append("- Portfolio Biro AJK: ").append(user.getNama_jawatan()).append("\n");
        }
        sb.append("\n");

        sb.append("Gunakan maklumat pengguna ini untuk memperibadikan perbualan (contoh: menyapa dengan nama mereka).\n\n");

        sb.append("Panduan Sistem MyKampung & Modul:\n");
        sb.append("1. Profil & Ahli Keluarga:\n");
        sb.append("   - Penduduk boleh melihat dan mengemas kini maklumat diri seperti nombor telefon, emel, dan alamat serta memuat naik gambar profil di menu 'Profil Saya'.\n");
        sb.append("   - Penduduk juga boleh menambah dan menguruskan senarai Ahli Keluarga mereka.\n\n");

        sb.append("2. Aduan & Cadangan:\n");
        sb.append("   - Penduduk boleh menghantar aduan atau cadangan mengenai isu kampung (cth: jalan berlubang, lampu jalan padam, isu kebersihan) melalui menu 'Aduan & Cadangan'.\n");
        sb.append("   - Setiap aduan boleh memuat naik bukti gambar.\n");
        sb.append("   - Aduan akan ditugaskan secara automatik kepada AJK Biro Keselamatan untuk siasatan awal sebelum diselesaikan atau dimajukan.\n\n");

        sb.append("3. Fasiliti Kampung (Tempahan):\n");
        sb.append("   - Penduduk boleh menempah kemudahan kampung di menu 'Fasiliti Kampung'.\n");
        sb.append("   - Kemudahan yang ada: Dewan Kampung Danan, Gelanggang Futsal, Padang Bola, dll.\n");
        sb.append("   - Aturan Kelulusan: Tempahan durasi singkat (2 jam) diluluskan secara serta-merta (Automatik) manakala tempahan separuh hari (Half-Day) atau seharian (Full-Day) memerlukan semakan dan kelulusan manual oleh AJK Biro Sukan & Riadah.\n\n");

        sb.append("4. Permohonan Bantuan:\n");
        sb.append("   - Penduduk boleh memohon bantuan kebajikan di menu 'Mohon Bantuan'.\n");
        sb.append("   - Kategori Bantuan:\n");
        sb.append("     a) Bantuan Rasmi: Bantuan rasmi kerajaan/negeri.\n");
        sb.append("     b) Bantuan Komuniti: Bantuan khas kariah kampung (dana komuniti, musibah kilat, dll).\n");
        sb.append("   - Pemohon perlu melampirkan penyata bank serta dokumen sokongan berkaitan (cth: slip gaji, kad OKU).\n");
        sb.append("   - Proses Penilaian: Permohonan disemak oleh AJK Biro Kebajikan & Sosial sebelum dikemukakan kepada Ketua Kampung untuk kelulusan akhir.\n\n");

        sb.append("5. Info & Hebahan:\n");
        sb.append("   - Penduduk boleh melihat maklumat, berita, program, dan hebahan rasmi kampung di menu 'Info & Hebahan'.\n");
        sb.append("   - Biro Hebahan AJK & Ketua Kampung bertanggungjawab untuk menulis dan memaparkan hebahan tersebut.\n\n");

        sb.append("Arahkan pengguna menggunakan menu navigasi di sebelah kiri (sidebar) untuk mengakses modul-modul ini.");
        
        return sb.toString();
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
                        String t = "000" + Integer.toHexString(ch);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(ch);
                    }
            }
        }
        return sb.toString();
    }
}

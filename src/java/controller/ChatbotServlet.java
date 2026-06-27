package controller;

import model.Pengguna;
import util.GeminiUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * ChatbotServlet integrates the Gemini AI model to provide conversational assistance (KampungBot).
 * It manages session-based chat history, enforces a 12-message history cap (6 user-model turns)
 * to keep payload sizes reasonable, and feeds custom context for personalized support.
 */
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

    /**
     * Constructs a personalized system prompt for the Gemini AI model.
     * Incorporates current user's name, role, and biro to enable personalized responses.
     * Also feeds instructions and rules about the village management system.
     * 
     * @param user current authenticated user
     * @return system prompt instructions
     */
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

        appendPersonalContext(sb, user);
        appendAduanAdminContext(sb, user);
        appendBantuanAdminContext(sb, user);
        appendFasilitiAdminContext(sb, user);
        appendHebahanContext(sb, user);
        appendDashboardContext(sb, user);

        sb.append("Arahkan pengguna menggunakan menu navigasi di sebelah kiri (sidebar) untuk mengakses modul-modul ini.");
        
        return sb.toString();
    }

    private void appendPersonalContext(StringBuilder sb, Pengguna user) {
        sb.append("\n\nREKOD DIRI ANDA (Milik ").append(user.getNama_penuh()).append("):\n");

        // 1. Aduan
        dao.AduanDAO aduanDao = new dao.AduanDAO();
        List<model.Aduan> listAduan = aduanDao.getByPenduduk(user.getId_pengguna());
        sb.append("- Aduan Anda:\n");
        if (listAduan == null || listAduan.isEmpty()) {
            sb.append("  * Tiada aduan dihantar oleh anda.\n");
        } else {
            int count = 0;
            for (model.Aduan ad : listAduan) {
                if (count >= 20) break;
                sb.append("  * Tajuk: '").append(ad.getTajuk()).append("'")
                  .append(" [Status: ").append(ad.getStatus()).append("]")
                  .append(" (Keutamaan: ").append(ad.getKeutamaan()).append(")\n");
                count++;
            }
        }

        // 2. Bantuan
        dao.PermohonanBantuanDAO pbDao = new dao.PermohonanBantuanDAO();
        List<model.PermohonanBantuan> listBantuan = pbDao.getByPenduduk(user.getId_pengguna());
        sb.append("- Permohonan Bantuan Kewangan Anda:\n");
        if (listBantuan == null || listBantuan.isEmpty()) {
            sb.append("  * Tiada permohonan bantuan kebajikan dihantar.\n");
        } else {
            int count = 0;
            for (model.PermohonanBantuan pb : listBantuan) {
                if (count >= 20) break;
                sb.append("  * Program: '").append(pb.getNama_bantuan()).append("'")
                  .append(" [Status: ").append(pb.getStatus()).append("]\n");
                count++;
            }
        }

        // 3. Tempahan Fasiliti
        dao.TempahanFasilitiDAO tfDao = new dao.TempahanFasilitiDAO();
        List<model.TempahanFasiliti> listTempahan = tfDao.dapatkanSejarahTempahanPenduduk(user.getId_pengguna());
        sb.append("- Tempahan Fasiliti Anda:\n");
        if (listTempahan == null || listTempahan.isEmpty()) {
            sb.append("  * Tiada sejarah tempahan fasiliti.\n");
        } else {
            int count = 0;
            for (model.TempahanFasiliti tf : listTempahan) {
                if (count >= 20) break;
                String fasName = tf.getNama_fasiliti() != null ? tf.getNama_fasiliti() : "Fasiliti";
                sb.append("  * ").append(fasName)
                  .append(" pada ").append(tf.getTarikh_tempah())
                  .append(" (Masa: ").append(tf.getMasa_mula()).append(" - ").append(tf.getMasa_tamat()).append(")")
                  .append(" [Status: ").append(tf.getStatus()).append("]\n");
                count++;
            }
        }
    }

    private void appendAduanAdminContext(StringBuilder sb, Pengguna user) {
        boolean isKetuaKampung = "Ketua Kampung".equals(user.getNama_peranan());
        boolean isBiroKeselamatan = "AJK Kampung".equals(user.getNama_peranan()) && "Biro Keselamatan".equals(user.getNama_jawatan());

        if (isKetuaKampung || isBiroKeselamatan) {
            sb.append("\n\nMAKLUMAT PENTADBIRAN SULIT (Biro Keselamatan & Ketua Kampung sahaja):\n");
            dao.AduanDAO aduanDao = new dao.AduanDAO();
            java.util.Map<String, Integer> stats = aduanDao.getAduanSummaryStats();
            sb.append("Statistik Ringkas Aduan:\n");
            if (stats != null) {
                for (java.util.Map.Entry<String, Integer> entry : stats.entrySet()) {
                    sb.append("- ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
                }
            }
            List<model.Aduan> allAduan = aduanDao.getAll();
            sb.append("Senarai Aduan Aktif Terkini (Maksimum 20):\n");
            if (allAduan == null || allAduan.isEmpty()) {
                sb.append("- Tiada aduan aktif.\n");
            } else {
                int count = 0;
                for (model.Aduan ad : allAduan) {
                    if ("CLOSED".equals(ad.getStatus())) continue;
                    if (count >= 20) break;
                    String pengadu = ad.getNama_penuh() != null ? ad.getNama_penuh() : "Penduduk";
                    sb.append("- Pengadu: ").append(pengadu)
                      .append(", Tajuk: '").append(ad.getTajuk()).append("'")
                      .append(" [Keutamaan: ").append(ad.getKeutamaan()).append("]")
                      .append(" [Status: ").append(ad.getStatus()).append("]\n");
                    count++;
                }
                if (count == 0) {
                    sb.append("- Tiada aduan aktif.\n");
                }
            }
        }
    }

    private void appendBantuanAdminContext(StringBuilder sb, Pengguna user) {
        boolean isKetuaKampung = "Ketua Kampung".equals(user.getNama_peranan());
        boolean isSetiausaha = "AJK Kampung".equals(user.getNama_peranan()) && "Setiausaha".equals(user.getNama_jawatan());
        boolean isWelfare = "AJK Kampung".equals(user.getNama_peranan()) && "Biro Kebajikan & Sosial".equals(user.getNama_jawatan());

        if (isKetuaKampung || isSetiausaha || isWelfare) {
            sb.append("\n\nMAKLUMAT PENTADBIRAN SULIT (Biro Kebajikan, Setiausaha & Ketua Kampung sahaja):\n");
            dao.PermohonanBantuanDAO pbDao = new dao.PermohonanBantuanDAO();
            java.util.Map<String, Integer> stats = pbDao.getBantuanSummaryStats();
            sb.append("Statistik Permohonan Bantuan:\n");
            if (stats != null) {
                for (java.util.Map.Entry<String, Integer> entry : stats.entrySet()) {
                    sb.append("- ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
                }
            }
            List<model.PermohonanBantuan> list = pbDao.getAll();
            sb.append("Senarai Permohonan Bantuan Terkini (Maksimum 20):\n");
            if (list == null || list.isEmpty()) {
                sb.append("- Tiada permohonan bantuan kewangan.\n");
            } else {
                int count = 0;
                for (model.PermohonanBantuan pb : list) {
                    if (count >= 20) break;
                    String applicant = pb.getNama_penuh() != null ? pb.getNama_penuh() : "Penduduk Tidak Dikenali";
                    String aid = pb.getNama_bantuan() != null ? pb.getNama_bantuan() : "Bantuan Kewangan";
                    String status = pb.getStatus() != null ? pb.getStatus() : "BARU";
                    sb.append("- ").append(applicant)
                      .append(" (No. KP: ").append(pb.getNombor_kp() != null ? pb.getNombor_kp() : "-").append(")")
                      .append(" memohon '").append(aid).append("'")
                      .append(" [Status: ").append(status).append("]\n");
                    count++;
                }
            }
        }
    }

    private void appendFasilitiAdminContext(StringBuilder sb, Pengguna user) {
        boolean isKetuaKampung = "Ketua Kampung".equals(user.getNama_peranan());
        boolean isSukan = "AJK Kampung".equals(user.getNama_peranan()) && "Biro Sukan & Riadah".equals(user.getNama_jawatan());

        if (isKetuaKampung || isSukan) {
            sb.append("\n\nMAKLUMAT PENTADBIRAN SULIT (Biro Sukan & Riadah & Ketua Kampung sahaja):\n");
            dao.FasilitiDAO fasDao = new dao.FasilitiDAO();
            List<model.Fasiliti> listFas = fasDao.dapatkanSemuaFasiliti();
            sb.append("Senarai Fasiliti Kampung:\n");
            if (listFas != null) {
                for (model.Fasiliti f : listFas) {
                    sb.append("- ").append(f.getNama_fasiliti())
                      .append(" di ").append(f.getLokasi())
                      .append(" [Status: ").append(f.getStatus()).append("]\n");
                }
            }
            dao.TempahanFasilitiDAO tfDao = new dao.TempahanFasilitiDAO();
            int pendingBookings = tfDao.countByStatus("MENUNGGU");
            sb.append("Jumlah Tempahan Menunggu Kelulusan: ").append(pendingBookings).append("\n");

            java.util.Map<String, Integer> usageStats = tfDao.getFasilitiUsageStats();
            sb.append("Statistik Penggunaan Fasiliti (Jumlah Tempahan):\n");
            if (usageStats != null) {
                for (java.util.Map.Entry<String, Integer> entry : usageStats.entrySet()) {
                    sb.append("- ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
                }
            }
        }
    }

    private void appendHebahanContext(StringBuilder sb, Pengguna user) {
        dao.HebahanDAO hebahanDao = new dao.HebahanDAO();
        List<model.Hebahan> listPub = hebahanDao.getPublished();
        sb.append("\n\nINFO & HEBAHAN TERKINI KAMPUNG:\n");
        if (listPub == null || listPub.isEmpty()) {
            sb.append("- Tiada sebarang hebahan aktif buat masa ini.\n");
        } else {
            int count = 0;
            for (model.Hebahan h : listPub) {
                if (count >= 5) break;
                sb.append("- Tajuk: '").append(h.getTajuk()).append("'")
                  .append(" (Kategori: ").append(h.getKategori()).append(")")
                  .append(" pada ").append(h.getTarikh_hebahan()).append("\n");
                count++;
            }
        }

        boolean isKetuaKampung = "Ketua Kampung".equals(user.getNama_peranan());
        boolean isHebahanAJK = "AJK Kampung".equals(user.getNama_peranan()) && "Biro Hebahan".equals(user.getNama_jawatan());

        if (isKetuaKampung || isHebahanAJK) {
            sb.append("\nMAKLUMAT PENTADBIRAN SULIT (Biro Hebahan & Ketua Kampung sahaja):\n");
            int draftCount = hebahanDao.countByStatus("Draft");
            int pubCount = hebahanDao.countByStatus("Published");
            int archCount = hebahanDao.countByStatus("Archived");
            sb.append("- Hebahan Deraf (Draft): ").append(draftCount).append("\n");
            sb.append("- Hebahan Diterbitkan (Published): ").append(pubCount).append("\n");
            sb.append("- Hebahan Diarkibkan (Archived): ").append(archCount).append("\n");
        }
    }

    private void appendDashboardContext(StringBuilder sb, Pengguna user) {
        boolean isKetuaKampung = "Ketua Kampung".equals(user.getNama_peranan());
        boolean isSetiausaha = "AJK Kampung".equals(user.getNama_peranan()) && "Setiausaha".equals(user.getNama_jawatan());

        if (isKetuaKampung || isSetiausaha) {
            sb.append("\n\nMAKLUMAT PENGURUSAN TINGGI (Ketua Kampung & Setiausaha sahaja):\n");
            dao.PenggunaDAO uDao = new dao.PenggunaDAO();
            sb.append("- Jumlah Keseluruhan Penduduk: ").append(uDao.countAll()).append("\n");
            sb.append("- Purata Pendapatan Penduduk: RM ").append(String.format("%.2f", uDao.getAverageIncome())).append("\n");

            List<model.Pengguna> pendingList = uDao.getPendingPenduduk();
            int pendingCount = (pendingList != null) ? pendingList.size() : 0;
            sb.append("- Permohonan Pendaftaran Akaun Penduduk Baharu Menunggu Kelulusan: ").append(pendingCount).append("\n");

            java.util.Map<String, Integer> ageDist = uDao.getAgeDistribution();
            sb.append("Taburan Umur Penduduk:\n");
            if (ageDist != null) {
                for (java.util.Map.Entry<String, Integer> entry : ageDist.entrySet()) {
                    sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
                }
            }

            java.util.Map<String, Integer> incDist = uDao.getIncomeDistribution();
            sb.append("Taburan Pendapatan Penduduk:\n");
            if (incDist != null) {
                for (java.util.Map.Entry<String, Integer> entry : incDist.entrySet()) {
                    sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
                }
            }
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

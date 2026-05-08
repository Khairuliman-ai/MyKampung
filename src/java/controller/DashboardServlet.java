package controller;

import model.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.AduanDAO;
import dao.HebahanDAO;
import dao.PermohonanBantuanDAO;
import dao.TempahanFasilitiDAO;
import dao.PenggunaDAO;
import util.DBUtil;
import model.Aduan;
import model.Hebahan;
import model.PermohonanBantuan;
import model.TempahanFasiliti;
import model.Pengguna;
import java.sql.Connection;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

/**
 * DashboardServlet bertindak sebagai pengawal (Gatekeeper) untuk menghantar
 * pengguna ke paparan dashboard yang betul berdasarkan peranan dan biro
 * masing-masing.
 */
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Dapatkan session sedia ada (jangan cipta session baru jika tiada)
        HttpSession session = request.getSession(false);
        Pengguna user = (session != null) ? (Pengguna) session.getAttribute("currentUser") : null;

        /**
         * * 2. Sekuriti Tahap 1: Semakan Sesi dan Status Pengguna
         * Jika sesi tamat, atau user null, atau status bukan 1 (Aktif), tamatkan sesi.
         */
        if (user == null || user.getStatus() != 1) {
            if (session != null) {
                session.invalidate(); // Bersihkan sesi jika status tidak aktif
            }
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp?error=unauthorized");
            return;
        }

        // 3. Ambil maklumat Peranan dan Biro (Data diperoleh melalui JOIN di
        // PenggunaDAO) [cite: 22, 38]
        String peranan = user.getNama_peranan();
        String biro = user.getNama_jawatan();

        // --- 4. LOGIK ROUTING DASHBOARD (MVC Forwarding) ---

        if ("Pentadbir Sistem".equals(peranan)) {
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } else if ("Ketua Kampung".equals(peranan)) {
            request.getRequestDispatcher("/views/dashboard/ketuaDashboard.jsp").forward(request, response);
        } else if ("AJK Kampung".equals(peranan)) {
            /**
             * Penapis Biro Spesifik:
             * Memastikan AJK Keselamatan, Kebajikan, dll. pergi ke dashboard portfolio
             * masing-masing.
             */
            if ("Setiausaha".equals(biro)) {
                request.getRequestDispatcher("/views/dashboard/setiausahaDashboard.jsp").forward(request, response);
            } else if ("Biro Kebajikan & Sosial".equals(biro)) {
                request.getRequestDispatcher("/views/dashboard/biroKebajikanDashboard.jsp").forward(request, response);
            } else if ("Biro Sukan & Riadah".equals(biro)) {
                request.getRequestDispatcher("/views/dashboard/biroSukanDashboard.jsp").forward(request, response);
            } else if ("Biro Keselamatan".equals(biro)) {
                request.getRequestDispatcher("/views/dashboard/biroKeselamatanDashboard.jsp").forward(request, response);
            } else if ("Biro Hebahan".equals(biro)) {
                request.getRequestDispatcher("/views/dashboard/biroHebahanDashboard.jsp").forward(request, response);
            } else {
                // Default dashboard if biro-specific one doesn't exist
                request.getRequestDispatcher("/views/dashboard/setiausahaDashboard.jsp").forward(request, response);
            }
        } else if ("Penduduk".equals(peranan)) {
            // Fetch data for Resident Dashboard
            AduanDAO aduanDao = new AduanDAO();
            HebahanDAO hebahanDao = new HebahanDAO();
            PermohonanBantuanDAO bantuanDao = new PermohonanBantuanDAO();
            TempahanFasilitiDAO fasilitiDao = new TempahanFasilitiDAO();

            int userId = user.getId_pengguna();

            // 1. Latest 3 Announcements
            List<Hebahan> latestHebahan = hebahanDao.getPublished();
            if (latestHebahan.size() > 3) latestHebahan = latestHebahan.subList(0, 3);
            request.setAttribute("latestHebahan", latestHebahan);

            // 2. Complaints stats for user
            List<Aduan> userAduan = aduanDao.getByPenduduk(userId);
            long pendingAduan = userAduan.stream().filter(a -> !"RESOLVED".equals(a.getStatus()) && !"REJECTED".equals(a.getStatus())).count();
            request.setAttribute("totalAduan", userAduan.size());
            request.setAttribute("pendingAduan", pendingAduan);
            request.setAttribute("userAduan", userAduan);

            // 3. Bantuan apps
            List<PermohonanBantuan> userBantuan = bantuanDao.getByPenduduk(userId);
            request.setAttribute("totalBantuan", userBantuan.size());
            request.setAttribute("userBantuan", userBantuan);

            // 4. Facility Bookings
            List<TempahanFasiliti> userTempahan = fasilitiDao.dapatkanSejarahTempahanPenduduk(userId);
            long activeTempahan = userTempahan.stream().filter(t -> "LULUS".equals(t.getStatus()) || "MENUNGGU".equals(t.getStatus())).count();
            request.setAttribute("totalTempahan", userTempahan.size());
            request.setAttribute("activeTempahan", activeTempahan);
            request.setAttribute("userTempahan", userTempahan);

            // 5. AJK List for sidebar
            try (Connection conn = DBUtil.getConnection()) {
                PenggunaDAO pDao = new PenggunaDAO(conn);
                List<Pengguna> ajkList = pDao.getAllAJK();
                request.setAttribute("ajkList", ajkList);
            } catch (Exception e) {
                e.printStackTrace();
            }

            request.getRequestDispatcher("/views/dashboard/pendudukDashboard.jsp").forward(request, response);
        } else {
            // Jika peranan tidak dikenali, hantar balik ke login
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Alirkan permintaan POST ke doGet
        doGet(request, response);
    }
}
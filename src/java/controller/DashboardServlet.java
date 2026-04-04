package controller;

import model.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * DashboardServlet bertindak sebagai pengawal (Gatekeeper) untuk menghantar 
 * pengguna ke paparan dashboard yang betul berdasarkan peranan dan biro masing-masing.
 */
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Dapatkan session sedia ada (jangan cipta session baru jika tiada)
        HttpSession session = request.getSession(false);
        Pengguna user = (session != null) ? (Pengguna) session.getAttribute("currentUser") : null;

        /** * 2. Sekuriti Tahap 1: Semakan Sesi dan Status Pengguna 
         * Jika sesi tamat, atau user null, atau status bukan 1 (Aktif), tamatkan sesi.
         */
        if (user == null || user.getStatus() != 1) {
            if (session != null) {
                session.invalidate(); // Bersihkan sesi jika status tidak aktif
            }
            response.sendRedirect("auth.jsp?error=unauthorized");
            return;
        }

        // 3. Ambil maklumat Peranan dan Biro (Data diperoleh melalui JOIN di PenggunaDAO) [cite: 22, 38]
        String peranan = user.getNama_peranan();
        String biro = user.getNama_jawatan(); 

        // --- 4. LOGIK ROUTING DASHBOARD (MVC Forwarding) ---
        
        if ("Pentadbir Sistem".equals(peranan)) {
            request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
        } 
        else if ("Ketua Kampung".equals(peranan)) {
            request.getRequestDispatcher("views/dashboard/dKetuaKampung.jsp").forward(request, response);
        } 
        else if ("AJK Kampung".equals(peranan)) {
            /**
             * Penapis Biro Spesifik:
             * Memastikan AJK Keselamatan, Kebajikan, dll. pergi ke dashboard portfolio masing-masing.
             */
            if ("Setiausaha".equals(biro)) {
                request.getRequestDispatcher("views/dashboard/dJKKK.jsp").forward(request, response);
            } 
            else if ("Biro Kebajikan & Sosial".equals(biro)) {
                request.getRequestDispatcher("views/dashboard/dKebajikan.jsp").forward(request, response);
            } 
            else if ("Biro Sukan & Riadah".equals(biro)) {
                request.getRequestDispatcher("ajk/sukan_dashboard.jsp").forward(request, response);
            } 
            else if ("Biro Agama & Da'wah".equals(biro)) {
                request.getRequestDispatcher("ajk/agama_dashboard.jsp").forward(request, response);
            }
            else {
                // Untuk biro lain seperti Ekonomi/Pembangunan
                request.getRequestDispatcher("ajk/umum_dashboard.jsp").forward(request, response);
            }
        } 
        else if ("Penduduk".equals(peranan)) {
            request.getRequestDispatcher("views/dashboard/dPenduduk.jsp").forward(request, response);
        }
        else {
            // Jika peranan tidak dikenali, hantar balik ke login
            session.invalidate();
            response.sendRedirect("auth/auth.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Alirkan permintaan POST ke doGet
        doGet(request, response);
    }
}
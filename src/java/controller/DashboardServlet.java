package controller;

import model.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gunakan false supaya tidak create session baru jika session sudah tamat
        HttpSession session = request.getSession(false);

        // 1️⃣ Check session - Mesti guna "userSession" (sama seperti LoginServlet)
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // Ambil objek dari session
        Pengguna user = (Pengguna) session.getAttribute("userSession");
        
        // Memandangkan ERD baru menggunakan Pengguna_Peranan, 
        // pastikan anda ada cara untuk dapatkan 'role'. 
        // Jika anda simpan 'jawatan' dalam model Pengguna, kod ini kekal:
        String role = user.getJawatan(); 

        // 2️⃣ Role-based dashboard routing
        if ("Penduduk".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/views/dashboard/dPenduduk.jsp")
                   .forward(request, response);

        } else if ("Ketua Kampung".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/views/dashboard/dKetuaKampung.jsp")
                   .forward(request, response);

        } else if ("JKKK".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/views/dashboard/dJKKK.jsp")
                   .forward(request, response);

        } else {
            // fallback if role unknown
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }
}
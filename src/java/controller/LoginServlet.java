package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // Tambah jika guna Tomcat 7+
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Ambil data dari borang login (Suaikan dengan name=".." dalam JSP anda)
        String nombor_kp = request.getParameter("nombor_kp");
        String kata_laluan = request.getParameter("kata_laluan");
        
        PenggunaDAO dao = new PenggunaDAO();
        
        // 2. Panggil method login dari DAO
        Pengguna user = dao.login(nombor_kp, kata_laluan);
        
        if (user != null) {
            // 3. Semak Status Penduduk
            if (user.getStatus() == 1) { 
                // STATUS AKTIF - Benarkan masuk
                HttpSession session = request.getSession();
                session.setAttribute("userSession", user);
                
                // Redirect ke dashboard (Suaikan path mengikut struktur folder anda)
                response.sendRedirect(request.getContextPath() + "/dashboard");
                
            } else if (user.getStatus() == 0) {
                // STATUS PENDING - Mesej tunggu pengesahan
                request.setAttribute("error", "Akaun anda masih menunggu pengesahan Ketua Kampung.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                
            } else {
                // STATUS DISEKAT/LAIN-LAIN
                request.setAttribute("error", "Akaun anda telah disekat. Sila hubungi pihak pentadbir.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
            
        } else {
            // LOGIN GAGAL - No KP atau Password salah
            request.setAttribute("error", "Nombor KP atau kata laluan salah.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }
}
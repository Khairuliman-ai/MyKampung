package controller;

import dao.PenggunaDAO;
import model.Pengguna;
import util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Ambil data dari form
        String kp = request.getParameter("nombor_kp");
        String password = request.getParameter("kata_laluan");

        // 2. Bersihkan No KP (PENTING: Gunakan noKpClean selepas ini)
        String noKpClean = (kp != null) ? kp.replaceAll("[^0-9]", "") : "";

        try (Connection conn = DBUtil.getConnection()) {
            // 3. Inisialisasi DAO dengan connection
            PenggunaDAO dao = new PenggunaDAO(conn);
            
            // 4. Panggil authenticate menggunakan noKpClean
            Pengguna user = dao.authenticate(noKpClean, password);

            if (user != null) {
                // 5. Simpan objek user ke dalam session
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                
                // 6. Redirect ke Dashboard
                response.sendRedirect("DashboardServlet");
            } else {
                // Gagal login
                request.setAttribute("errorMessage", "Log masuk gagal. Sila semak No. KP, Kata Laluan, atau pastikan akaun anda aktif.");
                request.getRequestDispatcher("auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Ralat sistem pangkalan data.");
            request.getRequestDispatcher("auth.jsp").forward(request, response);
        }
    }
    


    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Halang akses GET secara terus ke URL ini
        response.sendRedirect("auth.jsp");
    }
}
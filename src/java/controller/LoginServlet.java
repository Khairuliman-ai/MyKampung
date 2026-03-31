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
        
        // 1. Ambil hanya No KP dan Kata Laluan (Peranan dibuang)
        String kp = request.getParameter("nombor_kp");
        String password = request.getParameter("kata_laluan");

        try (Connection conn = DBUtil.getConnection()) {
            PenggunaDAO dao = new PenggunaDAO(conn);
            
            // 2. Panggil authenticate dengan 2 parameter sahaja
            // Sistem akan tarik peranan tertinggi secara automatik melalui SQL 'ORDER BY'
            Pengguna user = dao.authenticate(kp, password);

            if (user != null) {
                // 3. Simpan objek user yang sudah ada maklumat 'nama_peranan' & 'nama_jawatan'
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                
                // 4. Hantar ke DashboardServlet untuk urusan pengalihan biro/peranan
                response.sendRedirect("DashboardServlet");
            } else {
                // Jika user == null, bermaksud sama ada KP/Pass salah atau akaun tidak aktif (status=0)
                request.setAttribute("errorMessage", "Log masuk gagal. Sila semak No. KP, Kata Laluan, atau pastikan akaun anda aktif.");
                request.getRequestDispatcher("auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Ralat sistem pangkalan data. Sila cuba sebentar lagi.");
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
package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nomborKP = request.getParameter("nomborKP");
        String kataLaluan = request.getParameter("kataLaluan");
        try {
            PenggunaDAO dao = new PenggunaDAO();
            Pengguna user = dao.getByNomborKP(nomborKP);
            if (user != null && user.getKataLaluan().equals(kataLaluan)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/dashboard");

            } else {
                request.setAttribute("error", "Nombor KP atau kata laluan salah.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Ralat sambungan DB.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
        
        
    }
}
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // Tambah import ini
import javax.servlet.http.*;

@WebServlet("/logout") // <--- WAJIB TAMBAH INI
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Redirect ke login page
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
    }
}
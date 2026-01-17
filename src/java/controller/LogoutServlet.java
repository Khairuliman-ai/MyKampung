package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Dapatkan session sekarang, jika ada
        HttpSession session = request.getSession(false); // false supaya tak create baru
        if (session != null) {
            session.invalidate(); // hapus semua data session
        }
        
        // Redirect ke login page
        response.sendRedirect(request.getContextPath());
    }
}

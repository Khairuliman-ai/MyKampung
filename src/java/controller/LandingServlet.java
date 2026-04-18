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
 * LandingServlet handles the entry point for the application.
 * If the user is already logged in, it redirects to the Dashboard.
 * Otherwise, it shows the premium landing page.
 */
@WebServlet(name = "LandingServlet", urlPatterns = {"/home", "/index.jsp", ""})
public class LandingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
            return;
        }

        // 2. Otherwise, forward to the landing page JSP
        request.getRequestDispatcher("/views/landing/landing.jsp").forward(request, response);
    }
}
